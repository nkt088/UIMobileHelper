import SwiftUI
import Combine

struct GeneratedMockup: Hashable {
    let screenTitle: String
    let screenComment: String
    let imageURL: URL
}
@MainActor
final class ImageGeneratorVM: ObservableObject {
    @Published var generatedMockups: [GeneratedMockup] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var progressText = ""
    
    private let apiKey = "apikey"
    private let createURL = URL(string: "https://gptunnel.ru/v1/media/create")!
    private let resultURL = URL(string: "https://gptunnel.ru/v1/media/result")!

    func generateAll(for answers: SurveyAnswers) async {
        errorMessage = nil
        generatedMockups = []
        isLoading = true
        progressText = "Подготовка..."

        guard !answers.screens.isEmpty else {
            errorMessage = "Не выбраны экраны для генерации"
            isLoading = false
            return
        }

        let basePrompt = answers.basePrompt()

        do {
            for index in answers.screens.indices {
                let screen = answers.screens[index]
                progressText = "Генерация \(index + 1) из \(answers.screens.count): \(screen.title)"

                let fullPrompt = "\(basePrompt) \(answers.imagePrompt(for: index))"
                let taskID = try await createTask(prompt: fullPrompt)
                let finalURL = try await pollResult(taskID: taskID)

                generatedMockups.append(
                    GeneratedMockup(
                        screenTitle: screen.title,
                        screenComment: screen.comment,
                        imageURL: finalURL
                    )
                )
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func createTask(prompt: String) async throws -> String {
        var request = URLRequest(url: createURL)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(
            CreateRequest(
                model: "gpt-image-1-medium",
                prompt: prompt
            )
        )

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
            request.setValue(apiKey, forHTTPHeaderField: "Authorization")
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
struct ImageGenerationView: View {
    let answers: SurveyAnswers
    let onCompleted: ([GeneratedMockup]) -> Void
    let onFailed: () -> Void

    @StateObject private var viewModel = ImageGeneratorVM()
    @State private var didStart = false

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)

            Text("Создание макетов")
                .font(.title2.bold())

            Text(viewModel.progressText.isEmpty ? "Подождите..." : viewModel.progressText)
                .foregroundStyle(.secondary)

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)

                Button("Повторить") {
                    Task {
                        await viewModel.generateAll(for: answers)
                        handleCompletionIfNeeded()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .task {
            guard !didStart else { return }
            didStart = true
            await viewModel.generateAll(for: answers)
            handleCompletionIfNeeded()
        }
    }

    private func handleCompletionIfNeeded() {
        if viewModel.errorMessage == nil && !viewModel.generatedMockups.isEmpty {
            onCompleted(viewModel.generatedMockups)
        } else if viewModel.errorMessage != nil {
            onFailed()
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

