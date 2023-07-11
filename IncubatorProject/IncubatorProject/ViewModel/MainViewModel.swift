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
import Firebase
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
    @Published var showSignOutAlert = false
    @Published var savedUserEmail = UserDefaults.standard.string(forKey: "savedUserEmail")
    @Published var botResponse = ""
    func convertChatToString() -> String {
         self.chat_history.map { message in
            return "\(message.dictMessage["role"] ?? ""): \(message.dictMessage["content"] ?? "")"
        }.joined(separator: "\n")
    }
    
    func createMessage(dictMessage: [String:String]) -> message {
        return message(dictMessage: dictMessage)
    }
    
    struct message :Identifiable, Hashable, Codable {
        var dictMessage : [String: String]
        var id = UUID()
    }
    
//    func register() {
//        self.isLoading = true
//        let provider = MoyaProvider<APIService>()
//        provider.request(
//            .registration(
//                email: userEmail,
//                phone: userPhone,
//                password: userPassword
//            )
//        ) { [self] result in
//            switch result {
//            case let .success(response):
//                print(response)
//                if response.statusCode == 201 {
//                    let responseData = response.data
//                    let dict = convertDataToDictionary(data: responseData)
//                    userToken = dict!["access_token"]!
//                    print(responseData)
//                    self.isLoading = false
//                    self.userLoggedIn = true
//                }
//            case .failure:
//                break
//            }
//        }
//        savedUserEmail = userEmail
//        UserDefaults.standard.set(savedUserEmail, forKey: "savedUserEmail")
//    }
    
    func register() {
        self.isLoading = true
        Auth.auth().createUser(withEmail: self.userEmail, password: self.userPassword) { result, error in
            if error != nil {
                print(error!.localizedDescription)
                self.inValidEmail = true
            }
            if let result = result {
                self.isLoading = false
                self.userLoggedIn = true
            }
        }
    }
    
    func fetchChatHistory() {
        chat_history.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ChatHistory")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let role = data["role"] as? String ?? ""
                    let soobwenie = data["content"] as? String ?? ""
                    let messageinstance = message(dictMessage: ["role": role, "content": soobwenie])
                    self.chat_history.append(messageinstance)
                }
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
    
//    func login() {
//        self.isLoading = true
//        let provider = MoyaProvider<APIService>()
//        provider.request(
//            .authorization(userEmail: userEmail, userPassword: userPassword)
//        ) { [self] result in
//            switch result {
//            case let .success(response):
//                if response.statusCode == 200 {
//                    let responseData = response.data
//                    let dict = convertDataToDictionary(data: responseData)
//                    userToken = dict!["access_token"]!
//                    print(response)
//                    isLoading = false
//                    userLoggedIn = true
//                    print(userToken)
//                }
//                else {
//                    isLoading = false
//                    userLoggedIn = false
//                    inValidPassword = true
//                    print("Invalid password")
//                    print(response)
//                }
//            case .failure:
//                break
//            }
//        }
//        savedUserEmail = userEmail
//        UserDefaults.standard.set(savedUserEmail, forKey: "savedUserEmail")
//    }
    
    func login() {
        self.isLoading = true
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { result, error in
            if let error = error {
                withAnimation {
                    self.inValidPassword = true
                    print(error.localizedDescription)
                }
            }
            if result != nil {
                withAnimation {
                    print("success")
                    self.isLoading = false
                    self.userLoggedIn = true
                }
            }
        }
    }
    
    func addUserMessageToFirestore() {
        let db = Firestore.firestore()
        var message : [String : String] = [:]
        message["role"] = "user"
        message["content"] = userMessage
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ChatHistory").addDocument(data: message)
    }
    
    func addBotMessageToFireStore() {
        let db = Firestore.firestore()
        var message : [String : String] = [:]
        message["role"] = "assistant"
        message["content"] = botResponse
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ChatHistory").addDocument(data: message)
    }
    
//    func getChatHistory() {
//        let authPlugin = AccessTokenPlugin { _ in self.userToken }
//        let provider = MoyaProvider<APIService>(plugins: [authPlugin])
//        provider.request(
//            .getChat
//        ) { result in
//            switch result {
//            case let .success(response):
//                if response.statusCode == 200 {
//                    if let string = String(data: response.data, encoding: .utf8) {
//                        if let jsonData = string.data(using: .utf8) {
//                            do {
//                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: String]] {
//                                    for dict in jsonArray {
//                                        self.chat_history.append(message(dictMessage: dict))
//                                    }
//                                } else {
//                                    print("Failed to convert string to array of dictionaries.")
//                                }
//                            } catch {
//                                print("Error parsing JSON: \(error)")
//                            }
//                        } else {
//                            print("Invalid JSON string.")
//                        }
//                    }
//                    print("Successfully received chat history")
//                }
//            case .failure:
//                break
//            }
//        }
//    }
    
    func sendMessage() {
        let authPlugin = AccessTokenPlugin { _ in self.userToken }
        let provider = MoyaProvider<APIService>(plugins: [authPlugin])
        provider.request(
            .sendMessage(message: self.userMessage, chat_history: self.convertChatToString())
        ) { [self] result in
            switch result {
            case let .success(response):
                if let string = String(data: response.data, encoding: .utf8) {
                    let unquotedString = string.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                    let newstring = unquotedString.replacingOccurrences(of: "\\n", with: "\n")
                    botResponse = newstring
                    addUserMessageToFirestore()
                    addBotMessageToFireStore()
                    chat_history.append(message(dictMessage: ["role": "assistant",  "content": newstring]))
                    print("Answer is replied!")
                }
            case .failure:
                break
            }
        }
    }
    
    func signOut() {
        userToken = ""
        userLoggedIn = false
        userMessage = ""
    }
}
