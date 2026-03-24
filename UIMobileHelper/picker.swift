//
//  picker.swift
//  UIMobileHelper
//
//  Created by Nikita Makhov on 16.03.2026.
//

import SwiftUI

struct ThemePickerView: View {
    @State private var selectedTopic: AppTopic = .groceries
    @State private var selectedSubcategory: AppSubcategory = AppTopic.groceries.subcategories[0]
    @State var isPresented : Bool = false

    var body: some View {
        VStack {
            Picker("Topic", selection: $selectedTopic) {
                ForEach(AppTopic.allCases) {
                    Text($0.title).tag($0)
                }
            }
            .onChange(of: selectedTopic) { _, newValue in
                selectedSubcategory = newValue.subcategories[0]
            }

            Picker("Category", selection: $selectedSubcategory) {
                ForEach(selectedTopic.subcategories) {
                    Text($0.title).tag($0)
                }
            }

            Button("Next") {
                isPresented = true
            }
            .sheet(isPresented : $isPresented) {
                    DetailsView(
                        selection: ThemeSelection(
                            topic: selectedTopic,
                            subcategory: selectedSubcategory
                        )
                    )
            }
        }
    }
}

struct DetailsView: View {
    let selection: ThemeSelection

    var body: some View {
        VStack {
            Text(selection.topic.title)
            Text(selection.subcategory.content.title)
            Text(selection.subcategory.content.description)
            Text(selection.subcategory.content.fontName)
        }
    }
}

#Preview {
    ThemePickerView()
}
