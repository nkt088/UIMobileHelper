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

    var body : some View {
        VStack() {
            ZStack {
                curStepView
                    .id(step)
                    .transition(transition)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
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
            case .age :
            AgeQuestView(age: $answers.age)
            case .summary :
            SummaryView(answers: answers)
        }
    }
    private var transition: AnyTransition {
        .asymmetric(
            insertion: .move(edge: isForward ? .trailing : .leading).combined(with: .opacity),
            removal: .move(edge: isForward ? .leading : .trailing).combined(with: .opacity)
        )
    }
    private func goNext () {
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
struct AgeQuestView : View {
    @Binding var age : String
    var body: some View {
        VStack {
            Text("Введите возраст")
                .font(.title)
            TextField("write age here", text : $age)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 20).stroke(.secondary, lineWidth: 1)
                }
        }
        .padding()
    }
}
struct SummaryView : View {
    var answers : SurveyAnswers
    var body: some View {
        VStack {
            Text("Результат")
                .font(.title)
            Divider()
            VStack {
                Text(answers.themeSelection.topic.title)
                Text(answers.themeSelection.subcategory.content.title)
                Text(answers.themeSelection.subcategory.content.description)
                Text(answers.themeSelection.subcategory.content.fontName)
                Text(answers.age)
                    .font(.title2)
                Text(answers.OS)
                    .font(.title2)
            }.padding(4)
        }
        .padding()
    }
}

