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
            Spacer()
            NavigationLink("Начать анкетирование") {
                SurveyView()
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
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
struct SurveyView : View {
    var body : some View {
        VStack {
            Text ("Анкета")
        }
        .navigationTitle("Главная")
    }
    
}
struct PlaceholderContentView : View {
    @State var text: String = ""
    var body: some View {
        Text(text)
    }
}

