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
    var isAnonymous: Bool
    var posterId: String
    var boardId: Int
}

func insertPost(title: String, message: String, isAnonymous: Bool,userId: String, boardId: Int, completion: @escaping(String) -> Void){
    if(title == ""){
        return completion("タイトルを入力してください")
    }else if (message == ""){
        return completion("内容を入力してください")
    }
    let requestBody = InsertPost(title: title, message: message, isAnonymous: isAnonymous, posterId: userId, boardId: boardId)
        
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
