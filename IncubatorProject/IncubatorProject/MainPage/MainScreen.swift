//
//  MainScreen.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 03.07.2023.
//

import SwiftUI

struct MainScreen: View {
    @ObservedObject var ViewModel : MainViewModel
    @State private var markdownText = ""
    var body: some View {
        TabView {
            chat
                .tabItem {
                    Text("Чат")
                    Image(systemName: "message.fill")
                }
            FavouritesScreen(ViewModel: ViewModel)
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
        }
    }
    var chat : some View {
        ZStack {
            Color(red: 246/255, green: 246/255, blue: 246/255)
            VStack {
                TitleRow()
                ScrollViewReader  { proxy in
                    ScrollView {
                        HStack {
                            Text("Привет! Я ИИ специалист по машинам. Я могу ответить на любые ваши вопросы касательно машин и могу рекомендовать машины основываясь на ваших нуждах.")
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                                .padding(.trailing, 32)
                                .padding(.bottom, 10)
                            Spacer()
                        }
                        LazyVStack{
                            ForEach(ViewModel.messages, id: \.self) { message in
                                if message.isUserMessage == false {
                                    BotMessage(message: message)
                                }
                                else {
                                    UserMessage(message: message)
                                }
                                
                            }
                            if ViewModel.isLoadingResponse {
                                HStack {
                                    Text("Подождите, бот генерирует ответ...")
                                        .padding(10)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .padding(.horizontal, 16)
                                        .padding(.trailing, 32)
                                        .padding(.bottom, 10)
                                        .padding(.top)
                                    Spacer()
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
                BottomRow(ViewModel: ViewModel)
            }
        }

    }
    func convertStringToAttributed(text: String) -> LocalizedStringKey {
        return LocalizedStringKey(text)
    }
}

struct BotMessage : View {
    var message: Message
    var body: some View {
        HStack {
            Text(.init(message.content))
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.trailing, 32)
                .padding(.bottom, 10)
            Spacer()
        }
    }
}

struct UserMessage: View {
    var message : Message
    var body: some View {
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

struct TitleRow: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 20) {
            Image("carai-logo").resizable().frame(width: 52, height: 52).scaledToFit()
            VStack(alignment: .leading) {
                Text("CarAI")
                    .font(.system(size: 24)).bold()
                Text("Ваш помощник по машинам")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }.padding().frame(height: 60).background(.white)
    }
}

struct BottomRow: View {
    @ObservedObject var ViewModel : MainViewModel
    var body: some View {
        ZStack {
            Color(.white).ignoresSafeArea()
            HStack {
                TextField("Введите сообщение", text: $ViewModel.userMessage)
                        .padding(.leading)
                        .frame(height: 35)
                        .background(Color(red: 239/255, green: 239/255, blue: 239/255))
                        .cornerRadius(12)
                        .foregroundColor(.black)
                Button {
                    ViewModel.ButtonTap()
                } label: {
                        Image(systemName: "arrow.up")
                            .resizable().frame(width: 15, height: 20)
                }.disabled(ViewModel.isLoadingResponse)
            }.onSubmit {
                ViewModel.ButtonTap()
            }
            .padding()
        }.frame(height: 60)
        
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(ViewModel: MainViewModel())
    }
}

