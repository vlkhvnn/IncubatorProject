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
import FirebaseFirestore
import FirebaseFirestoreSwift

class MainViewModel : ObservableObject {
    @Published var userIsAlreadyLoggedIn = false
    @Published var userEmail = ""
    @Published var userPassword = ""
    @Published var userLoggedIn = false
    @Published var inValidEmail = false
    @Published var inValidPassword = false
    @Published var userMessage = ""
    @Published var isLoading = false
    @Published var showSignOutAlert = false
    @Published var savedUserEmail = UserDefaults.standard.string(forKey: "savedUserEmail")
    @Published var savedUserPassword = UserDefaults.standard.string(forKey: "savedUserPassword")
    @Published var userID = UserDefaults.standard.string(forKey: "userID")
    @Published var botResponse = ""
    @Published var messages : [Message] = []
    @Published var savedUserMessage = ""
    @Published var favourites : [Favourite] = []
    @Published var showingAddFavourite = false
    @Published var isLoadingResponse = false
    
    
    
    func convertChatToString() -> String {
        self.messages.suffix(10).map { message in
            if message.isUserMessage == true {
                return "user: \(message.content)"
            }
            else {
                return "assistant: \(message.content)"
            }
            
        }.joined(separator: "\n")
    }
    
    func register() {
        self.isLoading = true
        Auth.auth().createUser(withEmail: self.userEmail, password: self.userPassword) { result, error in
            if error != nil {
                print(error!.localizedDescription)
                self.inValidEmail = true
                self.isLoading = false
            }
            if let result = result {
                self.userID = Auth.auth().currentUser!.uid
                self.savedUserEmail = self.userEmail
                self.savedUserPassword = self.userPassword
                UserDefaults.standard.set(self.savedUserEmail, forKey: "savedUserEmail")
                UserDefaults.standard.set(self.userID, forKey: "userID")
                UserDefaults.standard.set(self.savedUserPassword, forKey: "savedUserPassword")
                self.isLoading = false
                self.userLoggedIn = true
            }
        }
    }
    
    func getMessages() {
        self.messages.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(Auth.auth().currentUser!.uid).collection("messages")
        ref.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            self.messages = documents.compactMap { document -> Message? in
                do {
                    // Converting each document into the Message model
                    // Note that data(as:) is a function available only in FirebaseFirestoreSwift package - remember to import it at the top
                    return try document.data(as: Message.self)
                } catch {
                    // If we run into an error, print the error in the console
                    print("Error decoding document into Message: \(error)")
                    
                    // Return nil if we run into an error - but the compactMap will not include it in the final array
                    return nil
                }
            }
            
            self.messages.sort { $0.timestamp < $1.timestamp }
        }
    }
    
    func getFavourites() {
        self.favourites.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(Auth.auth().currentUser!.uid).collection("favourties")
        ref.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            self.favourites = documents.compactMap { document -> Favourite? in
                do {
                    // Converting each document into the Message model
                    // Note that data(as:) is a function available only in FirebaseFirestoreSwift package - remember to import it at the top
                    return try document.data(as: Favourite.self)
                } catch {
                    // If we run into an error, print the error in the console
                    print("Error decoding document into Message: \(error)")
                    
                    // Return nil if we run into an error - but the compactMap will not include it in the final array
                    return nil
                }
            }
        }
    }
    
    func login() {
        self.isLoading = true
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { result, error in
            if let error = error {
                withAnimation {
                    self.inValidPassword = true
                    self.isLoading = false
                    print(error.localizedDescription)
                }
            }
            if result != nil {
                withAnimation {
                    self.userID = Auth.auth().currentUser!.uid
                    self.savedUserEmail = self.userEmail
                    self.savedUserPassword = self.userPassword
                    UserDefaults.standard.set(self.savedUserEmail, forKey: "savedUserEmail")
                    UserDefaults.standard.set(self.userID, forKey: "userID")
                    UserDefaults.standard.set(self.savedUserPassword, forKey: "savedUserPassword")
                    print("success")
                    self.isLoading = false
                    self.userLoggedIn = true
                }
            }
        }
    }
    
    func addUserMessageToFirestore() {
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(Auth.auth().currentUser!.uid)
        do {
            let newMessage = Message(content: self.savedUserMessage, isUserMessage: true, timestamp: Date())
            try ref.collection("messages").document().setData(from: newMessage)
            
        } catch {
            // If we run into an error, print the error in the console
            print("Error adding message to Firestore: \(error)")
        }
    }
    
    func addBotMessageToFirestore(text: String) {
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(Auth.auth().currentUser!.uid)
        do {
            let newMessage = Message(content: text, isUserMessage: false, timestamp: Date())
            try ref.collection("messages").document().setData(from: newMessage)
            
        } catch {
            // If we run into an error, print the error in the console
            print("Error adding message to Firestore: \(error)")
        }
    }
    
    func addFavouritesToFirestore(model: String, mark: String, city: String) {
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(Auth.auth().currentUser!.uid)
        do {
            let newFavourite = Favourite(model: model, mark: mark, city: city)
            try ref.collection("favourties").document().setData(from: newFavourite)
            
        } catch {
            // If we run into an error, print the error in the console
            print("Error adding message to Firestore: \(error)")
        }
    }
    
    func sendMessage() {
        let provider = MoyaProvider<APIService>()
        provider.request(
            .sendMessage(message: self.userMessage, chat_history: self.convertChatToString())
        ) { [self] result in
            switch result {
            case let .success(response):
                if let string = String(data: response.data, encoding: .utf8) {
                    self.isLoadingResponse = false
                    let unquotedString = string.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                    let newstring = unquotedString.replacingOccurrences(of: "\\n", with: "\n")
                    botResponse = newstring
                    self.messages.append(Message(content: botResponse, isUserMessage: false,timestamp: Date()))
                    self.addBotMessageToFirestore(text: newstring)
                    print("Answer is successfully received!")
                }
            case .failure:
                break
            }
        }
    }
    
    
    
    func signOut() {
        userLoggedIn = false
        userMessage = ""
    }
}
