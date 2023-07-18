//
//  MainViewModel.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 03.07.2023.
//
import Moya
import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class MainViewModel : ObservableObject {
    //MARK: Authentication properties
    @Published var mobileNo = ""
    @Published var otpCode = ""
    @Published var CLIENT_CODE = ""
    @Published var showOTPField = false
    
    //MARK: Chat properties
    @Published var botResponse = ""
    @Published var messages : [Message] = []
    @Published var favourites : [Message] = []
    @Published var savedUserMessage = ""
    @Published var userMessage = ""
    
    //MARK: Alerts
    @Published var showSignOutAlert = false
    @Published var showClearChatAlert = false
    
    
    @Published var isLoading = false
    @Published var userID = UserDefaults.standard.string(forKey: "userID")
    @Published var isLoadingResponse = false
    @Published var isMoreButtonTapped = false
    
    // MARK: Error properties
    @Published var showError : Bool = false
    @Published var errorMessage = ""
    
    //MARK: App Log Status
    @Published var logStatus = UserDefaults.standard.bool(forKey: "userIsLogged")
    
    //MARK: Firebase API's
    typealias Task = _Concurrency.Task
    func getOTPCode() {
        UIApplication.shared.closeKeyBoard()
        Task{
            do {
                //MARK: Disable it when testing with Real Device
                Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                
                let code = try await PhoneAuthProvider.provider().verifyPhoneNumber("+\(mobileNo)", uiDelegate: nil)
                   
                await MainActor.run(body: {
                    CLIENT_CODE = code
                    //MARK: Enabling OTP Field When It's Success
                    withAnimation(.easeInOut) {
                        showOTPField = true
                    }
                })
            }
            catch {
                await handleError(error: error)
            }
        }
        
    }
    
    func verifyOTPCode() {
        UIApplication.shared.closeKeyBoard()
        Task {
            do {
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: CLIENT_CODE, verificationCode: otpCode)
                try await Auth.auth().signIn(with: credential)
                
                //MARK: User logged in successfully
                print("Success!")
                await MainActor.run(body: {
                    withAnimation(.easeInOut) {
                        logStatus = true
                        userID = Auth.auth().currentUser!.uid
                        UserDefaults.standard.set(self.userID, forKey: "userID")
                        UserDefaults.standard.set(true, forKey: "userIsLogged")
                        isLoading = false
                    }
                })
            }
            catch {
                await handleError(error: error)
            }
        }
    }
    
    func handleError(error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
    func getMessages() {
        self.messages.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(userID!).collection("messages")
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
        let ref = db.collection("Users").document(userID!).collection("messages")
        ref.whereField("isFavourite", isEqualTo: true).getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            for document in documents {
                let data = document.data()
                let id = document.documentID
                let content = data["content"] as? String ?? ""
                let isUserMessage = data["isUserMessage"] as? Bool ?? false
                let isFavourite = data["image"] as? Bool ?? true
                let timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
                let message = Message(content: content, isUserMessage: isUserMessage, timestamp: timestamp.dateValue(), isFavourite: isFavourite)
                self.favourites.append(message)
                print(message.timestamp)
            }
            self.favourites.sort { $0.timestamp < $1.timestamp }
        }
        
    }
    
    func updateFavoriteStatus(message: Message) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("Users").document(userID!).collection("messages")
        
        collectionRef.whereField("id", isEqualTo: message.id.description).getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            guard let document = documents.first else {
                print("No matching documents found")
                return
            }
            
            let documentRef = collectionRef.document(document.documentID)
            documentRef.updateData(["isFavourite": self.messages[self.getMessageIndex(message: message)].isFavourite]) { error in
                if let error = error {
                    print("Error updating favorite status: \(error)")
                } else {
                    print(document.documentID)
                    print(message.id.description)
                    print("Favorite status updated successfully!")
                }
            }
        }
    }

    func deleteChat() {
        let db = Firestore.firestore()
        let collectionRef = db.collection("Users").document(userID!).collection("messages")
        collectionRef.getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let batch = collectionRef.firestore.batch()
            
            for document in documents {
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { error in
                if let error = error {
                    print("Error deleting chat: \(error)")
                } else {
                    print("Chat deleted successfully!")
                }
            }
        }
        self.messages.removeAll()
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
                    self.addBotMessageToFirestore(text: newstring)
                    self.messages.append(Message(content: botResponse, isUserMessage: false,timestamp: Date(), isFavourite: false))
                    print("Answer is successfully received!")
                }
            case .failure:
                break
            }
        }
    }
    
    func addUserMessageToFirestore() {
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(userID!)
        do {
            let newMessage = Message(content: self.savedUserMessage, isUserMessage: true, timestamp: Date(), isFavourite: false)
            try ref.collection("messages").document().setData(from: newMessage)
            
        } catch {
            // If we run into an error, print the error in the console
            print("Error adding message to Firestore: \(error)")
        }
    }
    
    func addBotMessageToFirestore(text: String) {
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(userID!)
        do {
            let newMessage = Message(content: text, isUserMessage: false, timestamp: Date(), isFavourite: false)
            try ref.collection("messages").document().setData(from: newMessage)
            
        } catch {
            // If we run into an error, print the error in the console
            print("Error adding message to Firestore: \(error)")
        }
    }
    
    func addFavouritesToFirestore(model: String, mark: String, city: String) {
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(userID!)
        do {
            let newFavourite = Favourite(model: model, mark: mark, city: city)
            try ref.collection("favourties").document().setData(from: newFavourite)
            
        } catch {
            // If we run into an error, print the error in the console
            print("Error adding message to Firestore: \(error)")
        }
    }

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
    
    func signOut() {
        logStatus = false
        userID = ""
        UserDefaults.standard.set(self.userID, forKey: "userID")
        UserDefaults.standard.set(false, forKey: "userIsLogged")
        userMessage = ""
    }
    
    func ButtonTap() {
        self.messages.append(Message(content: self.userMessage, isUserMessage: true, timestamp: Date(), isFavourite: false))
        self.isLoadingResponse = true
        self.savedUserMessage = self.userMessage
        self.userMessage = ""
        self.addUserMessageToFirestore()
        self.sendMessage()
    }
    
    func getMessageIndex(message: Message) -> Int {
        if let index = self.messages.firstIndex(where: { $0.id == message.id }) {
            return index
        }
        return -1
    }
}


//MARK: Extensions

extension UIApplication {
    func closeKeyBoard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
    }
}
