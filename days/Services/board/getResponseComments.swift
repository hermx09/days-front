//
//  getResponseComments.swift
//  days
//
//  Created by 長山瑞 on 2025/07/07.
//

import Foundation

struct responseCommentResponse: Codable, Equatable, Identifiable{
    var responseCommentId: Int
    var commentId: Int
    var responseMessage: String
    var commenterId: String
    var favorite: Int
    var createdAt: String
    var isAnonymous: Bool
    var id: Int { responseCommentId }
}


func getResponseComments(commentId: Int, completion: @escaping([responseCommentResponse]?) -> Void){
    let queryItems = [URLQueryItem(name: "commentId", value: String(commentId))]
    APIRequest.getRequest(endPoint: "/getResponseComments", queryItems: queryItems){(result: Result<[responseCommentResponse], Error>) in
        switch result{
        case .success(let comments):
            print("成功", comments)
            completion(comments)
        case .failure(let error):
            print("エラー: \(error)")
            completion(nil)
        }
    }
}

