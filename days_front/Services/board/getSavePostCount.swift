//
//  getPostFavorite.swift
//  days
//
//  Created by 長山瑞 on 2025/02/06.
//

import Foundation

public func getSavePostCount(postId: Int,completion: @escaping(Int?) -> Void){
    let queryItems = [URLQueryItem(name: "postId", value: String(postId))]
    APIRequest.getRequest(endPoint: "/getSavePostCount", queryItems: queryItems){(result: Result<Int, Error>) in
        switch result{
        case .success(let success):
            completion(success)
        case .failure(let error):
            completion(nil)
        }
    }
}
