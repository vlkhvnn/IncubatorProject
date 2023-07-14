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
        VStack {
            Text("Избранные модели машин")
                .padding(.bottom)
                .font(.headline)
                .onAppear {
                ViewModel.getFavourites()
            }
            ScrollView {
                LazyVStack {
                    ForEach(ViewModel.favourites, id: \.self) { favourite in
                        HStack {
                            Text("\(favourite.mark) \(favourite.model)")
                            Spacer()
                            Text(favourite.city)
                        }
                        Divider()
                    }
                }
                
            }
            Spacer()
            Button {
                ViewModel.showingAddFavourite = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .frame(height: 54)
                        .foregroundColor(.black)
                    Text("Добавить машину").foregroundColor(.white)
                }
            }
        }.padding()
            
            .sheet(isPresented: $ViewModel.showingAddFavourite) {
                AddFavoutireView(ViewModel: ViewModel)
                    .presentationDetents([.fraction(0.4), .medium])
            }
            
    }
}

struct AddFavoutireView : View {
    @ObservedObject var ViewModel : MainViewModel
    @State var mark = ""
    @State var model = ""
    @State var city = ""
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                TextField("Марка", text: $mark)
                    .padding(.leading)
                    .frame(height: 48)
                    .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                TextField("Модель", text: $model )
                    .padding(.leading)
                    .frame(height: 48)
                    .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                TextField("Город", text: $city)
                    .padding(.leading)
                    .frame(height: 48)
                    .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                
            }
            Spacer()
            Button {
                ViewModel.addFavouritesToFirestore(model: model, mark: mark, city: city)
                ViewModel.showingAddFavourite.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .frame(height: 52)
                        .padding()
                        .foregroundColor(.black)
                    Text("Добавить машину").foregroundColor(.white)
                }
            }
        }.padding(.top)
        
    }
}

struct FavouriteScreen_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesScreen(ViewModel: MainViewModel())
    }
}
