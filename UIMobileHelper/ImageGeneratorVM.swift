import SwiftUI
import Combine

struct ImageGenerationView: View {
    @StateObject private var viewModel = ImageGeneratorVM()

    var body: some View {
        ProgressView()
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Промпт")
                            .font(.headline)

                        TextEditor(text: $viewModel.prompt)
                            .frame(minHeight: 140)
                            .padding(12)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    Button {
                        Task {
                            await viewModel.generate()
                        }
                    } label: {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                            }
                            Text(viewModel.isLoading ? "Генерация..." : "Сгенерировать")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isLoading || viewModel.prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if let imageURL = viewModel.imageURL {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Результат")
                                .font(.headline)

                            AsyncImage(url: imageURL) { phase in
                                switch phase {
                                case .empty:
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.thinMaterial)
                                        ProgressView()
                                    }
                                    .frame(height: 320)

                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 20))

                                case .failure:
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.thinMaterial)
                                        Text("Не удалось загрузить изображение")
                                    }
                                    .frame(height: 320)

                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Image-1 Medium")
        }
    }
}

@MainActor
final class ImageGeneratorVM: ObservableObject {
    @Published var prompt = ""
    @Published var imageURL: URL?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiKey = "API_KEY"
    private let createURL = URL(string: "https://gptunnel.ru/v1/media/create")!
    private let resultURL = URL(string: "https://gptunnel.ru/v1/media/result")!

    func generate() async {
        errorMessage = nil
        imageURL = nil
        isLoading = true

        do {
            let taskID = try await createTask(prompt: prompt)
            let finalURL = try await pollResult(taskID: taskID)
            imageURL = finalURL
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func createTask(prompt: String) async throws -> String {
        var request = URLRequest(url: createURL)
        request.httpMethod = "POST"
        request.setValue("\(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(CreateRequest(
            model: "gpt-image-1-medium",
            prompt: prompt
        ))

        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response, data: data)

        let decoded = try JSONDecoder().decode(CreateResponse.self, from: data)

        guard let id = decoded.id, !id.isEmpty else {
            throw APIError.invalidResponse("Сервер не вернул task id")
        }

        return id
    }

    private func pollResult(taskID: String) async throws -> URL {
        for _ in 0..<30 {
            try Task.checkCancellation()

            var request = URLRequest(url: resultURL)
            request.httpMethod = "POST"
            request.setValue("\(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(ResultRequest(taskID: taskID))

            let (data, response) = try await URLSession.shared.data(for: request)
            try validate(response: response, data: data)

            let decoded = try JSONDecoder().decode(ResultResponse.self, from: data)

            if decoded.status == "done", let urlString = decoded.url, let url = URL(string: urlString) {
                return url
            }

            if decoded.status == "failed" {
                throw APIError.invalidResponse("Генерация завершилась с ошибкой")
            }

            try await Task.sleep(nanoseconds: 2_000_000_000)
        }

        throw APIError.invalidResponse("Истекло время ожидания результата")
    }

    private func validate(response: URLResponse, data: Data) throws {
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse("Некорректный ответ сервера")
        }

        guard 200..<300 ~= http.statusCode else {
            let text = String(data: data, encoding: .utf8) ?? "HTTP \(http.statusCode)"
            throw APIError.invalidResponse(text)
        }
    }
}

private struct CreateRequest: Encodable {
    let model: String
    let prompt: String
}

private struct ResultRequest: Encodable {
    let taskID: String

    enum CodingKeys: String, CodingKey {
        case taskID = "task_id"
    }
}

private struct CreateResponse: Decodable {
    let code: Int?
    let id: String?
    let status: String?
    let url: String?
}

private struct ResultResponse: Decodable {
    let code: Int?
    let id: String?
    let status: String?
    let url: String?
}

private enum APIError: LocalizedError {
    case invalidResponse(String)

    var errorDescription: String? {
        switch self {
        case .invalidResponse(let message):
            return message
        }
    }
}

