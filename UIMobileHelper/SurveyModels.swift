//
//  SurveyObject.swift
//  UIMobileHelper
//
//  Created by Nikita Makhov on 16.03.2026.
//

import Foundation
enum OperationSystemType {
    case Android
    case iOS
}
//struct SurveyObject {
//    let type : OperationSystemType
//    let recomendation : ThemeSelection
//    let screen : [String] // тут тоже
//    //let models : [String?] // пока не понятно
//}

enum SurveyStep : Int, CaseIterable {
    case os
    case theme
    case age
    case summary
    
    var title : String {
        switch self {
        case .os : "OS"
        case .theme : "Тема приложения"
        case .age : "Возраст"
        case .summary : "Ответы"
        }
    }
}

struct Screen: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let comment: String
}

struct LiteratureItem: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let link: String
    let comment: String
}
struct SurveyAnswers: Hashable {
    //удалить
    //var name: String = ""
    var age: String = ""

    //общие характеристики
    var themeSelection = ThemeSelection(topic: .groceries, subcategory: .foodDelivery)
//    var topic: AppTopic = .education
//    var subcategory: AppSubcategory = .courses
    var OS : String = "iOS"
    //литература
    var BaseRecommendedLiterature: [LiteratureItem] = []
    //визуальные макеты
    var hasScreens: Bool = false
    var screens: [Screen] = []

    //var fontName: String = "SF Pro"

    //var backgroundColor: String = "Белый"
    //var textColor: String  = "Черный"
    //var accentColor: String = "Синий"

    //var RecommendedLiterature: [LiteratureItem] = []

    //var appComment: String = "Комментарий пока не сформирован"
}
//enum Screen : String, CaseIterable, Identifiable, Hashable {
//    case :
//}
