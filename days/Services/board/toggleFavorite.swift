//
//  toggleFavorite.swift
//  days
//
//  Created by 長山瑞 on 2025/02/06.
//

import Foundation

struct toggleFavoriteRequest: Codable, Equatable{
    var targetId: Int
    var userId: String
    var actionName: String
    var targetType: String
}

struct toggleFavoriteResponse: Codable, Equatable{
    var result: Bool
}

public func toggleFavorite(postId: Int? = nil, commentId: Int? = nil, responseCommentId: Int? = nil, userId: String, actionName: String, completion: @escaping(Bool?) -> Void){
    
    var targetId: Int?
    var targetType: String = ""
        
        if let id = postId {
            targetId = id
            targetType = "post"
        } else if let id = commentId {
            targetId = id
            targetType = "comment"
        } else if let id = responseCommentId {
            targetId = id
            targetType = "responseComment"
        } else {
            completion(nil)
            return
        }

        guard let unwrappedTargetId = targetId else {
            completion(nil)
            return
        }

        let requestBody = toggleFavoriteRequest(
            targetId: unwrappedTargetId,
            userId: userId,
            actionName: actionName,
            targetType: targetType
        )
        
    guard let jsonData = try? JSONEncoder().encode(requestBody) else{
        return completion(nil)
    }
    
    APIRequest.postRequest(endPoint: "/toggleFavorite", body: jsonData){(result: Result<toggleFavoriteResponse, Error>) in
        print("最初の結果", result)
            switch result {
                    case .success(let response):
                            completion(response.result)  // result (Bool) を返す
                    // エラーの場合
                    case .failure(_):
                    print("エラー")
                        completion(nil)  // エラーが発生した場合はnilを返す
                    }
    }
}
