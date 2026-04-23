//
//  OnboardingView.swift
//  UIMobileHelper
//
//  Created by Nikita Makhov on 11.03.2026.
//

import SwiftUI
import MessageUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isFirstLaunch: Bool
    var showsSkipButton = true
    var showsQuestionsButton = false

    @State private var currentPage = 0
    @State private var showMailComposer = false
    @State private var showMailAlert = false

    private let pages: [OnboardingPage] = [
        .init(
            title: "Пройдите анкетирование",
            subtitle: "Выберите платформу, тему приложения и нужные экраны, чтобы получить рекомендации по интерфейсу.",
            imageName: "onboarding_1"
        ),
        .init(
            title: "Смотрите результат",
            subtitle: "Приложение сохранит прошлые прохождения и локальные изображения, чтобы вы могли открыть их позже.",
            imageName: "onboarding_2"
        ),
        .init(
            title: "Учебные материалы",
            subtitle: "Изучайте рекомендации и примеры интерфейсов, чтобы лучше понимать принципы дизайна.",
            imageName: "onboarding_3"
        )
    ]

    var body: some View {
        VStack {
            if showsSkipButton {
                HStack {
                    Spacer()
                    Button("Пропустить") {
                        finish()
                    }
                }
                .padding(.horizontal)
            }
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    VStack(spacing: 24) {
                        Image(pages[index].imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 260)

                        Text(pages[index].title)
                            .font(.title.bold())
                            .multilineTextAlignment(.center)

                        Text(pages[index].subtitle)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        Spacer()
                    }
                    .padding()
                    .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            Button {
                if currentPage == pages.count - 1 {
                    finish()
                } else {
                    currentPage += 1
                }
            } label: {
                Text(currentPage == pages.count - 1 ? "Начать" : "Далее")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.teal)
                    )
            }
            .padding()
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            if showsQuestionsButton {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Другие вопросы") {
                        if MFMailComposeViewController.canSendMail() {
                            showMailComposer = true
                        } else {
                            openMailFallback()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showMailComposer) {
            MailComposeView(
                subject: "Другие вопросы",
                recipients: ["uihelp@mail.ru"],
                body: mailBody
            )
        }
        .alert("Не удалось открыть почту", isPresented: $showMailAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("На устройстве не настроено почтовое приложение.")
        }
    }

    
    private var mailBody: String {
        """
        Здравствуйте.
        У меня есть вопрос по приложению:

        Устройство: \(UIDevice.current.model)
        iOS: \(UIDevice.current.systemVersion)
        """
    }
    
    private func openMailFallback() {
        let subject = "Другие вопросы".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let body = mailBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let email = "uihelp@mail.ru"

        guard let url = URL(string: "mailto:\(email)?subject=\(subject)&body=\(body)"),
              UIApplication.shared.canOpenURL(url) else {
            showMailAlert = true
            return
        }

        UIApplication.shared.open(url)
    }
    
    private func finish() {
        isFirstLaunch = false
        dismiss()
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let imageName: String
}
