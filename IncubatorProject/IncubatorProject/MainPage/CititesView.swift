//
//  CititesView.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 20.07.2023.
//

import SwiftUI

struct CitiesView: View {
    @ObservedObject var ViewModel: MainViewModel
    var body: some View {
        ScrollView {
            LazyVStack {
                Divider()
    
                ForEach(ViewModel.cities) { city in
                    HStack {
                        Text(city.name).font(.system(size: 21))
                        Spacer()
                        if ViewModel.chosenCity == city.name {
                            Image(systemName: "checkmark.square")
                                .resizable()
                                .foregroundColor(.accentColor)
                                .frame(width: 25, height: 25)
                                .scaledToFill()
                        }
                    }
                    .onTapGesture {
                        if ViewModel.chosenCity != city.name {
                            ViewModel.chosenCity = city.name
                            UserDefaults.standard.set(ViewModel.chosenCity, forKey: "chosenCity")
                        }
                        else {
                            ViewModel.chosenCity = ""
                            UserDefaults.standard.set(ViewModel.chosenCity, forKey: "chosenCity")
                        }
                    }
                    .padding(.horizontal)
                    

                    if city.name == ViewModel.cities.last!.name {
                        Divider()
                    }
                    else {
                        Divider().padding(.leading)
                    }
                            
                }
            }.background(.white)
        }.padding(.vertical).background(Color(red: 246/255, green: 246/255, blue: 246/255))
        .navigationBarBackButtonTitleHidden().navigationTitle("Ваш город")
    }
}

struct CityRow: View {
    var name: String
    var body: some View {
        HStack {
            
        }
    }
}

struct CitiesView_Previews: PreviewProvider {
    static var previews: some View {
        CitiesView(ViewModel: MainViewModel())
    }
}
