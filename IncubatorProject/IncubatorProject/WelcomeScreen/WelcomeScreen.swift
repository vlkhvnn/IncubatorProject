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
        if self.ViewModel.logStatus {
            MainScreen(ViewModel: ViewModel)
        }
        else {
            AuthenticationScreen(ViewModel: ViewModel)
        }
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen(ViewModel: MainViewModel())
    }
}

struct AuthenticationScreen : View {
    @StateObject var ViewModel : MainViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            VStack(alignment: .center, spacing: 6) {
                Text("  Добро пожаловать в ")
                Text("CarAI").foregroundColor(.accentColor)
            }.font(.system(size: 32)).bold()
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.accentColor).opacity(0.7)
                    .frame(height: 50)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black)
                    }
                HStack {
                    Spacer()
                    ZStack {
                        if ViewModel.authType == .registration {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.white).frame(height: 40)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.black)
                                }
                        }
                        Button {
                            withAnimation {
                                ViewModel.authType = .registration
                            }
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.white.opacity(0)).frame(height: 40)
                        }
                        Text("Регистрация")
                    }
                    Spacer()
                    ZStack {
                        Button {
                            withAnimation {
                                ViewModel.authType = .authorization
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.white.opacity(0)).frame(height: 40)
                        }
                        if ViewModel.authType == .authorization {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.white).frame(height: 40)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.black)
                                }
                        }
                        Text("Авторизация")
                    }
                    Spacer()
                }.fontWeight(.semibold)
            }
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading) {
                    Text("Электронная почта")
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray)
                            .frame(height: 60)
                        TextField("Ваша почта", text: $ViewModel.userEmail)
                            .padding(.leading)
                            .frame(height: 60)
                    }
                    
                    
                    
                }
                VStack(alignment: .leading) {
                    Text("Пароль")
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray)
                            .frame(height: 60)
                        TextField("Пароль", text: $ViewModel.userPassword)
                            .padding(.leading)
                            .frame(height: 60)
                    }
                    
                    
                    
                }
            }
            
            
            Button {
                if ViewModel.authType == .registration {
                    if ViewModel.userEmail.isValidEmail() {
                        ViewModel.register()
                    }
                    else {
                        ViewModel.inValidEmail = true
                    }
                }
                else {
                    ViewModel.login()
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 56)
                    Text(ViewModel.authType == .registration ?  "Зарегистрироваться" : "Войти").foregroundColor(.white)
                        .fontWeight(.semibold)
                }
            }.padding(.vertical)
            if ViewModel.inValidEmail {
                Text("Электронная почта уже занята или недействительна. Пожалуйста, используйте другой или действующий адрес электронной почты")
            }
            
            Spacer()
            
            
        }.padding()
    }
}

extension View {
    func navigationBarBackButtonTitleHidden() -> some View {
        self.modifier(NavigationBarBackButtonTitleHiddenModifier())
    }
}


struct NavigationBarBackButtonTitleHiddenModifier: ViewModifier {
    
    @Environment(\.dismiss) var dismiss
    
    @ViewBuilder @MainActor func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                    .imageScale(.large) })
            .contentShape(Rectangle()) // Start of the gesture to dismiss the navigation
            .gesture(
                DragGesture(coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.width > .zero
                            && value.translation.height > -30
                            && value.translation.height < 30 {
                            dismiss()
                        }
                    }
            )
    }
}
