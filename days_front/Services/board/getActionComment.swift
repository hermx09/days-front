//
//  getActionPost.swift
//  days
//
//  Created by 長山瑞 on 2025/02/06.
//

import Foundation

struct actionCommentResponse: Codable, Equatable, Identifiable{
    let id = UUID()
    var commentId: Int
    var actionName: String
    var createdAt: String
}

func getActionComment(userId: String,completion: @escaping([actionCommentResponse]?) -> Void){
    let queryItems = [URLQueryItem(name: "userId", value: String(userId))]
    APIRequest.getRequest(endPoint: "/getActionComment", queryItems: queryItems){(result: Result<[actionCommentResponse], Error>) in
        switch result{
        case .success(let success):
            completion(success)
        case .failure(let error):
            completion(nil)
        }
    }
}
