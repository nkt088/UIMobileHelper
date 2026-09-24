//
//  StudyMaterialView.swift
//  UIMobileHelper
//
//  Created by Nikita Makhov on 05.04.2026.
//

import SwiftUI

struct StudyMaterialView: View {
    private let materials: [StudyMaterial] = [
        .init(
            title: "10 Usability Heuristics for User Interface Design",
            subtitle: "Базовые эвристики usability от Nielsen Norman Group.",
            description: "Подойдёт для быстрого анализа интерфейса, поиска типичных UX-ошибок и понимания базовых принципов удобства.",
            url: "https://www.nngroup.com/articles/ten-usability-heuristics/"
        ),
        .init(
            title: "Web Content Accessibility Guidelines (WCAG) 2.1",
            subtitle: "Международный стандарт по доступности интерфейсов.",
            description: "Подойдёт тем, кто хочет делать интерфейсы более доступными: учитывать контраст, управление с клавиатуры, понятность структуры и текста.",
            url: "https://www.w3.org/TR/WCAG21/"
        ),
        .init(
            title: "Apple Human Interface Guidelines",
            subtitle: "Официальные рекомендации Apple по дизайну интерфейсов.",
            description: "Подойдёт для iOS и SwiftUI-разработки: помогает проектировать экраны, которые выглядят и ощущаются нативно для платформ Apple.",
            url: "https://developer.apple.com/design/human-interface-guidelines"
        )
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Здесь собраны основные источники по usability, доступности и дизайну интерфейсов. Список можно будет расширять дальше.")
                        .foregroundStyle(.secondary)
                }

                ForEach(materials) { material in
                    VStack(alignment: .leading, spacing: 10) {
                        Link(destination: material.link) {
                            Text(material.title)
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Text(material.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text(material.description)
                            .font(.subheadline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding()
        }
        .navigationTitle("Учебные материалы")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct StudyMaterial: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let description: String
    let url: String

    var link: URL {
        URL(string: url)!
    }
}
