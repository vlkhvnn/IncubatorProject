//
//  WelcomeScreen.swift
//  ProjectDesign
//
//  Created by Alikhan Tangirbergen on 01.07.2023.
//

import SwiftUI
import iPhoneNumberField

struct WelcomeScreen: View {
    @StateObject var ViewModel : MainViewModel
    var body: some View {
        if self.ViewModel.logStatus {
            MainScreen(ViewModel: ViewModel)
        }
        else {
            VStack(alignment: .leading,spacing: 16) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Добро пожаловать в ").font(.title)
                    Text("CarAI").font(.title)
                        .foregroundColor(.accentColor)
                    Spacer().frame(height: 15)
                    Text("Войдите с помощью номера телефона чтобы продолжить")
                        .font(.system(size: 16)).foregroundColor(.gray)
                }.fontWeight(.semibold)
                    
                PhoneTextField(hint: "(700) 697-9370", text: $ViewModel.mobileNo)
                    .disabled(ViewModel.showOTPField)
                    .opacity(ViewModel.showOTPField ? 0.4 : 1)
                    .overlay(alignment: .trailing,content: {
                        Button("Изменить") {
                            withAnimation(.easeInOut) {
                                ViewModel.showOTPField = false
                                ViewModel.otpCode = ""
                                ViewModel.CLIENT_CODE = ""
                            }
                        }
                        .font(.caption)
                        .foregroundColor(.indigo)
                        .opacity(ViewModel.showOTPField ? 1 : 0)
                        .padding(.trailing, 15)
                    })
                    .padding(.top, 40)
                    
                    
                CustomTextField(hint: "Код", text: $ViewModel.otpCode)
                    .disabled(!ViewModel.showOTPField)
                    .opacity(!ViewModel.showOTPField ? 0.4 : 1)
                    .padding(.top, 30)
                HStack {
                    Button(action: ViewModel.showOTPField ? ViewModel.verifyOTPCode : ViewModel.getOTPCode) {
                        HStack(spacing: 15) {
                            Text(ViewModel.showOTPField ? "Подтвердить код" : "Получить код")
                                .fontWeight(.semibold)
                                .contentTransition(.identity)
                            Image(systemName: "line.diagonal.arrow")
                                .font(.title3)
                                .rotationEffect(.init(degrees: 45))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 25)
                        .padding(.vertical)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.black.opacity(0.05))
                        }
                    }
                    Spacer()
                    Image("applogo").resizable().frame(width: 80, height: 80)
                }
                .padding(.top, 30)
                
                Spacer()
                
            }.padding(.horizontal, 32).padding(.top)
                .navigationTitle("Авторизация")
                .navigationBarBackButtonTitleHidden()
                .alert(ViewModel.errorMessage, isPresented:  $ViewModel.showError) {}
        }
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen(ViewModel: MainViewModel())
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
