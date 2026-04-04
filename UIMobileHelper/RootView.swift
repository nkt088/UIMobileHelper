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
struct MainView : View {
    var body : some View {
        VStack {
            NavigationLink("Начать анкетирование") {
                SurveyFlowView()
            }
            .buttonStyle(.borderedProminent)
            //.tint(.teal)
        }
        .padding()
        .navigationTitle("Главный экран")
        .navigationBarTitleDisplayMode(.inline)
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
