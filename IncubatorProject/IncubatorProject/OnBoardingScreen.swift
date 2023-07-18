//
//  SwiftUIView.swift
//  ProjectDesign
//
//  Created by Alikhan Tangirbergen on 15.06.2023.
//

import SwiftUI

struct OnBoardingScreen: View {
    @Binding var screenState : AppScreenState
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Добро пожаловать в \nCarAI").multilineTextAlignment(.leading).font(.system(size: 32)).bold()
            Text("Это бесплатное приложение, использующее OpenAI, которое отвечает на вопросы про машины.").font(.system(size: 18)).foregroundColor(Color(red: 155/255, green: 155/255, blue: 155/255))
            hblock(headertext: "AI может быть неточным", text: "Приложение может предоставлять неточную информацию об автомобилях, средние цены или факты.", imageName: "questionmark.app")
            hblock(headertext: "Не делитесь конфиденциальной информацией", text: "Для улучшения искусственного интеллекта, чаты могут просматриваться компанией.", imageName: "lock")
            hblock(headertext: "Управляйте своей историей чата и профилем", text: "Вы можете удалять историю чата и редактировать свой аккаунт.", imageName: "gearshape")
            Spacer()
            Button {
                UserDefaults.standard.set(true, forKey: "isOnboardingSeen")
                screenState = .main
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(height: 58)
                        .foregroundColor(Color(red: 66/255, green: 72/255, blue: 251/255))
                    Text("Продолжить").foregroundColor(.white).fontWeight(.semibold)
                }
            }
            
        }.padding(.vertical).padding(.horizontal)
    }
}

struct hblock : View {
    var headertext: String
    var text: String
    var imageName : String
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: imageName).resizable().frame(width: 30, height: 30)
            VStack(alignment: .leading) {
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
