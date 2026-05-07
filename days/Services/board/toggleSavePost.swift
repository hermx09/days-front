//
//  toggleFavorite.swift
//  days
//
//  Created by 長山瑞 on 2025/02/06.
//

import Foundation

struct toggleSavePostRequest: Codable, Equatable{
    var postId: Int
    var userId: String
    var actionName: String
}

struct toggleSavePostResponse: Codable, Equatable{
    var result: Bool
}

public func toggleSavePost(postId: Int, userId: String, actionName: String, completion: @escaping(Bool?) -> Void){
    
    let requestBody = toggleSavePostRequest(
        postId: postId,
        userId: userId,
        actionName: actionName,
    )
        
    guard let jsonData = try? JSONEncoder().encode(requestBody) else{
        return completion(nil)
    }
    
    APIRequest.postRequest(endPoint: "/toggleSavePost", body: jsonData){(result: Result<toggleSavePostResponse, Error>) in
            switch result {
                    case .success(let response):
                            completion(response.result)
                    case .failure(_):
                    print("エラー")
                        completion(nil)
                    }
    }
}
