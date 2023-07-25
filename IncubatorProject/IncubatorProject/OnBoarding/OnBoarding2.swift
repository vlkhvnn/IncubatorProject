//
//  OnBoarding2.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 25.07.2023.
//

import SwiftUI

struct OnBoarding2: View {
    @Binding var screenState : AppScreenState
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Image("screenshot").resizable().scaledToFit().padding(.leading, -16)
            Spacer()
            Text("Начать чат🚀").font(.title).padding(.vertical)
            Text("CarAI предоставляет передовое использование ИИ на вашем 📲")
            Button {
                withAnimation {
                    screenState = .main
                    UserDefaults.standard.set(true, forKey: "isOnboardingSeen")
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 54)
                        .padding(.trailing)
                        .padding(.vertical)
                        .foregroundColor(.accentColor)
                    Text("Продолжить").foregroundColor(.white).fontWeight(.semibold)
                }
            }

        }.padding(.leading)
    }
}

struct OnBoarding2_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding2(screenState: .constant(.onboarding))
    }
}
