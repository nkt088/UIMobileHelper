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

struct CategoryContent: Hashable, Codable {
    let title: String
    let description: String
    let fontName: String
    let fontColor: String
    let backgroundColor: String
    let secondaryColor: String
    let accentColor: String
    let screens: [String]
}

enum AppTopic: String, CaseIterable, Identifiable, Codable{
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

enum AppSubcategory: String, CaseIterable, Identifiable, Hashable, Codable {
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
                title: "Доставка еды",
                description: "Быстрый заказ блюд из ресторанов и кафе с удобным выбором, оплатой и отслеживанием доставки.",
                fontName: "Inter",
                fontColor: "#1F1F1F",
                backgroundColor: "#FFF8F0",
                secondaryColor: "#FFE2CC",
                accentColor: "#FF6B35",
                screens: ["Главная", "Меню ресторана", "Корзина"]
            )

        case .shops:
            .init(
                title: "Магазины",
                description: "Приложение для просмотра ассортимента, акций и оформления покупок в розничных магазинах.",
                fontName: "SF Pro Display",
                fontColor: "#1E1E1E",
                backgroundColor: "#F7F9FC",
                secondaryColor: "#DCE6F2",
                accentColor: "#3B82F6",
                screens: ["Каталог", "Карточка товара", "Корзина"]
            )

        case .cafes:
            .init(
                title: "Кафе",
                description: "Уютный сервис для выбора кафе, просмотра меню, бронирования столика и оформления заказов.",
                fontName: "Avenir Next",
                fontColor: "#2B2118",
                backgroundColor: "#FFF9F4",
                secondaryColor: "#EED9C4",
                accentColor: "#C67C4E",
                screens: ["Список заведений", "Меню", "Бронирование"]
            )

        case .restaurants:
            .init(
                title: "Рестораны",
                description: "Платформа для поиска ресторанов, изучения меню, бронирования и заказа блюд.",
                fontName: "Helvetica Neue",
                fontColor: "#201A17",
                backgroundColor: "#FCF8F3",
                secondaryColor: "#E7D8C9",
                accentColor: "#A63D40",
                screens: ["Каталог ресторанов", "Меню", "Бронирование стола"]
            )

        case .banks:
            .init(
                title: "Банк",
                description: "Мобильный банк для контроля счетов, переводов, платежей и управления финансами.",
                fontName: "Inter",
                fontColor: "#14213D",
                backgroundColor: "#F4F8FF",
                secondaryColor: "#D6E4FF",
                accentColor: "#2563EB",
                screens: ["Счета", "Перевод", "История операций"]
            )

        case .brokers:
            .init(
                title: "Брокер",
                description: "Инструмент для инвестиций, анализа портфеля, покупки активов и отслеживания рынка.",
                fontName: "Roboto",
                fontColor: "#102A43",
                backgroundColor: "#F7FAFC",
                secondaryColor: "#D9E2EC",
                accentColor: "#0F9D58",
                screens: ["Портфель", "Каталог активов", "Сделка"]
            )

        case .trading:
            .init(
                title: "Трейдинг",
                description: "Платформа для активной торговли с графиками, ордерами и мониторингом рынка в реальном времени.",
                fontName: "IBM Plex Sans",
                fontColor: "#E5E7EB",
                backgroundColor: "#0F172A",
                secondaryColor: "#1E293B",
                accentColor: "#22C55E",
                screens: ["График актива", "Стакан", "Ордер"]
            )

        case .cryptocurrency:
            .init(
                title: "Криптовалюта",
                description: "Сервис для хранения, обмена и отслеживания криптовалютных активов и курсов.",
                fontName: "Inter",
                fontColor: "#F8FAFC",
                backgroundColor: "#111827",
                secondaryColor: "#1F2937",
                accentColor: "#F59E0B",
                screens: ["Кошелек", "Курсы", "Обмен"]
            )

        case .messengers:
            .init(
                title: "Мессенджер",
                description: "Приложение для личной и групповой переписки, звонков и обмена файлами.",
                fontName: "SF Pro Text",
                fontColor: "#1F2937",
                backgroundColor: "#F8FAFC",
                secondaryColor: "#E5E7EB",
                accentColor: "#3B82F6",
                screens: ["Список чатов", "Диалог", "Профиль контакта"]
            )

        case .socialNetworks:
            .init(
                title: "Социальная сеть",
                description: "Платформа для общения, публикации контента, подписок и взаимодействия с аудиторией.",
                fontName: "Inter",
                fontColor: "#111827",
                backgroundColor: "#FFFFFF",
                secondaryColor: "#E5E7EB",
                accentColor: "#EC4899",
                screens: ["Лента", "Профиль", "Создание публикации"]
            )

        case .email:
            .init(
                title: "Почта",
                description: "Удобный почтовый клиент для чтения, сортировки и отправки писем.",
                fontName: "Roboto",
                fontColor: "#1F2937",
                backgroundColor: "#F9FAFB",
                secondaryColor: "#E5E7EB",
                accentColor: "#2563EB",
                screens: ["Входящие", "Письмо", "Создание письма"]
            )

        case .musicPlayer:
            .init(
                title: "Музыкальный плеер",
                description: "Приложение для прослушивания музыки, управления плейлистами и поиска треков.",
                fontName: "Avenir Next",
                fontColor: "#F9FAFB",
                backgroundColor: "#111111",
                secondaryColor: "#262626",
                accentColor: "#8B5CF6",
                screens: ["Список треков", "Плеер", "Плейлисты"]
            )

        case .videoHosting:
            .init(
                title: "Видеохостинг",
                description: "Сервис для просмотра, публикации и поиска видеоконтента по темам и авторам.",
                fontName: "Roboto",
                fontColor: "#111827",
                backgroundColor: "#FFFFFF",
                secondaryColor: "#F3F4F6",
                accentColor: "#EF4444",
                screens: ["Главная", "Видео", "Канал автора"]
            )

        case .streaming:
            .init(
                title: "Стриминг",
                description: "Платформа для просмотра фильмов, сериалов и трансляций с персональными рекомендациями.",
                fontName: "Inter",
                fontColor: "#F9FAFB",
                backgroundColor: "#0B1020",
                secondaryColor: "#1A2238",
                accentColor: "#E11D48",
                screens: ["Главная", "Карточка контента", "Плеер"]
            )

        case .games:
            .init(
                title: "Игры",
                description: "Игровой сервис с каталогом, достижениями, рейтингами и быстрым запуском игр.",
                fontName: "Montserrat",
                fontColor: "#F8FAFC",
                backgroundColor: "#140F2D",
                secondaryColor: "#2A1F54",
                accentColor: "#A855F7",
                screens: ["Каталог игр", "Карточка игры", "Профиль игрока"]
            )

        case .courses:
            .init(
                title: "Курсы",
                description: "Образовательное приложение для прохождения онлайн-курсов, модулей и тестов.",
                fontName: "Inter",
                fontColor: "#1F2937",
                backgroundColor: "#F8FAFC",
                secondaryColor: "#DBEAFE",
                accentColor: "#2563EB",
                screens: ["Список курсов", "Программа курса", "Урок"]
            )

        case .languages:
            .init(
                title: "Изучение языков",
                description: "Сервис для изучения иностранных языков с уроками, упражнениями и практикой слов.",
                fontName: "Nunito Sans",
                fontColor: "#1F2937",
                backgroundColor: "#F0FDF4",
                secondaryColor: "#D1FAE5",
                accentColor: "#10B981",
                screens: ["Список уроков", "Тренировка слов", "Прогресс"]
            )

        case .lectures:
            .init(
                title: "Лекции",
                description: "Платформа для просмотра видеолекций, материалов и расписания учебных занятий.",
                fontName: "Roboto",
                fontColor: "#1E293B",
                backgroundColor: "#F8FAFC",
                secondaryColor: "#E2E8F0",
                accentColor: "#6366F1",
                screens: ["Каталог лекций", "Лекция", "Материалы"]
            )

        case .trainers:
            .init(
                title: "Тренажёры",
                description: "Обучающее приложение для практики навыков, повторения и выполнения упражнений.",
                fontName: "Inter",
                fontColor: "#1F2937",
                backgroundColor: "#FFFDF5",
                secondaryColor: "#FEF3C7",
                accentColor: "#F59E0B",
                screens: ["Список упражнений", "Тренировка", "Результаты"]
            )

        case .taxi:
            .init(
                title: "Такси",
                description: "Сервис для быстрого заказа поездок, выбора тарифа и отслеживания машины на карте.",
                fontName: "SF Pro Display",
                fontColor: "#111827",
                backgroundColor: "#FFFDE7",
                secondaryColor: "#FEF08A",
                accentColor: "#FACC15",
                screens: ["Карта", "Выбор тарифа", "Поездка"]
            )

        case .carSharing:
            .init(
                title: "Каршеринг",
                description: "Приложение для поиска, бронирования и аренды автомобилей на короткий срок.",
                fontName: "Inter",
                fontColor: "#102A43",
                backgroundColor: "#F0F9FF",
                secondaryColor: "#D9F0FF",
                accentColor: "#0EA5E9",
                screens: ["Карта автомобилей", "Карточка авто", "Аренда"]
            )

        case .tickets:
            .init(
                title: "Билеты",
                description: "Сервис для поиска, покупки и хранения билетов на транспорт и мероприятия.",
                fontName: "Roboto",
                fontColor: "#1F2937",
                backgroundColor: "#F9FAFB",
                secondaryColor: "#E0E7FF",
                accentColor: "#4F46E5",
                screens: ["Поиск билетов", "Результаты", "Электронный билет"]
            )

        case .navigation:
            .init(
                title: "Навигация",
                description: "Приложение для построения маршрутов, пошаговой навигации и оценки времени в пути.",
                fontName: "Inter",
                fontColor: "#0F172A",
                backgroundColor: "#F8FAFC",
                secondaryColor: "#DBEAFE",
                accentColor: "#2563EB",
                screens: ["Карта", "Маршрут", "Навигация в пути"]
            )

        case .fitness:
            .init(
                title: "Фитнес",
                description: "Сервис для тренировок, отслеживания активности и ведения спортивного прогресса.",
                fontName: "Montserrat",
                fontColor: "#1F2937",
                backgroundColor: "#F0FDF4",
                secondaryColor: "#D1FAE5",
                accentColor: "#22C55E",
                screens: ["Тренировки", "План занятия", "Статистика"]
            )

        case .medicine:
            .init(
                title: "Медицина",
                description: "Медицинское приложение для записи к врачу, хранения данных и получения рекомендаций.",
                fontName: "Inter",
                fontColor: "#12324A",
                backgroundColor: "#F5FBFF",
                secondaryColor: "#D6EEF8",
                accentColor: "#06B6D4",
                screens: ["Запись к врачу", "Медкарта", "Приём"]
            )

        case .conditionTracking:
            .init(
                title: "Отслеживание состояния",
                description: "Приложение для фиксации самочувствия, симптомов, показателей и истории изменений.",
                fontName: "Roboto",
                fontColor: "#1F2937",
                backgroundColor: "#FFF7FB",
                secondaryColor: "#FBCFE8",
                accentColor: "#DB2777",
                screens: ["Дневник состояния", "Добавление записи", "График показателей"]
            )

        case .marketplaces:
            .init(
                title: "Маркетплейс",
                description: "Платформа для покупки товаров у разных продавцов с отзывами и сравнением цен.",
                fontName: "Inter",
                fontColor: "#1F2937",
                backgroundColor: "#FFFFFF",
                secondaryColor: "#E5E7EB",
                accentColor: "#F97316",
                screens: ["Каталог", "Карточка товара", "Корзина"]
            )

        case .discounts:
            .init(
                title: "Скидки",
                description: "Сервис для поиска акций, промокодов и выгодных предложений по категориям.",
                fontName: "Nunito Sans",
                fontColor: "#1F2937",
                backgroundColor: "#FFF7ED",
                secondaryColor: "#FED7AA",
                accentColor: "#F97316",
                screens: ["Лента акций", "Карточка предложения"]
            )

        case .accommodationBooking:
            .init(
                title: "Бронирование жилья",
                description: "Приложение для поиска и бронирования отелей, апартаментов и другого жилья.",
                fontName: "Avenir Next",
                fontColor: "#1F2937",
                backgroundColor: "#F8FAFC",
                secondaryColor: "#CFFAFE",
                accentColor: "#0891B2",
                screens: ["Поиск жилья", "Карточка объекта", "Бронирование"]
            )

        case .maps:
            .init(
                title: "Карты",
                description: "Картографический сервис для поиска мест, просмотра районов и изучения инфраструктуры.",
                fontName: "SF Pro Text",
                fontColor: "#0F172A",
                backgroundColor: "#F0FDF4",
                secondaryColor: "#DCFCE7",
                accentColor: "#16A34A",
                screens: ["Карта", "Карточка места", "Поиск"]
            )

        case .crm:
            .init(
                title: "CRM",
                description: "Система для управления клиентами, сделками, задачами и продажами.",
                fontName: "Inter",
                fontColor: "#1E293B",
                backgroundColor: "#F8FAFC",
                secondaryColor: "#E2E8F0",
                accentColor: "#3B82F6",
                screens: ["Список клиентов", "Карточка сделки", "Воронка продаж"]
            )

        case .taskManagers:
            .init(
                title: "Менеджер задач",
                description: "Инструмент для планирования, распределения и контроля выполнения задач.",
                fontName: "Roboto",
                fontColor: "#1F2937",
                backgroundColor: "#F9FAFB",
                secondaryColor: "#E5E7EB",
                accentColor: "#6366F1",
                screens: ["Список задач", "Доска проектов", "Карточка задачи"]
            )

        case .accounting:
            .init(
                title: "Бухгалтерия",
                description: "Сервис для учёта финансовых операций, документов, расходов и отчётности.",
                fontName: "IBM Plex Sans",
                fontColor: "#1F2937",
                backgroundColor: "#F8FAFC",
                secondaryColor: "#E2E8F0",
                accentColor: "#0F766E",
                screens: ["Операции", "Отчёты", "Документы"]
            )

        case .documentFlow:
            .init(
                title: "Документооборот",
                description: "Система для согласования, хранения и отслеживания статусов документов.",
                fontName: "Inter",
                fontColor: "#1E293B",
                backgroundColor: "#F8FAFC",
                secondaryColor: "#E2E8F0",
                accentColor: "#475569",
                screens: ["Список документов", "Карточка документа", "Согласование"]
            )

        case .notes:
            .init(
                title: "Заметки",
                description: "Простое приложение для создания, хранения и структурирования личных записей.",
                fontName: "Avenir Next",
                fontColor: "#2D2A26",
                backgroundColor: "#FFFDF7",
                secondaryColor: "#F5EFD8",
                accentColor: "#EAB308",
                screens: ["Список заметок", "Редактор заметки"]
            )

        case .weather:
            .init(
                title: "Погода",
                description: "Приложение для просмотра текущей погоды, прогноза и погодных показателей.",
                fontName: "SF Pro Display",
                fontColor: "#0F172A",
                backgroundColor: "#EFF6FF",
                secondaryColor: "#BFDBFE",
                accentColor: "#3B82F6",
                screens: ["Текущая погода", "Прогноз на неделю"]
            )

        case .calendar:
            .init(
                title: "Календарь",
                description: "Инструмент для планирования встреч, событий и управления расписанием.",
                fontName: "Inter",
                fontColor: "#1F2937",
                backgroundColor: "#FFFFFF",
                secondaryColor: "#F3F4F6",
                accentColor: "#EF4444",
                screens: ["Месяц", "Список событий", "Создание события"]
            )

        case .fileManagers:
            .init(
                title: "Файловый менеджер",
                description: "Приложение для просмотра, сортировки, перемещения и организации файлов.",
                fontName: "Roboto",
                fontColor: "#1F2937",
                backgroundColor: "#F9FAFB",
                secondaryColor: "#E5E7EB",
                accentColor: "#2563EB",
                screens: ["Файлы", "Папка", "Просмотр файла"]
            )

        case .rentAndBuyHousing:
            .init(
                title: "Аренда и покупка жилья",
                description: "Сервис для поиска недвижимости, фильтрации объявлений и просмотра объектов.",
                fontName: "Inter",
                fontColor: "#1F2937",
                backgroundColor: "#F8FAFC",
                secondaryColor: "#DBEAFE",
                accentColor: "#0EA5E9",
                screens: ["Каталог недвижимости", "Карточка объекта", "Избранное"]
            )
        }
    }

    var title: String { content.title }
}

struct ThemeSelection: Hashable, Codable {
    var topic: AppTopic
    var subcategory: AppSubcategory
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
