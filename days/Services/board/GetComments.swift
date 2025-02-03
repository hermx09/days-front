//
//  GetComments.swift
//  days
//
//  Created by 長山瑞 on 2024/12/19.
//

import Foundation

struct commentResponse: Codable, Equatable, Identifiable{
    let id = UUID()
    var commentId: Int
    var commentMessage: String
    var commenterId: String
    var favorite: Int
    var postId: Int
    var createdAt: String
}

func getComments(postId: Int, completion: @escaping([commentResponse]?) -> Void){
    let queryItems = [URLQueryItem(name: "postId", value: String(postId))]
    APIRequest.getRequest(endPoint: "/getComments", queryItems: queryItems){(result: Result<[commentResponse], Error>) in
        switch result{
        case .success(let comments):
            print("コメント: \(comments)")
            completion(comments)
        case .failure(let error):
            print("エラー: \(error)")
            completion(nil)
        }
    }
    
    
}
