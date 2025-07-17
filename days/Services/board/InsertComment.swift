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
    let isAnonymous: Bool
}

struct InsertResponseCommentRequest: Codable, Equatable{
    let responseMessage: String
    let commenterId: String
    let commentId: Int
    let isAnonymous: Bool
}


struct InsertCommentResponse: Codable, Equatable, Identifiable{
    let id = UUID()
    var message: String
}

func insertComment(commentMessage: String, commenterId: String, postId: Int, targetCommentId: Int, isAnonymous: Bool, completion: @escaping(String) -> Void){
    print("匿名は", isAnonymous)
    var jsonData: Data?
    var endPoint = "/insertComment"
    if(targetCommentId != 0){
        let requestResponseBody = InsertResponseCommentRequest(responseMessage: commentMessage, commenterId: commenterId, commentId: targetCommentId, isAnonymous: isAnonymous)
        endPoint = "/insertResponseComment"
        jsonData = try? JSONEncoder().encode(requestResponseBody)
    }else{
        let requestCommentBody = InsertCommentRequest(commentMessage: commentMessage, commenterId: commenterId, postId: postId, isAnonymous: isAnonymous)
        jsonData = try? JSONEncoder().encode(requestCommentBody)
    }
    
    APIRequest.postRequest(endPoint: endPoint, body: jsonData){(result: Result<[InsertCommentResponse], Error>) in
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
