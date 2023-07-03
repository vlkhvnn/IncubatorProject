//
//  MainViewModel.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 03.07.2023.
//

import Foundation
import SwiftUI
import Firebase
class MainViewModel : ObservableObject {
    @Published var userEmail = ""
    @Published var userPassword = ""
    @Published var repeatedPassword = ""
    @Published var userLoggedIn = false
    @Published var inValidEmail = false
    @Published var inValidPassword = false
    @Published var chat_history : [[String: String]] = []
    
    func login() {
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { result, error in
            if let error = error {
                withAnimation {
                    self.inValidPassword = true
                    print(error.localizedDescription)
                }
            }
            if let result = result {
                withAnimation {
                    print("success")
                    self.userLoggedIn = true
                }
            }
        }
    }
    
    
    func register() {
        Auth.auth().createUser(withEmail: self.userEmail, password: self.userPassword) { result, error in
            if error != nil {
                print(error!.localizedDescription)
                self.inValidEmail = true
            }
            if let result = result {
                self.userLoggedIn = true
            }
        }
    }
    
    func formatChatToOneString() -> String {
        let formattedConversation = chat_history.map { message in
            "\(message["role"]!): \(message["content"]!)"
        }.joined(separator: "\n")
        return formattedConversation
    }
    
}
