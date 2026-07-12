import Foundation

struct BlockUserRequest: Codable, Equatable{
    let blockerId: Int
    let blockedId: Int
}

func blockUser(blockerId: Int, blockedId: Int, completion: @escaping(Bool) -> Void){
    
    let requestBody = BlockUserRequest(blockerId: blockerId, blockedId: blockedId)
    let jsonData = try? JSONEncoder().encode(requestBody)
    
    APIRequest.postRequest(endPoint: "/blockUser", body: jsonData){(result: Result<Bool, Error>) in
        switch result{
        case .success(let success):
            completion(true)
        case .failure(let error):
            print(error)
            completion(false)
        }
    }
}

func checkBlockStatus(userId: Int, targetId: Int, completion: @escaping(Bool) -> Void){
    let queryItems = [URLQueryItem(name: "userId", value: String(userId)), URLQueryItem(name: "targetId", value: String(targetId))]
    APIRequest.getRequest(endPoint: "/checkBlockStatus", queryItems: queryItems){(result: Result<Bool, Error>) in
        switch result{
        case .success(let success):
            completion(success)
        case .failure(let error):
            print(error)
            completion(false)
        }
    }
}

func unblockUser(blockerId: Int, blockedId: Int, completion: @escaping (Bool) -> Void) {
    let requestBody = BlockUserRequest(blockerId: blockerId, blockedId: blockedId)
    guard let jsonData = try? JSONEncoder().encode(requestBody) else {
        completion(false)
        return
    }

    APIRequest.postRequest(endPoint: "/unblockUser", body: jsonData) { (result: Result<Bool, Error>) in
        switch result {
        case .success(let success):
            completion(success)
        case .failure(let error):
            print("Unblock error:", error)
            completion(false)
        }
    }
}
