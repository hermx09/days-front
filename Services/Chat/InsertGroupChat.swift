import Foundation

struct InsertGroupChatRequest: Codable, Equatable{
    let creatorId: Int
    let title: String
    let description: String
    let maxMembers: Int
    let isPublic: Bool
    let tags: [String]
}

struct InsertGroupChatResponse: Codable, Equatable{
    let roomId: Int
    let creatorId: Int
    let title: String
    let description: String
    let maxMembers: Int
    let isPublic: Bool
}


func insertGroupChat(creatorId: Int, title: String, description: String, maxMembers: Int, isPublic: Bool, tags: [String], completion: @escaping(InsertGroupChatResponse?) -> Void){
    
    let requestBody = InsertGroupChatRequest(creatorId: creatorId, title: title, description: description, maxMembers: maxMembers, isPublic: isPublic, tags: tags)
    let jsonData = try? JSONEncoder().encode(requestBody)
    
    APIRequest.postRequest(endPoint: "/insertGroupChat", body: jsonData){(result: Result<InsertGroupChatResponse, Error>) in
        switch result{
        case .success(let success):
            completion(success)
        case .failure(let error):
            print(error)
            completion(nil)
        }
    }
}
