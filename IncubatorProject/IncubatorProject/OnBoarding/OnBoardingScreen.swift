//
//  SwiftUIView.swift
//  ProjectDesign
//
//  Created by Alikhan Tangirbergen on 15.06.2023.
//

import SwiftUI

enum onBoardingScreenPage {
    case first, second
}

struct OnBoardingScreen: View {
    @Binding var screenState : AppScreenState
    @State var screenpage : onBoardingScreenPage = .first
    var body: some View {
        if screenpage == .first {
            VStack(alignment: .leading, spacing: 16) {
                Text("Добро пожаловать в \nCarAI").multilineTextAlignment(.leading).font(.system(size: 32)).bold()
                Text("Это бесплатное приложение, использующее OpenAI, которое отвечает на вопросы про машины.").font(.system(size: 18)).foregroundColor(Color(red: 155/255, green: 155/255, blue: 155/255))
                hblock(headertext: "AI может быть неточным", text: "Приложение может предоставлять неточную информацию об автомобилях, средние цены или факты.", imageName: "questionmark.app")
                hblock(headertext: "Не делитесь конфиденциальной информацией", text: "Для улучшения искусственного интеллекта, чаты могут просматриваться компанией.", imageName: "lock")
                hblock(headertext: "Управляйте своей историей чата и профилем", text: "Вы можете удалять историю чата, сохранять сообщения в избранные и редактировать свой аккаунт.", imageName: "gearshape")
                Spacer()
                Button {
                    withAnimation {
                        screenpage = .second
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(height: 58)
                            .foregroundColor(.accentColor)
                        Text("Продолжить").foregroundColor(.white).fontWeight(.semibold)
                    }
                }
                
            }.padding(.vertical).padding(.horizontal)
        }
        else {
            OnBoarding2(screenState: $screenState)
        }
    }
}

struct hblock : View {
    var headertext: String
    var text: String
    var imageName : String
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: imageName).resizable().frame(width: 30, height: 30)
            VStack(alignment: .leading, spacing: 8) {
                Text(headertext).fontWeight(.semibold)
                Text(text).foregroundColor(Color(red: 155/255, green: 155/255, blue: 155/255))
            }
        }
    }
}

struct OnBoardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingScreen(screenState: .constant(.onboarding))
    }
}
