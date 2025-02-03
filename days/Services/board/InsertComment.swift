//
//  InsertComment.swift
//  days
//
//  Created by 長山瑞 on 2024/12/22.
//

import Foundation

struct InsertCommentRequest: Codable, Equatable{
    let commentMessage: String
    let commenterId: String
    let postId: Int
}

struct InsertCommentResponse: Codable, Equatable, Identifiable{
    let id = UUID()
    var message: String
}

func insertComment(commentMessage: String, commenterId: String, postId: Int, completion: @escaping(String) -> Void){
        
    let requestBody = InsertCommentRequest(commentMessage: commentMessage, commenterId: commenterId, postId: postId)
        
    guard let jsonData = try? JSONEncoder().encode(requestBody) else{
        return completion("リクエストデータエンコード失敗")
    }
    
    APIRequest.postRequest(endPoint: "/insertComment", body: jsonData){(result: Result<[InsertCommentResponse], Error>) in
        var resultMessage: String
        switch result{
        case .success(let comments):
            resultMessage = "コメント完了"
        case .failure(_):
            resultMessage = "コメント失敗"
        }
        completion(resultMessage)
    }
}
