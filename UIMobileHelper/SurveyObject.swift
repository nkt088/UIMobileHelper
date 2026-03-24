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
struct SurveyObject {
    let type : OperationSystemType
    let recomendation : ThemeSelection
    let screen : [String] // тут тоже
    //let models : [String?] // пока не понятно
}

//enum Screen : String, CaseIterable, Identifiable, Hashable {
//    case :
//}
