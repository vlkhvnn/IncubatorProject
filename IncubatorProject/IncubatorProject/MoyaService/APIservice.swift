import Foundation
import Moya

enum APIService {
    case registration(email: String, phone: String, password: String)
    case authorization(userEmail: String, userPassword: String)
    case sendMessage(message: String, chat_history: String)
    case getChat
}

extension APIService: TargetType, AccessTokenAuthorizable {
    
    var baseURL: URL {
        URL(string: "https://fastapi-px6e.onrender.com")!
    }
    
    var path: String {
        switch self {
        case .authorization(_, _):
            return "/auth/users/tokens"
        case .registration(_, _, _):
            return "/auth/users"
        case .sendMessage(_, _):
            return "/auth/chat/getresponse"
        case .getChat:
            return "/auth/users/chat"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registration(_, _, _), .authorization(_, _):
            return .post
        case .sendMessage(_, _), .getChat:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .sendMessage(message, chat_history):
            let parameters: [String: Any] = [
                "chat_history": chat_history,
                "question": message,
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case let .registration(email, phone, password):
            let parameters: [String: Any] = [
                "email": email,
                "phone": phone,
                "password": password
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case let .authorization(userEmail, userPassword):
            return .requestParameters(parameters: ["username": userEmail, "password": userPassword], encoding: URLEncoding.httpBody)
        case .getChat:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var authorizationType: Moya.AuthorizationType? {
        switch self {
        case .getChat, .sendMessage(_, _):
            return .bearer
        case .authorization(_, _), .registration(_, _, _):
            return .none
        }
    }
    
}

