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
    @Published var userMessage = ""
    @Published var userToken = ""
    @Published var isLoading = false
    @Published var chat_history : [message] = []
    @Published var savedUserEmail = UserDefaults.standard.string(forKey: "savedUserEmail")
    func createMessage(dictMessage: [String:String]) -> message {
        return message(dictMessage: dictMessage)
    }
    
    struct message :Identifiable, Hashable, Codable {
        var dictMessage : [String: String]
        var id = UUID()
    }
    
    func register() {
        self.isLoading = true
        self.chat_history.append(message(dictMessage: ["role": "assistant",  "content": "Привет! Я ИИ специалист по машинам. Я могу ответить на любые ваши вопросы касательно машин и могу рекомендовать машины основываясь на ваших нуждах."]))
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
                    self.isLoading = false
                    self.userLoggedIn = true
                }
            case .failure:
                break
            }
        }
        savedUserEmail = userEmail
        UserDefaults.standard.set(savedUserEmail, forKey: "savedUserEmail")
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
        self.isLoading = true
        let provider = MoyaProvider<APIService>()
        provider.request(
            .authorization(userEmail: userEmail, userPassword: userPassword)
        ) { [self] result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    let responseData = response.data
                    let dict = convertDataToDictionary(data: responseData)
                    userToken = dict!["access_token"]!
                    print(response)
                    isLoading = false
                    userLoggedIn = true
                    print(userToken)
                }
                else {
                    isLoading = false
                    userLoggedIn = false
                    inValidPassword = true
                    print("Invalid password")
                    print(response)
                }
            case .failure:
                break
            }
        }
        savedUserEmail = userEmail
        UserDefaults.standard.set(savedUserEmail, forKey: "savedUserEmail")
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
                    if let string = String(data: response.data, encoding: .utf8) {
                        if let jsonData = string.data(using: .utf8) {
                            do {
                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: String]] {
                                    for dict in jsonArray {
                                        self.chat_history.append(message(dictMessage: dict))
                                    }
                                } else {
                                    print("Failed to convert string to array of dictionaries.")
                                }
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                        } else {
                            print("Invalid JSON string.")
                        }
                    }
                    print("Successfully received chat history")
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
                    if let string = String(data: response.data, encoding: .utf8) {
                        let unquotedString = string.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                        let newstring = unquotedString.replacingOccurrences(of: "\\n", with: "\n")
                        self.chat_history.append(message(dictMessage: ["role": "assistant",  "content": newstring]))
                        print(newstring)
                    }
                    print("Message Sent!")
                }
            case .failure:
                break
            }
        }
    }
}
