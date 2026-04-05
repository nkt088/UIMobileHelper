//
//  SurveyObject.swift
//  UIMobileHelper
//
//  Created by Nikita Makhov on 16.03.2026.
//

import Foundation

enum SurveyStep : Int, CaseIterable {
    case os
    case theme
    case screens
    case imageGeneration
    case summary
    
    var title : String {
        switch self {
        case .os : "OS"
        case .theme : "Тема приложения"
        case .screens : "Рекомендуемые экраны"
        case .imageGeneration : "Создание макетов"
        case .summary : "Ответы"
        }
    }
}
struct Screen: Hashable {
    var title: String = ""
    var comment: String = ""
}
struct SurveyAnswers: Hashable {
    var themeSelection = ThemeSelection(topic: .groceries, subcategory: .foodDelivery)
    var OS : String = "iOS"
    var BaseRecommendedLiterature: [LiteratureItem] = []
    var screens: [Screen] = []
}
struct LiteratureItem: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let link: String
    let comment: String
}
//enum Screen : String, CaseIterable, Identifiable, Hashable {
//    case :
//}
//var fontName: String = "SF Pro"

//var backgroundColor: String = "Белый"
//var textColor: String  = "Черный"
//var accentColor: String = "Синий"

//var RecommendedLiterature: [LiteratureItem] = []

//var appComment: String = "Комментарий пока не сформирован"
