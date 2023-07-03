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
            Text("Welcome to \nCarGPT").multilineTextAlignment(.leading).font(.system(size: 32)).bold()
            Text("This app is free, sync your history across devices, and brings you the latest model improvements from OpenAI").font(.system(size: 18)).foregroundColor(Color(red: 155/255, green: 155/255, blue: 155/255))
            hblock(headertext: "GPT can be inaccurate", text: "GPT may provide inaccurate information about people, places, or facts", imageName: "questionmark.app")
            hblock(headertext: "Don't share sensitive info", text: "Chats may be reviewed by our AI trainers to improve our systems", imageName: "lock")
            hblock(headertext: "Control your chat history", text: "Decide whether new chats on this device will appear in your history and be used to improve our systems", imageName: "gearshape")
            Spacer()
            Button {
                UserDefaults.standard.set(true, forKey: "isOnboardingSeen")
                screenState = .main
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(height: 58)
                        .foregroundColor(Color(red: 66/255, green: 72/255, blue: 251/255))
                    Text("Continue").foregroundColor(.white).fontWeight(.semibold)
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
