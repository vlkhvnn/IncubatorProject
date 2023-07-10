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
            ViewModel.getChatHistory()
        }
    }
    var chat : some View {
        ZStack {
            Color(red: 246/255, green: 246/255, blue: 246/255).ignoresSafeArea()
            VStack {
                TitleRow()
                ScrollViewReader  { proxy in
                    ScrollView {
                        
                        LazyVStack{
                            ForEach(ViewModel.chat_history, id: \.self) { message in
                                if message.dictMessage["role"] == "assistant" {
                                    HStack {
                                        Text(message.dictMessage["content"]!)
                                            .padding(10)
                                            .background(Color.gray.opacity(0.15))
                                            .cornerRadius(30)
                                            .padding(.horizontal, 16)
                                            .padding(.trailing, 32)
                                            .padding(.bottom, 10)
                                        Spacer()
                                    }
                                }
                                else if message.dictMessage["role"] == "user" {
                                    HStack {
                                        Spacer()
                                        Text(message.dictMessage["content"]!)
                                            .padding(10)
                                            .foregroundColor(Color.white)
                                            .background(Color.blue.opacity(0.8))
                                            .cornerRadius(30)
                                            .padding(.horizontal, 16)
                                            .padding(.leading)
                                            .padding(.bottom, 10)
                                    }
                                }
                            }

                        }
                    }
                    .onChange(of: ViewModel.chat_history) { _ in
                        withAnimation {
                            proxy.scrollTo(ViewModel.chat_history.last!)
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
                        ViewModel.chat_history.append(ViewModel.createMessage(dictMessage: ["role": "user",  "content": ViewModel.userMessage]))
                        ViewModel.sendMessage()
                        ViewModel.userMessage = ""
                        
                        
                    } label: {
                        Image(systemName: "arrow.up")
                            .resizable().frame(width: 15, height: 20)
                    }
                }
                .onSubmit {
                    ViewModel.chat_history.append(ViewModel.createMessage(dictMessage: ["role": "user",  "content": ViewModel.userMessage]))
                    ViewModel.sendMessage()
                    ViewModel.userMessage = ""
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

