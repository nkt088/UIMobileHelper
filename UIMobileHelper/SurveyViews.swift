//
//  SurveyViews.swift
//  UIMobileHelper
//
//  Created by Nikita Makhov on 05.04.2026.
//

import SwiftUI

struct SurveyFlowView : View {
    @Environment(\.dismiss) private var dismiss
    @State private var step : SurveyStep = SurveyStep.os
    @State private var answers = SurveyAnswers()
    @State private var showExitAlert = false
    @State private var isForward = true
    @State private var generatedMockups: [GeneratedMockup] = []
    @State private var generationFailed = false

    var body : some View {
        VStack() {
            ZStack {
                curStepView
                    .id(step)
                    .transition(transition)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            if step != .summary && (step != .imageGeneration || generationFailed) {
                Divider()
                HStack {
                    Spacer()
                    Button("Назад") { goBack() }
                        .disabled(isFirstStep)
                    Spacer()
                    Button("Вперед") { goNext() }
                        .disabled(isLastStep )
                    Spacer()
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button{
                    showExitAlert = true
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Назад")
                    }
                }
            }
        }
        .alert ("Выйти из анкеты", isPresented: $showExitAlert) {
            Button("Отмена", role: .cancel) {}
            Button("Выйти", role: .destructive) { dismiss() }
        } message : {
            Text("Результат анкетирования будет утерян")
        }
    }
    @ViewBuilder
    private var curStepView : some View {
        switch step {
            case .os :
            OSQuestView(OS: $answers.OS)
            case .theme:
            ThemeQuestView(topic: $answers.themeSelection.topic,subcategory: $answers.themeSelection.subcategory)
            case .screens:
            ScreenQuestView(
                availableScreens: answers.themeSelection.subcategory.content.screens.map {
                    Screen(title: $0, comment: "")
                },
                screens: $answers.screens
            )
        case .imageGeneration:
            ImageGenerationView(answers: answers,
                onCompleted: { mockups in
                    generatedMockups = mockups
                    generationFailed = false
                    withAnimation(.easeInOut) {
                        step = .summary
                    }
                },
                onFailed: {
                    generationFailed = true
                }
            )
        case .summary:
            SummaryView(
                answers: answers,
                generatedMockups: generatedMockups
            )
//            case .imageGeneration :
//            ImageGenerationView()
//            case .summary :
//            SummaryView(answers: answers)
        }
    }
    private var transition: AnyTransition {
        .asymmetric(
            insertion: .move(edge: isForward ? .trailing : .leading).combined(with: .opacity),
            removal: .move(edge: isForward ? .leading : .trailing).combined(with: .opacity)
        )
    }
//    private func goNext () {
//        guard let next = SurveyStep(rawValue: step.rawValue + 1) else { return }
//        isForward = true
//        withAnimation(.easeInOut) {
//            step = next
//        }
//    }
    private func goNext() {
        if step == .screens {
            generationFailed = false
            isForward = true
            withAnimation(.easeInOut) {
                step = answers.screens.isEmpty ? .summary : .imageGeneration
            }
            return
        }
        guard let next = SurveyStep(rawValue: step.rawValue + 1) else { return }
        isForward = true
        withAnimation(.easeInOut) {
            step = next
        }
    }
    private func goBack () {
        guard let back = SurveyStep(rawValue: step.rawValue - 1) else { return }
        isForward = false
        withAnimation(.easeInOut) {
            step = back
        }
    }
    private var isFirstStep : Bool {
        step.rawValue == 0
    }
    private var isLastStep : Bool {
        step == .summary
    }
}
struct OSQuestView : View {
    @Binding var OS : String
    
    var body: some View {
        VStack {
            Text("Введите OS")
                .font(.title)
            HStack(spacing: 16) {
                card(title: "iOS", isSelected: OS == "iOS")
                    .onTapGesture { if OS == "" || OS == "Android" {OS = "iOS"} else {OS = ""}}
                card(title: "Android", isSelected: OS == "Android")
                    .onTapGesture { if OS == "" || OS == "iOS" {OS = "Android"} else {OS = ""}}
            }
        }
        .padding()
    }
    private func card(title: String, isSelected: Bool) -> some View {
        Text(title)
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? .accentColor : Color(uiColor: .separator), lineWidth: 2)
            }
            .overlay {
                if isSelected {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.teal, lineWidth: 3)
                        .blur(radius: 4)
                }
            }
    }
}
struct ThemeQuestView: View {
    @Binding var topic: AppTopic
    @Binding var subcategory: AppSubcategory

    var body: some View {
        VStack {
            Text("Выберите тему приложения")
                .font(.title)
            Picker("Topic", selection: $topic) {
                ForEach(AppTopic.allCases) {
                    Text($0.title).tag($0)
                }
            }
            .onChange(of: topic) { _, newValue in
                subcategory = newValue.subcategories[0]
            }

            Picker("Category", selection: $subcategory) {
                ForEach(topic.subcategories) {
                    Text($0.title).tag($0)
                }
            }
        }
        .padding()
    }
}

struct ScreenQuestView: View {
    let availableScreens: [Screen]
    @Binding var screens: [Screen]
    @State private var customScreenTitle = ""
    @State private var customScreenComment = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Выберите экраны")
                .font(.title)

            ForEach(availableScreens, id: \.title) { screen in
                VStack(alignment: .leading, spacing: 8) {
                    Button {
                        toggleScreen(screen)
                    } label: {
                        HStack {
                            Image(systemName: isSelected(screen) ? "checkmark.square.fill" : "square")
                            Text(screen.title)
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)

                    if isSelected(screen) {
                        TextField(
                            "Комментарий к экрану",
                            text: commentBinding(for: screen)
                        )
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.secondary, lineWidth: 1)
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Другой экран")
                    .font(.headline)

                TextField("Название экрана", text: $customScreenTitle)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.secondary, lineWidth: 1)
                    }

                TextField("Комментарий к экрану", text: $customScreenComment)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.secondary, lineWidth: 1)
                    }

                Button("Добавить экран") {
                    addCustomScreen()
                }
                .disabled(customScreenTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Spacer()
        }
        .padding()
    }

    private func indexOfScreen(_ screen: Screen) -> Int? {
        for index in screens.indices {
            if screens[index].title == screen.title {
                return index
            }
        }
        return nil
    }

    private func isSelected(_ screen: Screen) -> Bool {
        indexOfScreen(screen) != nil
    }

    private func toggleScreen(_ screen: Screen) {
        if let index = indexOfScreen(screen) {
            screens.remove(at: index)
        } else {
            screens.append(Screen(title: screen.title, comment: ""))
        }
    }

    private func commentBinding(for screen: Screen) -> Binding<String> {
        Binding(
            get: {
                if let index = indexOfScreen(screen) {
                    return screens[index].comment
                }
                return ""
            },
            set: { newValue in
                if let index = indexOfScreen(screen) {
                    screens[index].comment = newValue
                }
            }
        )
    }

    private func addCustomScreen() {
        let trimmedTitle = customScreenTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedComment = customScreenComment.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        guard indexOfScreen(Screen(title: trimmedTitle, comment: "")) == nil else { return }
        screens.append(
            Screen(
                title: trimmedTitle,
                comment: trimmedComment
            )
        )
        customScreenTitle = ""
        customScreenComment = ""
    }
}
//struct SummaryView: View {
//    @Environment(\.dismiss) private var dismiss
//    var answers: SurveyAnswers
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 20) {
//                headerSection
//                appInfoSection
//                designSection
//                screensSection
//            }
//            .padding()
//        }
//        .navigationTitle("Результат")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Button("Завершить") {
//                    dismiss()
//                }
//            }
//        }
//    }
//
//    private var headerSection: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("Итог анкеты")
//                .font(.largeTitle.bold())
//
//            Text("Ниже собраны все выбранные параметры и рекомендации по интерфейсу.")
//                .foregroundStyle(.secondary)
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//
//    private var appInfoSection: some View {
//        infoCard(title: "Общая информация") {
//            infoRow(title: "ОС", value: answers.OS)
//            infoRow(title: "Тема", value: answers.themeSelection.topic.title)
//            infoRow(title: "Подтема", value: answers.themeSelection.subcategory.content.title)
//            infoRow(title: "Описание", value: answers.themeSelection.subcategory.content.description)
//        }
//    }
//
//    private var designSection: some View {
//        infoCard(title: "Рекомендации по интерфейсу") {
//            infoRow(title: "Шрифт", value: answers.themeSelection.subcategory.content.fontName)
//            infoRow(title: "Цвет шрифта", value: answers.themeSelection.subcategory.content.fontColor)
//            infoRow(title: "Цвет фона", value: answers.themeSelection.subcategory.content.backgroundColor)
//            infoRow(title: "Вторичный цвет", value: answers.themeSelection.subcategory.content.secondaryColor)
//            infoRow(title: "Акцентный цвет", value: answers.themeSelection.subcategory.content.accentColor)
//
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Рекомендуемые экраны")
//                    .font(.headline)
//
//                ForEach(answers.themeSelection.subcategory.content.screens, id: \.self) { screen in
//                    HStack(alignment: .top, spacing: 8) {
//                        Image(systemName: "circle.fill")
//                            .font(.system(size: 6))
//                            .padding(.top, 6)
//                            .foregroundStyle(.secondary)
//
//                        Text(screen)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                }
//            }
//            .padding(.top, 4)
//        }
//    }
//
//    private var screensSection: some View {
//        infoCard(title: "Выбранные пользователем экраны") {
//            if answers.screens.isEmpty {
//                Text("Пользователь не выбрал дополнительные экраны.")
//                    .foregroundStyle(.secondary)
//            } else {
//                ForEach(answers.screens, id: \.title) { screen in
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text(screen.title)
//                            .font(.headline)
//
//                        if screen.comment.isEmpty {
//                            Text("Комментарий не указан")
//                                .foregroundStyle(.secondary)
//                        } else {
//                            Text(screen.comment)
//                                .foregroundStyle(.secondary)
//                        }
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
//                    .background(Color(uiColor: .tertiarySystemBackground))
//                    .clipShape(RoundedRectangle(cornerRadius: 14))
//
//                    if screen.title != answers.screens.last?.title {
//                        Divider()
//                    }
//                }
//            }
//        }
//    }
//
//    private func infoCard<Content: View>(
//        title: String,
//        @ViewBuilder content: () -> Content
//    ) -> some View {
//        VStack(alignment: .leading, spacing: 14) {
//            Text(title)
//                .font(.title3.bold())
//
//            content()
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(Color(uiColor: .secondarySystemBackground))
//        .clipShape(RoundedRectangle(cornerRadius: 20))
//    }
//
//    private func infoRow(title: String, value: String) -> some View {
//        VStack(alignment: .leading, spacing: 4) {
//            Text(title)
//                .font(.subheadline.weight(.semibold))
//                .foregroundStyle(.secondary)
//
//            Text(value)
//                .frame(maxWidth: .infinity, alignment: .leading)
//        }
//    }
//}
struct SummaryView: View {
    @Environment(\.dismiss) private var dismiss
    var answers: SurveyAnswers
    var generatedMockups: [GeneratedMockup]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                appInfoSection
                designSection
                screensSection
                mockupsSection
            }
            .padding()
        }
        .navigationTitle("Результат")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Завершить") {
                    dismiss()
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Итог анкеты")
                .font(.largeTitle.bold())

            Text("Ниже собраны все выбранные параметры, рекомендации и сгенерированные макеты.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var appInfoSection: some View {
        infoCard(title: "Общая информация") {
            infoRow(title: "ОС", value: answers.OS)
            infoRow(title: "Тема", value: answers.themeSelection.topic.title)
            infoRow(title: "Подтема", value: answers.themeSelection.subcategory.content.title)
            infoRow(title: "Описание", value: answers.themeSelection.subcategory.content.description)
        }
    }

    private var designSection: some View {
        infoCard(title: "Рекомендации по интерфейсу") {
            infoRow(title: "Шрифт", value: answers.themeSelection.subcategory.content.fontName)
            infoRow(title: "Цвет шрифта", value: answers.themeSelection.subcategory.content.fontColor)
            infoRow(title: "Цвет фона", value: answers.themeSelection.subcategory.content.backgroundColor)
            infoRow(title: "Вторичный цвет", value: answers.themeSelection.subcategory.content.secondaryColor)
            infoRow(title: "Акцентный цвет", value: answers.themeSelection.subcategory.content.accentColor)

            VStack(alignment: .leading, spacing: 8) {
                Text("Рекомендуемые экраны")
                    .font(.headline)

                ForEach(answers.themeSelection.subcategory.content.screens, id: \.self) { screen in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
                            .padding(.top, 6)
                            .foregroundStyle(.secondary)

                        Text(screen)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(.top, 4)
        }
    }

    private var screensSection: some View {
        infoCard(title: "Выбранные пользователем экраны") {
            if answers.screens.isEmpty {
                Text("Пользователь не выбрал дополнительные экраны.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(answers.screens, id: \.title) { screen in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(screen.title)
                            .font(.headline)

                        if screen.comment.isEmpty {
                            Text("Комментарий не указан")
                                .foregroundStyle(.secondary)
                        } else {
                            Text(screen.comment)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    if screen.title != answers.screens.last?.title {
                        Divider()
                    }
                }
            }
        }
    }

    private var mockupsSection: some View {
        infoCard(title: "Сгенерированные макеты") {
            if generatedMockups.isEmpty {
                Text("Макеты не были сгенерированы.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(generatedMockups, id: \.screenTitle) { mockup in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(mockup.screenTitle)
                            .font(.headline)

                        if !mockup.screenComment.isEmpty {
                            Text(mockup.screenComment)
                                .foregroundStyle(.secondary)
                        }

                        AsyncImage(url: mockup.imageURL) { phase in
                            switch phase {
                            case .empty:
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.thinMaterial)
                                    ProgressView()
                                }
                                .frame(height: 280)

                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 20))

                            case .failure:
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.thinMaterial)
                                    Text("Не удалось загрузить изображение")
                                }
                                .frame(height: 280)

                            @unknown default:
                                EmptyView()
                            }
                        }
                    }

                    if mockup.screenTitle != generatedMockups.last?.screenTitle {
                        Divider()
                    }
                }
            }
        }
    }

    private func infoCard<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.title3.bold())

            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(value)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
extension SurveyAnswers {
    //часть независящая от экранов
    func basePrompt() -> String {
        guard !screens.isEmpty else {
            return ""
        }
        return """
        Создать изображение макета интерфейса мобильного приложения для \(OS). Категория приложения: \(themeSelection.topic.title). Подкатегория: \(themeSelection.subcategory.content.title). Использовать шрифт \(themeSelection.subcategory.content.fontName) с цветом текста \(themeSelection.subcategory.content.fontColor). Задний фон должен быть цвета \(themeSelection.subcategory.content.backgroundColor). Акцентный цвет для элементов интерфейса оформить в цвете \(themeSelection.subcategory.content.secondaryColor). Акцентные элементы выделить цветом \(themeSelection.subcategory.content.accentColor). Навигация реализована через нижний таббар. Макет должен быть помещён внутрь рамки \(OS) телефона.
        """
    }
    //часть индивидуальная для каждого экрана
    func imagePrompt(for index: Int) -> String {
        guard screens.indices.contains(index) else {
            return ""
        }
        let screen = screens[index]
        return """
        Необходимо сгенерировать макет экрана: \(screen.title). Наполнение экрана должно соответствовать следующему описанию: \(screen.comment).
        """
    }
}

//struct SummaryView : View {
//    @Environment(\.dismiss) private var dismiss
//    var answers : SurveyAnswers
//    var body: some View {
//        VStack {
//            Text("Результат")
//                .font(.title)
//            Divider()
//            VStack {
//                Text(answers.themeSelection.topic.title)
//                Text(answers.themeSelection.subcategory.content.title)
//                Text(answers.themeSelection.subcategory.content.description)
//                Text(answers.themeSelection.subcategory.content.fontName)
//                    .font(.title2)
//                Text(answers.OS)
//                    .font(.title2)
//                ForEach(answers.screens, id: \.title) { screen in
//                    Text(screen.title)
//                    Text(screen.comment)
//                }
//            }
//            .padding()
//        }
//        .padding()
//
//        .toolbar {
//            ToolbarItem(placement: .principal){
//                Text("Результат")
//            }
//            ToolbarItem(placement: .topBarTrailing) {
//                Button{
//                    dismiss()
//                } label: {
//                    HStack {
//                        Text("Завершить")
//                        Image(systemName: "chevron.right")
//                    }
//                }
//            }
//        }
//    }
//}
