//
//  ImageGenerationView.swift
//  UIMobileHelper
//
//  Created by Nikita Makhov on 24.09.2026.
//
import SwiftUI
import MessageUI

struct ImageGenerationView: View {
    let answers: SurveyAnswers
    let onCompleted: ([GeneratedMockup]) -> Void
    let onFailed: () -> Void

    @StateObject private var viewModel = ImageGeneratorVM()
    @State private var didStart = false
    @State private var showMailComposer = false
    @State private var showMailAlert = false

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
                Button("Сообщить об ошибке") {
                    if MFMailComposeViewController.canSendMail() {
                        showMailComposer = true
                    } else {
                        openMailFallback()
                    }
                }
                .buttonStyle(.plain)
                .padding(.top, 16)
            }
        }
        .padding()
        .task {
            guard !didStart else { return }
            didStart = true
            await viewModel.generateAll(for: answers)
            handleCompletionIfNeeded()
        }
        .sheet(isPresented: $showMailComposer) {
            MailComposeView(
                subject: "Сообщение об ошибке",
                recipients: ["uihelp@mail.ru"],
                body: bugReportBody
            )
        }
        .alert("Не удалось открыть почту", isPresented: $showMailAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("На устройстве не настроено почтовое приложение.")
        }
    }
    private var bugReportBody: String {
        """
        Опишите, что произошло:

        Ошибка:
        \(viewModel.errorMessage ?? "Неизвестно")

        Экран:
        \(viewModel.progressText)

        Устройство: \(UIDevice.current.model)
        iOS: \(UIDevice.current.systemVersion)
        """
    }
    private func openMailFallback() {
        let subject = "Сообщение об ошибке".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let body = bugReportBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let email = "uihelp@mail.ru"

        guard let url = URL(string: "mailto:\(email)?subject=\(subject)&body=\(body)"),
              UIApplication.shared.canOpenURL(url) else {
            showMailAlert = true
            return
        }

        UIApplication.shared.open(url)
    }

    private func handleCompletionIfNeeded() {
        if viewModel.errorMessage == nil && !viewModel.generatedMockups.isEmpty {
            onCompleted(viewModel.generatedMockups)
        } else if viewModel.errorMessage != nil {
            onFailed()
        }
    }
}
