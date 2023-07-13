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
            FavouritesScreen()
                .tabItem {
                    Text("Избранные")
                    Image(systemName: "heart.fill")
                }
            ProfileScreen(ViewModel: ViewModel)
                .tabItem {
                    Text("Профиль")
                    Image(systemName: "person.crop.circle.fill")
                }
        }.onAppear {
            ViewModel.getMessages()
        }.accentColor(.black)
    }
    var chat : some View {
        ZStack {
            Color(red: 246/255, green: 246/255, blue: 246/255).ignoresSafeArea()
            VStack {
                TitleRow()
                ScrollViewReader  { proxy in
                    ScrollView {
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
                        LazyVStack{
                            ForEach(ViewModel.messages, id: \.self) { message in
                                if message.isUserMessage == false {
                                    HStack {
                                        Text(message.content)
                                            .padding(10)
                                            .background(Color.gray.opacity(0.15))
                                            .cornerRadius(10)
                                            .padding(.horizontal, 16)
                                            .padding(.trailing, 32)
                                            .padding(.bottom, 10)
                                        Spacer()
                                    }
                                }
                                else {
                                    HStack {
                                        Spacer()
                                        Text(message.content)
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
                    .onChange(of: ViewModel.messages) { _ in
                        withAnimation {
                            proxy.scrollTo(ViewModel.messages.last!)
                        }
                    }
                }
                HStack {
                    TextField("Введите сообщение", text: $ViewModel.userMessage)
                            .padding(.leading)
                            .frame(height: 35)
                            .background(Color(red: 239/255, green: 239/255, blue: 239/255))
                            .cornerRadius(12)
                            .foregroundColor(.black)
                    Button {
                        ViewModel.messages.append(Message(content: ViewModel.userMessage, isUserMessage: true, timestamp: Date()))
                        ViewModel.savedUserMessage = ViewModel.userMessage
                        ViewModel.userMessage = ""
                        ViewModel.addUserMessageToFirestore()
                        ViewModel.sendMessage()
                    } label: {
                            Image(systemName: "arrow.up")
                                .resizable().frame(width: 15, height: 20)
                    }
                }
                .onSubmit {
                    ViewModel.messages.append(Message(content: ViewModel.userMessage, isUserMessage: true, timestamp: Date()))
                    ViewModel.savedUserMessage = ViewModel.userMessage
                    ViewModel.userMessage = ""
                    ViewModel.addUserMessageToFirestore()
                    ViewModel.sendMessage()
                }
                .padding()
            }
        }

    }
}

struct TitleRow: View {
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "circle")
            VStack(alignment: .leading) {
                Text("CarAI")
                    .font(.title).bold()
                Text("Ваш помощник по машинам")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }.padding()
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(ViewModel: MainViewModel())
    }
}

