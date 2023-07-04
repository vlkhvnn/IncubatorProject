//
//  MainScreen.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 03.07.2023.
//

import SwiftUI

struct MainScreen: View {
    @ObservedObject var ViewModel : MainViewModel
    
    var body: some View {
        TabView {
            chat
                .tabItem {
                    Text("Чат")
                    Image(systemName: "message.fill")
                }
            ProfileScreen()
                .tabItem {
                    Text("Профиль")
                    Image(systemName: "person.crop.circle.fill")
                }
            SettingsScreen()
                .tabItem {
                    Text("Настройки")
                    Image(systemName: "gearshape.fill")
                }
        }.onAppear {
            ViewModel.getChatHistory()
        }
    }
    var chat : some View {
        ZStack {
            Color(red: 246/255, green: 246/255, blue: 246/255).ignoresSafeArea()
            VStack {
                ScrollView {
                    LazyVStack{
                        HStack {
                            Text("Привет! Я ИИ специалист по машинам. Я могу ответить на любые ваши вопросы касательно машин и могу рекомендовать машины основываясь на ваших нуждах.")
                                .padding(10)
                                .background(Color.gray.opacity(0.15))
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                                .padding(.trailing, 32)
                                .padding(.bottom, 10)
                            Spacer()
                        }
                        ForEach(ViewModel.chat_history, id: \.self) { message in
                            if message["role"] == "Assistant" {
                                HStack {
                                    Text(message["content"]!)
                                        .padding(10)
                                        .background(Color.gray.opacity(0.15))
                                        .cornerRadius(10)
                                        .padding(.horizontal, 16)
                                        .padding(.trailing, 32)
                                        .padding(.bottom, 10)
                                    Spacer()
                                }
                            }
                            else if message["role"] == "User" {
                                HStack {
                                    Spacer()
                                    Text(message["content"]!)
                                        .padding(10)
                                        .foregroundColor(Color.white)
                                        .background(Color.blue.opacity(0.8))
                                        .cornerRadius(10)
                                        .padding(.horizontal, 16)
                                        .padding(.leading)
                                        .padding(.bottom, 10)
                                }
                            }
                        }

                    }
                    
                }
                HStack {
                    TextField("Message", text: $ViewModel.userMessage)
                            .padding(.leading)
                            .frame(height: 35)
                            .background(Color(red: 239/255, green: 239/255, blue: 239/255))
                            .cornerRadius(12)
                            .foregroundColor(.black)
                    Button {
                        ViewModel.sendMessage()
                        ViewModel.userMessage = ""
                        
                    } label: {
                        Image(systemName: "arrow.up")
                            .resizable().frame(width: 15, height: 20)
                    }
                }
                .onSubmit {
                    ViewModel.userMessage = ""
                }
                .padding()
            }
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(ViewModel: MainViewModel())
    }
}
