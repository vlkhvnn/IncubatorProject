//
//  WelcomeScreen.swift
//  ProjectDesign
//
//  Created by Alikhan Tangirbergen on 01.07.2023.
//

import SwiftUI

struct WelcomeScreen: View {
    @StateObject var ViewModel : MainViewModel
    var body: some View {
        if self.ViewModel.userLoggedIn {
            MainScreen(ViewModel: ViewModel)
        }
        else {
            NavigationView {
                VStack {
                    welcomepage
                    NavigationLink(destination: RegistrationView(ViewModel: ViewModel),
                                   label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 32)
                                .frame(height: 52)
                                .padding()
                                .foregroundColor(.black)
                            Text("Регистрация").foregroundColor(.white)
                        }
                    })
                    NavigationLink(destination: AuthorizationView(ViewModel: ViewModel),
                                   label: {
                        Text("У меня уже есть аккаунт")
                            .foregroundColor(.black)
                            .bold()
                            .padding(.bottom)
                    })
                }.accentColor(.black)
            }
        }
    }
    var welcomepage : some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Добро пожаловать в ")
                    .font(.system(size: 24))
                    .bold()
                Text("CarAI")
                    .font(.system(size: 24))
                    .bold()
                    .foregroundColor(Color(red: 0, green: 100/255, blue: 229/255))
                Spacer()
            }
            Spacer()
        }.padding()
        
    }
    
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen(ViewModel: MainViewModel())
    }
}
