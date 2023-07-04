import Foundation
import Moya

enum APIService {
    case sendquestion(question: String, chat_history: String)
}

extension APIService: TargetType {
    
    var baseURL: URL {
        URL(string: "https://fastapi-px6e.onrender.com")!
    }
    
    var path: String {
        "/auth/chat/getresponse"
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case let .sendquestion(question, chat_history):
            let parameters: [String: Any] = [
                "question": question,
                "chat_history": chat_history,
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
