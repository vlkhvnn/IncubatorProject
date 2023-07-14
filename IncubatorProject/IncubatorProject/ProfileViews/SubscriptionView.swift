//
//  SubscriptionView.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 10.07.2023.
//

import SwiftUI

struct SubscriptionView: View {
    @ObservedObject var ViewModel : MainViewModel
    var body: some View {
        Text("Будет доступно в следующих версиях")
            .navigationBarBackButtonTitleHidden()
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView(ViewModel: MainViewModel())
    }
}
