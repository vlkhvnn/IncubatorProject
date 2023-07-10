//
//  ProfileScreen.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 03.07.2023.
//

import SwiftUI

struct ProfileScreen: View {
    @ObservedObject var ViewModel : MainViewModel
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 246/255, green: 246/255, blue: 246/255).ignoresSafeArea()
                VStack(spacing: 16) {
                    NavigationLink(destination: AccountInformationView(ViewModel: ViewModel)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12).frame(height: 52).foregroundColor(.white)
                            HStack {
                                Text("Данные аккаунта")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26)).opacity(0.3)
                            }.padding(.horizontal)
                        }
                    }
                    NavigationLink(destination: SubscriptionView(ViewModel: ViewModel)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12).frame(height: 52).foregroundColor(.white)
                            HStack {
                                Text("Платная подписка")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26)).opacity(0.3)
                            }.padding(.horizontal)
                        }
                    }
                    VStack(spacing: 0) {
                        Link(destination: URL(string: "https://tradein-kuntsevo.ru/articles/kak-pravilno-vybrat-avtomobil-s-probegom/")!) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12).frame(height: 70).foregroundColor(.white)
                                HStack {
                                    Text("На что надо обращать внимание при покупке машины?")
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.black)
                                        .lineLimit(nil)
                                    Spacer()
                                    Image("strelka")
                                }.padding(.horizontal)
                            }
                        }
                        Divider()
                        Link(destination: URL(string: "https://elorda.info/ru/ekonomika/24075-nazvany-samye-populiarnye-marki-avtomobilei-v-kazakhstane")!) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12).frame(height: 70).foregroundColor(.white)
                                HStack {
                                    Text("Какие машины сейчас популярны в Казахстане?")
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.black)
                                        .lineLimit(nil)
                                    Spacer()
                                    Image("strelka")
                                }.padding(.horizontal)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
        
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(ViewModel: MainViewModel())
    }
}
