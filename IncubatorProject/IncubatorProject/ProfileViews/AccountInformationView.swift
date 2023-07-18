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
                Text("Электронная почта")
            }
            Spacer()
            Button {
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .frame(height: 54)
                        .padding()
                        .foregroundColor(.black)
                    Text("Сохранить изменения").foregroundColor(.white)
                }
            }
            
        }.frame(maxWidth: .infinity, alignment: .leading).padding().navigationBarBackButtonTitleHidden().navigationTitle("Редактировать профиль")
    }
}

struct AccountInformationView_Previews: PreviewProvider {
    static var previews: some View {
        AccountInformationView(ViewModel: MainViewModel())
    }
}
