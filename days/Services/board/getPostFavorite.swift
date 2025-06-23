//
//  getPostFavorite.swift
//  days
//
//  Created by 長山瑞 on 2025/02/06.
//

import Foundation

struct getPostFavoriteResponse: Codable{

}

public func getPostFavorite(postId: Int,completion: @escaping(Int?) -> Void){
    let queryItems = [URLQueryItem(name: "postId", value: String(postId))]
    APIRequest.getRequest(endPoint: "/getPostFavorite", queryItems: queryItems){(result: Result<Int, Error>) in
        switch result{
        case .success(let success):
            print("成功", success)
            completion(success)
        case .failure(let error):
            print("失敗", error)
            completion(nil)
        }
    }
}
