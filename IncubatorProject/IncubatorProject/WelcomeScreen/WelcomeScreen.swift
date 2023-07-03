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
                    }).padding(.bottom, 30)
                }.ignoresSafeArea().accentColor(.black)
            }
        }
    }
    var welcomepage : some View {
        ZStack {
            VStack {
                Image("car_photo1")
                Spacer()
                    .frame(height: 20)
                Image("car_photo2")
                Spacer()
                Text("Добро пожаловать в CarGPT")
                    .font(.system(size: 28))
                    .multilineTextAlignment(.center)
                
            }.ignoresSafeArea()
        }
    }
    
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen(ViewModel: MainViewModel())
    }
}
