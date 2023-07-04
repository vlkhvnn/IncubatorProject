//
//  MainViewModel.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 03.07.2023.
//
import Moya
import Foundation
import SwiftUI
import Alamofire

class MainViewModel : ObservableObject {
    @Published var userEmail = ""
    @Published var userPhone = ""
    @Published var userPassword = ""
    @Published var repeatedPassword = ""
    @Published var userLoggedIn = false
    @Published var inValidEmail = false
    @Published var inValidPassword = false
    @Published var chat_history : [[String: String]] = []
    @Published var userMessage = ""
    @Published var userToken = ""
    
    func register() {
        let provider = MoyaProvider<APIService>()
        provider.request(
            .registration(
                email: userEmail,
                phone: userPhone,
                password: userPassword
            )
        ) { result in
            switch result {
            case let .success(response):
                print(response)
                if response.statusCode == 201 {
                    self.userLoggedIn = true
                }
            case .failure:
                break
            }
        }
        
    }
    
    func convertDataToDictionary(data: Data) -> [String: String]? {
        do {
            let jsonDecoder = JSONDecoder()
            let dictionary = try jsonDecoder.decode([String: String].self, from: data)
            return dictionary
        } catch {
            print("Error converting Data to Dictionary: \(error.localizedDescription)")
            return nil
        }
    }
    
    func login() {
        let provider = MoyaProvider<APIService>()
        provider.request(
            .authorization(userEmail: userEmail, userPassword: userPassword)
        ) { [self] result in
            switch result {
            case let .success(response):
                let responseData = response.data
                var dict = convertDataToDictionary(data: responseData)
                userToken = dict!["access_token"]!
                print(response)
                if response.statusCode == 200 {
                    userLoggedIn = true
                    print(userToken)
                }
            case .failure:
                break
            }
        }
    }
    
    func getChatHistory() {
        let authPlugin = AccessTokenPlugin { _ in self.userToken }
        let provider = MoyaProvider<APIService>(plugins: [authPlugin])
        provider.request(
            .getChat
        ) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    
                }
            case .failure:
                break
            }
        }
    }
    
    func sendMessage() {
        let authPlugin = AccessTokenPlugin { _ in self.userToken }
        let provider = MoyaProvider<APIService>(plugins: [authPlugin])
        provider.request(
            .sendMessage(message: self.userMessage)
        ) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    print("Message Sent!")
                }
            case .failure:
                break
            }
        }
    }
}
