//
//  PreviousSurveyAnswersStore.swift
//  UIMobileHelper
//
//  Created by Nikita Makhov on 05.04.2026.
//

import Foundation

final class PreviousSurveyAnswersStore {
    static let shared = PreviousSurveyAnswersStore()

    private init() {}

    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private var jsonURL: URL {
        documentsDirectory.appendingPathComponent("previous_survey_answers.json")
    }

    private var imagesDirectory: URL {
        let url = documentsDirectory.appendingPathComponent("generated_mockups", isDirectory: true)

        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }

        return url
    }

    func loadAll() -> [PreviousSurveyAnswers] {
        guard FileManager.default.fileExists(atPath: jsonURL.path) else {
            return []
        }

        do {
            let data = try Data(contentsOf: jsonURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([PreviousSurveyAnswers].self, from: data)
        } catch {
            print("loadAll error:", error)
            return []
        }
    }

    func save(
        answers: SurveyAnswers,
        mockups: [GeneratedMockup]
    ) async throws {
        var savedItems = loadAll()
        var localPaths: [String] = []

        for mockup in mockups {
            let fileName = UUID().uuidString + ".png"
            let fileURL = imagesDirectory.appendingPathComponent(fileName)

            let (data, _) = try await URLSession.shared.data(from: mockup.imageURL)
            try data.write(to: fileURL)

            localPaths.append(fileURL.path)
        }

        let item = PreviousSurveyAnswers(
            answers: answers,
            imagePath: localPaths,
            date: Date()
        )

        savedItems.insert(item, at: 0)

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(savedItems)
        try data.write(to: jsonURL, options: .atomic)
    }

    func mockups(from item: PreviousSurveyAnswers) -> [GeneratedMockup] {
        item.imagePath.enumerated().compactMap { index, path in
            guard item.answers.screens.indices.contains(index) else { return nil }

            let screen = item.answers.screens[index]

            return GeneratedMockup(
                screenTitle: screen.title,
                screenComment: screen.comment,
                imageURL: URL(fileURLWithPath: path)
            )
        }
    }
}
