//
//  OnboardingView.swift
//  UIMobileHelper
//
//  Created by Nikita Makhov on 11.03.2026.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isFirstLaunch: Bool
    var isPresentedModally: Bool = false

    var body: some View {
        VStack {
            Text("Добро пожаловать!")
                .font(.largeTitle)
            Button("Пропустить") {
                isFirstLaunch = false
                if isPresentedModally {
                    dismiss()
                }
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
