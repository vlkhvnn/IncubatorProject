//
//  RegistrationView.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 03.07.2023.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var ViewModel : MainViewModel
    @State var repeatedpassword = ""
    var body: some View {
        if ViewModel.isLoading {
            LoadingView().navigationBarBackButtonHidden()
        }
        else {
            VStack {
                VStack(spacing: 16) {
                    TextField("Почта", text: $ViewModel.userEmail)
                        .padding(.leading)
                        .frame(height: 48)
                        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                    SecureField("Пароль", text: $ViewModel.userPassword)
                        .padding(.leading)
                        .frame(height: 48)
                        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                    SecureField("Повторите пароль", text: $repeatedpassword)
                        .padding(.leading)
                        .frame(height: 48)
                        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                    if self.ViewModel.inValidEmail {
                        Text("Данная почта уже используется другим пользователем или ее формат неправильный.").padding(.horizontal, -8).multilineTextAlignment(.center)
                    }
                    
                }
                Spacer()
                Button {
                    self.ViewModel.register()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 32)
                            .frame(height: 52)
                            .padding()
                            .foregroundColor(.black)
                        Text("Зарегистрироваться").foregroundColor(.white)
                    }
                }
            }.padding(.horizontal).padding(.top, 20)
                .navigationTitle("Новый пользователь")
                .navigationBarBackButtonTitleHidden()
        }
        
        
    }
}


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(ViewModel: MainViewModel())
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

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .scaleEffect(3)
                
            }
            
        }
    }
}
