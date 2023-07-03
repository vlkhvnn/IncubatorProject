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
        }
    }
    var chat : some View {
        ZStack {
            Color(red: 246/255, green: 246/255, blue: 246/255).ignoresSafeArea()
            ScrollView {
                Text(ViewModel.formatChatToOneString())
            }
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(ViewModel: MainViewModel())
    }
}
