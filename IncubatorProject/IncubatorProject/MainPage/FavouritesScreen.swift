//
//  SettingsScreen.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 03.07.2023.
//

import SwiftUI

struct FavouritesScreen: View {
    @ObservedObject var ViewModel : MainViewModel
    var body: some View {
        if ViewModel.favourites.isEmpty {
            Text("Пока у вас нет Избранных сообщений. Нажмите на форму сердца рядом с сообщением, чтобы добавить сообщение в Избранные")
                .padding()
                .multilineTextAlignment(.center)
                .navigationBarBackButtonTitleHidden().navigationTitle("Избранные сообщения")
        }
        else {
            favouriteChat.onAppear {
                ViewModel.getFavourites()
            }.navigationBarBackButtonTitleHidden().navigationTitle("Избранные сообщения")
        }
        
    }
    var favouriteChat : some View {
        ScrollView {
            LazyVStack{
                ForEach(ViewModel.favourites, id: \.self) { message in
                    if message.isUserMessage == false {
                        BotMessage(ViewModel: ViewModel, message: message)
                    }
                    else {
                        UserMessage(message: message)
                    }
                }
            }
        }
    }
}

struct FavouriteScreen_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesScreen(ViewModel: MainViewModel())
    }
}
