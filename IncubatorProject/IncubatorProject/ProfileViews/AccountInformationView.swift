//
//  AccountInformationView.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 10.07.2023.
//

import SwiftUI

struct AccountInformationView: View {
    @ObservedObject var ViewModel : MainViewModel
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Номер телефона").fontWeight(.semibold)
                Text(ViewModel.userPhone!)
                    .frame(maxWidth: .infinity)
                    .frame(alignment: .leading)
                    .padding(.vertical)
                    .cornerRadius(8)
                    .border(.black.opacity(0.5))
                    
            }.padding(.vertical)
            Spacer()
            Button {
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 54)
                        .padding()
                        .foregroundColor(.accentColor)
                    Text("Сохранить изменения").foregroundColor(.white)
                }
            }
            
        }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal).navigationBarBackButtonTitleHidden().navigationTitle("Редактировать профиль")
    }
}

struct AccountInformationView_Previews: PreviewProvider {
    static var previews: some View {
        AccountInformationView(ViewModel: MainViewModel())
    }
}
