import Foundation

struct InsertChatMessageRequest: Codable, Equatable{
    let roomId: Int
    let senderId: Int
    let content: String
    let isDM: Bool
    let isBlocked: Bool
}


func insertChatMessage(roomId: Int, senderId: Int, content: String, isDM: Bool, isBlocked: Bool, completion: @escaping(ChatMessage?) -> Void){
    
    let requestBody = InsertChatMessageRequest(roomId: roomId, senderId: senderId, content: content, isDM: isDM, isBlocked: isBlocked)
    let jsonData = try? JSONEncoder().encode(requestBody)
    
    APIRequest.postRequest(endPoint: "/insertChatMessage", body: jsonData){(result: Result<ChatMessage, Error>) in
        switch result{
        case .success(let success):
            completion(success)
        case .failure(let error):
            print(error)
            completion(nil)
        }
    }
}
