//
//  UIMobileHelperApp.swift
//  UIMobileHelper
//
//  Created by Nikita Makhov on 11.03.2026.
//

import SwiftUI

@main
struct UIMobileHelperApp: App {
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true

    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                OnboardingView(isFirstLaunch: $isFirstLaunch)
            } else {
                RootView()
                    .tint(.teal)
            }
        }
    }
}
