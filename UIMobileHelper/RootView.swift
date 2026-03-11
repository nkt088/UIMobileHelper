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
                PlaceholderContentView(text: "Главный экран")
            }
            .tabItem {
                Image(systemName: "plus.square")
                Text("Главная")
            }
            NavigationStack {
                PlaceholderContentView(text: "Учебные материала")
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

struct PlaceholderContentView : View {
    @State var text: String = ""
    var body: some View {
        Text(text)
    }
}

