//
//  getActionPost.swift
//  days
//
//  Created by 長山瑞 on 2025/02/06.
//

import Foundation

struct actionResponseCommentResponse: Codable, Equatable, Identifiable{
    let id = UUID()
    var responseCommentId: Int
    var actionName: String
    var createdAt: String
}

func getActionResponseComment(userId: String,completion: @escaping([actionResponseCommentResponse]?) -> Void){
    let queryItems = [URLQueryItem(name: "userId", value: String(userId))]
    APIRequest.getRequest(endPoint: "/getActionResponseComment", queryItems: queryItems){(result: Result<[actionResponseCommentResponse], Error>) in
        switch result{
        case .success(let success):
            completion(success)
        case .failure(let error):
            completion(nil)
        }
    }
}
