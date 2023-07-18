//
//  AuthorizationView.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 03.07.2023.
//

import SwiftUI

struct AuthorizationView: View {
    @ObservedObject var ViewModel : MainViewModel
    var contentType : UITextContentType = .telephoneNumber
    var body: some View {
        if ViewModel.isLoading {
            LoadingView().navigationBarBackButtonHidden()
        }
        else {
            VStack(alignment: .leading,spacing: 16) {
                CustomTextField(hint: "Номер Телефона", text: $ViewModel.mobileNo)
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
                    .padding(.top, 50)
                CustomTextField(hint: "Код", text: $ViewModel.otpCode)
                    .disabled(!ViewModel.showOTPField)
                    .opacity(!ViewModel.showOTPField ? 0.4 : 1)
                    .padding(.top, 30)
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
                .padding(.top, 30)
                Spacer()
                Button {
                    ViewModel.login()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 32)
                            .frame(height: 52)
                            .padding()
                            .foregroundColor(.black)
                        Text("Войти").foregroundColor(.white)
                    }
                }

            }.padding(.horizontal, 32).padding(.top)
                .navigationTitle("Авторизация")
                .navigationBarBackButtonTitleHidden()
                .alert(ViewModel.errorMessage, isPresented:  $ViewModel.showError) {
                    
                }
        }
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView(ViewModel: MainViewModel())
    }
}
