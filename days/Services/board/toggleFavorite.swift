//
//  toggleFavorite.swift
//  days
//
//  Created by 長山瑞 on 2025/02/06.
//

import Foundation

struct toggleFavoriteRequest: Codable, Equatable{
    var postId: Int
    var userId: String
    var actionName: String
}

struct toggleFavoriteResponse: Codable, Equatable{
    var result: Bool
}

public func toggleFavorite(postId: Int, userId: String, actionName: String, completion: @escaping(Bool?) -> Void){
    
    let requestBody = toggleFavoriteRequest(postId: postId, userId: userId, actionName: actionName)
        
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
