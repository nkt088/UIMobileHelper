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
    @State private var itemToDelete: PreviousSurveyAnswers?
    @State private var showDeleteAlert = false
    @State private var isEditingResults = false

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
                        showsSkipButton: false,
                        showsQuestionsButton: true
                    )
                }
            }
        }
        .onAppear {
            //UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            previousResults = PreviousSurveyAnswersStore.shared.loadAll()
        }
        .alert("Удалить результат?", isPresented: $showDeleteAlert) {
            Button("Отмена", role: .cancel) {
                itemToDelete = nil
            }
            Button("Удалить", role: .destructive) {
                guard let itemToDelete else { return }
                deleteResult(itemToDelete)
                self.itemToDelete = nil
            }
        } message: {
            Text("Результат будет удалён без возможности восстановления.")        }
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
            HStack {
                Text("Прошлые прохождения")
                    .font(.title3.bold())

                Spacer()

                Button {
                    withAnimation {
                        isEditingResults.toggle()
                    }
                } label: {
                    Image(systemName: isEditingResults ? "checkmark.circle.fill" : "square.and.pencil")
                        .bold()
                }
                .padding(.trailing, 8)
            }
            ForEach(previousResults.sorted(by: { $0.date > $1.date }), id: \.date) { item in
                ZStack(alignment: .trailing) {
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
                        .padding(.trailing, isEditingResults ? 28 : 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                    .disabled(isEditingResults)
                    
                    if isEditingResults {
                        Button {
                            itemToDelete = item
                            showDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: 44, maxHeight: 44)
                        }
                        .padding(.trailing, 8)
                        .transition(.opacity.combined(with: .scale))
                    }
                }
            }
        }
    }
    private func deleteResult(_ item: PreviousSurveyAnswers) {
        do {
            try PreviousSurveyAnswersStore.shared.delete(item)
            previousResults.removeAll { $0.date == item.date }
        } catch {
            print("delete error:", error)
        }
    }
}

#Preview {
    RootView()
}
