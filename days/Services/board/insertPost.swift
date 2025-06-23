//
//  insertPost.swift
//  days
//
//  Created by 長山瑞 on 2025/02/26.
//

import Foundation

struct InsertPost: Codable, Equatable{
    var title: String
    var message: String
}

func insertPost(title: String, message: String, isAnonymous: Bool, completion: @escaping(String) -> Void){
    let requestBody = InsertPost(title: title, message: message)
        
    guard let jsonData = try? JSONEncoder().encode(requestBody) else{
        return completion("リクエストデータエンコード失敗")
    }
    
    APIRequest.postRequest(endPoint: "/insertPost", body: jsonData){(result: Result<[InsertCommentResponse], Error>) in
        var resultMessage: String
        switch result{
        case .success(let comments):
            resultMessage = "投稿完了"
        case .failure(_):
            resultMessage = "投稿失敗"
        }
        completion(resultMessage)
    }
}
