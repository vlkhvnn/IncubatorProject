//
//  AuthorizationView.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 03.07.2023.
//

import SwiftUI

struct AuthorizationView: View {
    @ObservedObject var ViewModel : MainViewModel
    var body: some View {
        if ViewModel.isLoading {
            LoadingView()
        }
        else {
            VStack(spacing: 16) {
                TextField("Почта", text: $ViewModel.userEmail)
                    .padding(.leading)
                    .frame(height: 48)
                    .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                SecureField("Пароль", text: $ViewModel.userPassword)
                    .padding(.leading)
                    .frame(height: 48)
                    .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                if ViewModel.inValidPassword {
                    Text("Invalid password or email.")
                }
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

            }.padding(.horizontal).padding(.top)
                .navigationTitle("Авторизация")
                .navigationBarBackButtonTitleHidden()
        }
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView(ViewModel: MainViewModel())
    }
}
