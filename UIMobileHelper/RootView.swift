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
                MainView()            }
            .tabItem {
                Image(systemName: "plus.square")
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

#Preview {
    RootView()
}
//struct MainView : View {
//    var body : some View {
//        VStack {
//            NavigationLink("Начать анкетирование") {
//                SurveyFlowView()
//            }
//            .buttonStyle(.borderedProminent)
//            //.tint(.teal)
//        }
//        .padding()
//        .navigationTitle("Главный экран")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}

struct MainView: View {
    @State private var previousResults: [PreviousSurveyAnswers] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            NavigationLink("Начать анкетирование") {
                SurveyFlowView()
            }
            .buttonStyle(.borderedProminent)
            Text("Результаты прошлых прохождений")
                .font(.title2.bold())
            if previousResults.isEmpty {
                Text("Сохранённых результатов пока нет.")
                    .foregroundStyle(.secondary)
            } else {
                List(previousResults, id: \.date) { item in
                    NavigationLink {
                        SummaryView(
                            answers: item.answers,
                            generatedMockups: PreviousSurveyAnswersStore.shared.mockups(from: item)
                        )
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(item.answers.themeSelection.topic.title) / \(item.answers.themeSelection.subcategory.content.title)")
                                .font(.headline)
                            Text(item.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .listStyle(.plain)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Главный экран")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            previousResults = PreviousSurveyAnswersStore.shared.loadAll()
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
