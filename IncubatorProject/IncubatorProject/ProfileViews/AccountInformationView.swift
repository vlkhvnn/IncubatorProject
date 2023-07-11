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
                TextField(ViewModel.savedUserEmail!, text: $ViewModel.userEmail)
                    .padding(.leading)
                    .frame(height: 48)
                    .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                Text("Пароль")
                TextField("", text: $ViewModel.userPassword)
                    .padding(.leading)
                    .frame(height: 48)
                    .background(Color(red: 0.96, green: 0.96, blue: 0.96))
            }
            Spacer()
            
        }.frame(maxWidth: .infinity, alignment: .leading).padding()
    }
}

struct AccountInformationView_Previews: PreviewProvider {
    static var previews: some View {
        AccountInformationView(ViewModel: MainViewModel())
    }
}
