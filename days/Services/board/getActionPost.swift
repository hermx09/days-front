//
//  getActionPost.swift
//  days
//
//  Created by 長山瑞 on 2025/02/06.
//

import Foundation

struct actionPostResponse: Codable, Equatable, Identifiable{
    let id = UUID()
    var postId: Int
    var actionName: String
    var createdAt: String
}

func getActionPost(userId: String,completion: @escaping([actionPostResponse]?) -> Void){
    let queryItems = [URLQueryItem(name: "userId", value: String(userId))]
    APIRequest.getRequest(endPoint: "/getActionPost", queryItems: queryItems){(result: Result<[actionPostResponse], Error>) in
        switch result{
        case .success(let success):
            completion(success)
        case .failure(let error):        
            completion(nil)
        }
    }
}
