import Foundation

struct InsertOrGetPersonalChatRequest: Codable, Equatable{
    let partnerId: Int
    let userId: Int
}

struct InsertOrGetPersonalChatResponse: Codable, Equatable, Hashable{
    let roomId: Int
    let partnerName: String
    let id = UUID()
}

func insertOrGetPersonalChat(partnerId: Int, userId: Int, completion: @escaping(InsertOrGetPersonalChatResponse?) -> Void){
    
    let requestBody = InsertOrGetPersonalChatRequest(partnerId: partnerId, userId: userId)
    let jsonData = try? JSONEncoder().encode(requestBody)
    
    APIRequest.postRequest(endPoint: "/insertOrGetPersonalChat", body: jsonData){(result: Result<InsertOrGetPersonalChatResponse, Error>) in
        switch result{
        case .success(let success):
            completion(success)
        case .failure(let error):
            print(error)
            completion(nil)
        }
    }
}
