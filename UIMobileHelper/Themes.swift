//
//  Themes.swift
//  UIMobileHelper
//
//  Created by Nikita Makhov on 11.03.2026.
//
//

/*
 Object : protocol {
 //protocol будет содержать те же поля что и категория, его также будет поддеживать и объект категории
 //поля:
 операционная система
 шрифт :
 цвет заднего фона :
 цвет шрифта :
 акцентный цвет :
 количество экранов // макс 3
 [название экрана, комментарий к экрану]
 [название экрана, комментарий к экрану]
 [название экрана, комментарий к экрану]
 список рекомендованной литературы :
 комментарий к приложению // типо напуствие

 //там где двоеточие это поля из страктуры категории
 }
 */
import SwiftUI

struct CategoryContent: Hashable {
    let title: String
    let description: String
    let fontName: String
}

enum AppTopic: String, CaseIterable, Identifiable {
    case groceries
    case finance
    case communication
    case entertainment
    case education
    case transport
    case health
    case shopping
    case travel
    case workAndBusiness
    case utilities
    case realEstate

    var id: Self { self }

    var title: String {
        switch self {
        case .groceries: "Groceries"
        case .finance: "Finance"
        case .communication: "Communication"
        case .entertainment: "Entertainment"
        case .education: "Education"
        case .transport: "Transport"
        case .health: "Health"
        case .shopping: "Shopping"
        case .travel: "Travel"
        case .workAndBusiness: "Work and Business"
        case .utilities: "Utilities"
        case .realEstate: "Real Estate"
        }
    }

    var subcategories: [AppSubcategory] {
        AppSubcategory.allCases.filter { $0.topic == self }
    }
}

enum AppSubcategory: String, CaseIterable, Identifiable, Hashable {
    case foodDelivery
    case shops
    case cafes
    case restaurants
    case banks
    case brokers
    case trading
    case cryptocurrency
    case messengers
    case socialNetworks
    case email
    case musicPlayer
    case videoHosting
    case streaming
    case games
    case courses
    case languages
    case lectures
    case trainers
    case taxi
    case carSharing
    case tickets
    case navigation
    case fitness
    case medicine
    case conditionTracking
    case marketplaces
    case discounts
    case accommodationBooking
    case maps
    case crm
    case taskManagers
    case accounting
    case documentFlow
    case notes
    case weather
    case calendar
    case fileManagers
    case rentAndBuyHousing

    var id: Self { self }

    var topic: AppTopic {
        switch self {
        case .foodDelivery, .shops, .cafes, .restaurants:
            .groceries
        case .banks, .brokers, .trading, .cryptocurrency:
            .finance
        case .messengers, .socialNetworks, .email:
            .communication
        case .musicPlayer, .videoHosting, .streaming, .games:
            .entertainment
        case .courses, .languages, .lectures, .trainers:
            .education
        case .taxi, .carSharing, .tickets, .navigation:
            .transport
        case .fitness, .medicine, .conditionTracking:
            .health
        case .marketplaces, .discounts:
            .shopping
        case .accommodationBooking, .maps:
            .travel
        case .crm, .taskManagers, .accounting, .documentFlow:
            .workAndBusiness
        case .notes, .weather, .calendar, .fileManagers:
            .utilities
        case .rentAndBuyHousing:
            .realEstate
        }
    }

    var content: CategoryContent {
        switch self {
        case .foodDelivery:
            .init(
                title: "Food Delivery",
                description: "Apps for ordering and delivering food",
                fontName: "SF Pro"
            )
        case .shops:
            .init(
                title: "Shops",
                description: "Apps for grocery stores and supermarkets",
                fontName: "SF Pro"
            )
        case .cafes:
            .init(
                title: "Cafés",
                description: "Apps for cafés and coffee shops",
                fontName: "SF Pro"
            )
        case .restaurants:
            .init(
                title: "Restaurants",
                description: "Apps for restaurants and dining",
                fontName: "SF Pro"
            )
        case .banks:
            .init(
                title: "Banks",
                description: "Mobile banking and financial service apps",
                fontName: "SF Pro"
            )
        case .brokers:
            .init(
                title: "Brokers",
                description: "Brokerage and investment platform apps",
                fontName: "SF Pro"
            )
        case .trading:
            .init(
                title: "Trading",
                description: "Apps for stock and market trading",
                fontName: "SF Pro"
            )
        case .cryptocurrency:
            .init(
                title: "Cryptocurrency",
                description: "Apps for crypto wallets and exchanges",
                fontName: "SF Pro"
            )
        case .messengers:
            .init(
                title: "Messengers",
                description: "Apps for instant messaging and calls",
                fontName: "SF Pro"
            )
        case .socialNetworks:
            .init(
                title: "Social Networks",
                description: "Apps for social media and communities",
                fontName: "SF Pro"
            )
        case .email:
            .init(
                title: "Email",
                description: "Apps for email communication",
                fontName: "SF Pro"
            )
        case .musicPlayer:
            .init(
                title: "Music Player",
                description: "Apps for listening to music and managing playlists",
                fontName: "SF Pro"
            )
        case .videoHosting:
            .init(
                title: "Video Hosting",
                description: "Apps for watching and publishing video content",
                fontName: "SF Pro"
            )
        case .streaming:
            .init(
                title: "Streaming",
                description: "Apps for streaming movies, shows, and live content",
                fontName: "SF Pro"
            )
        case .games:
            .init(
                title: "Games",
                description: "Apps for mobile gaming and entertainment",
                fontName: "SF Pro"
            )
        case .courses:
            .init(
                title: "Courses",
                description: "Apps with structured educational courses and lessons",
                fontName: "SF Pro"
            )
        case .languages:
            .init(
                title: "Languages",
                description: "Apps for learning foreign languages",
                fontName: "SF Pro"
            )
        case .lectures:
            .init(
                title: "Lectures",
                description: "Apps for watching lectures and educational videos",
                fontName: "SF Pro"
            )
        case .trainers:
            .init(
                title: "Trainers",
                description: "Apps with practice exercises and skill training",
                fontName: "SF Pro"
            )
        case .taxi:
            .init(
                title: "Taxi",
                description: "Apps for booking taxi rides",
                fontName: "SF Pro"
            )
        case .carSharing:
            .init(
                title: "Car Sharing",
                description: "Apps for short-term car rental and sharing",
                fontName: "SF Pro"
            )
        case .tickets:
            .init(
                title: "Tickets",
                description: "Apps for buying transport and travel tickets",
                fontName: "SF Pro"
            )
        case .navigation:
            .init(
                title: "Navigation",
                description: "Apps for maps, routes, and navigation",
                fontName: "SF Pro"
            )
        case .fitness:
            .init(
                title: "Fitness",
                description: "Apps for workouts, activity, and fitness programs",
                fontName: "SF Pro"
            )
        case .medicine:
            .init(
                title: "Medicine",
                description: "Apps for medical services, consultations, and prescriptions",
                fontName: "SF Pro"
            )
        case .conditionTracking:
            .init(
                title: "Condition Tracking",
                description: "Apps for tracking health indicators and wellbeing",
                fontName: "SF Pro"
            )
        case .marketplaces:
            .init(
                title: "Marketplaces",
                description: "Apps for buying goods from online marketplaces",
                fontName: "SF Pro"
            )
        case .discounts:
            .init(
                title: "Discounts",
                description: "Apps for finding deals, coupons, and special offers",
                fontName: "SF Pro"
            )
        case .accommodationBooking:
            .init(
                title: "Accommodation Booking",
                description: "Apps for booking hotels, apartments, and housing",
                fontName: "SF Pro"
            )
        case .maps:
            .init(
                title: "Maps",
                description: "Apps for maps, routes, and travel navigation",
                fontName: "SF Pro"
            )
        case .crm:
            .init(
                title: "CRM",
                description: "Apps for customer relationship management",
                fontName: "SF Pro"
            )
        case .taskManagers:
            .init(
                title: "Task Managers",
                description: "Apps for managing tasks, teams, and workflows",
                fontName: "SF Pro"
            )
        case .accounting:
            .init(
                title: "Accounting",
                description: "Apps for finance tracking, reporting, and bookkeeping",
                fontName: "SF Pro"
            )
        case .documentFlow:
            .init(
                title: "Document Flow",
                description: "Apps for document management and business paperwork",
                fontName: "SF Pro"
            )
        case .notes:
            .init(
                title: "Notes",
                description: "Apps for notes, text capture, and quick ideas",
                fontName: "SF Pro"
            )
        case .weather:
            .init(
                title: "Weather",
                description: "Apps for weather forecasts and climate information",
                fontName: "SF Pro"
            )
        case .calendar:
            .init(
                title: "Calendar",
                description: "Apps for planning events, schedules, and reminders",
                fontName: "SF Pro"
            )
        case .fileManagers:
            .init(
                title: "File Managers",
                description: "Apps for managing files, folders, and storage",
                fontName: "SF Pro"
            )
        case .rentAndBuyHousing:
            .init(
                title: "Rent and Buy Housing",
                description: "Apps for renting, buying, and browsing real estate",
                fontName: "SF Pro"
            )
        }
    }

    var title: String { content.title }
}

struct ThemeSelection: Hashable {
    let topic: AppTopic
    let subcategory: AppSubcategory
}
//import Foundation
//
//Продукты — доставка еды, магазины, кафе, рестораны
//Финансы — банки, брокеры, трейдинг, криптовалюта
//Коммуникации — мессенджеры, соцсети, почта
//Развлечения — музыкальный плеер, видеохостинг, стриминг, игры
//Образование — курсы, языки, лекции, тренажёры
//Транспорт — такси, каршеринг, билеты, навигация
//Здоровье — фитнес, медицина, трекинг состояния
//Покупки — маркетплейсы, магазины, скидки
//Путешествия — бронирование жилья, билеты, карты
//Работа и бизнес — CRM, таск-менеджеры, учёт, документооборот
//Утилиты — заметки, погода, календарь, менеджеры файлов
//Недвижимость — аренда и покупка жилья
//
//enum AppTopic: String, CaseIterable, Identifiable {
//    case groceries
//    case finance
//    case communication
//    case entertainment
//    case education
//    case transport
//    case health
//    case shopping
//    case travel
//    case workBusiness
//    case utilities
//    case realEstate
//    
//    var id: Self { self }
//    
//    var title: String {
//        switch self {
//        case .groceries: "Продукты"
//        case .finance: "Финансы"
//        case .communication: "Коммуникации"
//        case .entertainment: "Развлечения"
//        case .education: "Образование"
//        case .transport: "Транспорт"
//        case .health: "Здоровье"
//        case .shopping: "Покупки"
//        case .travel: "Путешествия"
//        case .workBusiness: "Работа и бизнес"
//        case .utilities: "Утилиты"
//        case .realEstate: "Недвижимость"
//        }
//    }
//    var categories: [String] {
//        switch self {
//        case .groceries:
//            [.foodDelivery, .cafes, .restaurants]
//            
//        case .finance:
//            ["Banks", "Brokers", "Trading", "Cryptocurrency"]
//            
//        case .communication:
//            ["Messengers", "Social Networks", "Email"]
//        default : []
//        }
//    }
//    struct Category: Identifiable {
//        let id = UUID()
//        let title: String
//        let description: String
//        let fontName: String
//    }
//    
//    extension Category {
//        static let foodDelivery = Category(
//            title: "Food Delivery",
//            description: "Apps for ordering and delivering food from restaurants and cafes",
//            fontName: "SF Pro",
//        )
//        static let cafes = Category(
//            title: "cafes",
//            description: "Apps for ordering and delivering food from restaurants and cafes",
//            fontName: "SF Pro",
//        )
//        static let restaurants = Category(
//            title: "Restaurants",
//            description: "Apps for ordering and delivering food from restaurants and cafes",
//            fontName: "SF Pro",
//        )
//    }
//    
//    
//    struct FoodDelivery {
//        let title : String = "Доставка"
//    }
//    //Groceries — food delivery, shops, cafés, restaurants
//    //Finance — banks, brokers, trading, cryptocurrency
//    //Communication — messengers, social networks, email
//    //Entertainment — music player, video hosting, streaming, games
//    //Education — courses, languages, lectures, training apps
//    //Transport — taxi, car sharing, tickets, navigation
//    //Health — fitness, medicine, health tracking
//    //Shopping — marketplaces, stores, discounts
//    //Travel — accommodation booking, tickets, maps
//    //Work and Business — CRM, task managers, accounting, document management
//    //Utilities — notes, weather, calendar, file managers
//    //Real Estate — housing rental and purchase
//    
//    
//    enum MyEnum {
//        typealias Item = (title: String, value: String)
//        
//        case first
//        case second
//        case third
//        
//        var value: [Item] {
//            switch self {
//            case .first:
//                [("1", "one"), ("2", "two"), ("3", "three")]
//            case .second:
//                [("a", "alpha"), ("b", "beta")]
//            case .third:
//                [("x", "first"), ("y", "second"), ("z", "third")]
//            }
//        }
//    }
//    
//    
//    
//    можно оставить и первую реализацию, можно попробовать сделать протоколо под каждую категорию тогда можно будет создать массив,
//    и добавить туда структуры под каждую подкатегорию
