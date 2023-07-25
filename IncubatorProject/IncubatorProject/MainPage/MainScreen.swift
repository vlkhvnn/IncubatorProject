//
//  MainScreen.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 03.07.2023.
//

import SwiftUI

struct MainScreen: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var ViewModel : MainViewModel
    
    var body: some View {
        NavigationView {
            chat.onAppear {
                ViewModel.getMessages()
            }
        }
    }
    var chat : some View {
        NavigationStack {
            ZStack {
                Color(.white)
                VStack {
                    TitleRow(ViewModel: ViewModel)
                    ScrollViewReader  { proxy in
                        ScrollView {
                            HStack {
                                Text("Привет! Я ИИ специалист по машинам. Я могу ответить на любые ваши вопросы касательно машин и могу рекомендовать машины основываясь на ваших нуждах.")
                                    .padding(10)
                                    .background(Color(red: 246/255, green: 246/255, blue: 246/255))
                                    .cornerRadius(10)
                                    .padding(.horizontal, 16)
                                    .padding(.trailing, 32)
                                    .padding(.bottom, 10)
                                Spacer()
                            }
                            LazyVStack{
                                ForEach(ViewModel.messages, id: \.self) { message in
                                    if message.isUserMessage == false {
                                        BotMessage(ViewModel: ViewModel, message: message)
                                        
                                    }
                                    else {
                                        UserMessage(ViewModel: ViewModel, message: message)
                                    }
                                    
                                }
                                if ViewModel.isLoadingResponse {
                                    HStack {
                                        Text("Подождите, бот генерирует ответ...")
                                            .padding(10)
                                            .background(Color(red: 246/255, green: 246/255, blue: 246/255))
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
                                if !ViewModel.messages.isEmpty {
                                    proxy.scrollTo(ViewModel.messages.last!)
                                }
                            }
                        }
                    }
                    .overlay(MoreButtonOverlay, alignment: .topTrailing)
                    BottomRow(ViewModel: ViewModel)
                }
            }
        }.alert(isPresented: $ViewModel.showClearChatAlert) {
            Alert(title: Text("Вы уверены что хотите удалить историю чата?"), primaryButton: .default(Text("Да")) {
                ViewModel.deleteChat()
            },
                  secondaryButton: .cancel(Text("Нет")))
        }
    }
    func convertStringToAttributed(text: String) -> LocalizedStringKey {
        return LocalizedStringKey(text)
    }
    
    @ViewBuilder private var MoreButtonOverlay : some View {
        if ViewModel.isMoreButtonTapped {
            ZStack {
                RoundedRectangle(cornerRadius: 12).foregroundColor(.white)
                VStack {
                    NavigationLink(destination: ProfileScreen(ViewModel: ViewModel))
                    {
                        HStack {
                            Text("Еще")
                            Spacer()
                            Image(systemName: "gearshape")
                        }.padding(.horizontal)
                    }
                    Divider()
                    Button {
                        ViewModel.showClearChatAlert = true
                    } label: {
                        HStack {
                            Text("Очистить чат").foregroundColor(.red)
                            Spacer()
                            Image(systemName: "trash.fill").foregroundColor(.red)
                        }.padding(.horizontal)
                    }

                    
                }
            }.frame(width: 200, height: 80).accentColor(.black)
        }
    }
}

struct BotMessage : View {
    @ObservedObject var ViewModel : MainViewModel
    var message: MessageStruct
    var body: some View {
        HStack {
            Text(.init(message.content))
                .padding(10)
                .background(Color(red: 246/255, green: 246/255, blue: 246/255))
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.trailing, 32)
                .padding(.bottom, 10)
            Spacer()
            Button {
                ViewModel.messages[ViewModel.getMessageIndex(message: message)].isFavourite.toggle()
                ViewModel.updateFavoriteStatus(message: message)
            } label: {
                if ViewModel.messages.contains(where: {$0.id == message.id})
                {
                    if ViewModel.messages[ViewModel.getMessageIndex(message: message)].isFavourite {
                        Image(systemName: "heart.fill").foregroundColor(.red)
                    }
                    else {
                        Image(systemName: "heart.fill").foregroundColor(.black.opacity(0.5))
                    }
                }
                
            }
            Spacer()
        }
    }
}

struct UserMessage: View {
    @ObservedObject var ViewModel : MainViewModel
    var message : MessageStruct
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
    @ObservedObject var ViewModel : MainViewModel
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            NavigationLink(destination: CitiesView(ViewModel: ViewModel)) {
                ZStack(alignment: .top) {
                    Image("gps_logo").resizable().frame(width: 30, height: 30)
                        .scaledToFit()
                        .foregroundColor(.accentColor)
                }.padding(.bottom, 6)
            }
            
            
            VStack(alignment: .leading) {
                Text("CarAI")
                    .font(.system(size: 24)).bold()
                Text("Ваш помощник по машинам")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button {
                ViewModel.isMoreButtonTapped.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16).foregroundColor(Color(red: 233/255, green: 237/255, blue: 250/255)).opacity(0.5).frame(width: 48, height: 36)
                    Image(systemName: "ellipsis").foregroundColor(.black)
                }
            }
        }.padding(.horizontal).frame(height: 60).background(.white)
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
                }.disabled(ViewModel.isLoadingResponse).disabled(ViewModel.userMessage == "")
            }.onSubmit {
                if ViewModel.userMessage != "" {
                    ViewModel.ButtonTap()
                }
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

