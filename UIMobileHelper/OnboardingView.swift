//
//  OnboardingView.swift
//  UIMobileHelper
//
//  Created by Nikita Makhov on 11.03.2026.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isFirstLaunch : Bool
    var body: some View {
        VStack {
            Text("Добро пожаловать!")
                .font(.largeTitle)
            Button("Пропустить") {
                isFirstLaunch = false
            }
        }
    }
}

struct OnboardingPage {
    let id = UUID()
    let title : String
    let subtitle : String
    let imageTitle : String
}

//#Preview {
//    @Previewable @State var isFirstLaunch = true
//    OnboardingView(isFirstLaunch: $isFirstLaunch)
//}
