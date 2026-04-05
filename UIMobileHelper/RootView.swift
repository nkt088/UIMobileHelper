//
//  ContentView.swift
//  UIMobileHelper
//
//  Created by Nikita Makhov on 11.03.2026.
//
//Cmd + Option + Enter - открыть закрыть изображение
//shift + cmd + l - icon settings
import SwiftUI


struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack {
                MainView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Главная")
            }

            NavigationStack {
                StudyMaterialView()
            }
            .tabItem {
                Image(systemName: "folder.fill")
                Text("Материалы")
            }
        }
    }
}

struct MainView: View {
    @State private var previousResults: [PreviousSurveyAnswers] = []

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                startCard

                if previousResults.isEmpty {
                    emptyState
                } else {
                    resultsSection
                }
            }
            .padding()
        }
        .navigationTitle("Главная")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("Помощь") {
                    OnboardingView(
                        isFirstLaunch: .constant(false),
                        showsSkipButton: false
                    )
                }
            }
        }
        .onAppear {
            //UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            previousResults = PreviousSurveyAnswersStore.shared.loadAll()
        }
    }

    private var startCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Получить рекомендации")
                .font(.title2.bold())

            Text("Пройдите анкетирование, чтобы получить рекомендации по интерфейсу и готовые варианты экранов.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            NavigationLink {
                SurveyFlowView()
            } label: {
                Text("Начать анкетирование")
                    .frame(maxWidth: .infinity, minHeight: 30)
                    .bold()
            }
            .buttonStyle(.borderedProminent)
            .padding(12)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 20))
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Прошлые прохождения")
                .font(.title3.bold())

            Text("Сохранённых результатов пока нет.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Прошлые прохождения")
                .font(.title3.bold())

            ForEach(previousResults.sorted(by: { $0.date > $1.date }), id: \.date) { item in
                NavigationLink {
                    SummaryView(
                        answers: item.answers,
                        generatedMockups: PreviousSurveyAnswersStore.shared.mockups(from: item)
                    )
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(item.answers.themeSelection.topic.title) / \(item.answers.themeSelection.subcategory.content.title)")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Text(item.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.background.secondary, in: RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
struct StudyMaterialView : View {
    var body : some View {
        VStack {
            Text("Всякие материалы")
        }
        .navigationTitle("Учебные материалы")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RootView()
}
