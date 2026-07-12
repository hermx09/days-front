//
//  getBoards.swift
//  days
//
//  Created by 長山瑞 on 2024/10/22.
//

import Foundation

func getChatMessages(roomId: Int, isBlocked: Bool, completion: @escaping([ChatMessage]?) -> Void){
    let queryItems = [URLQueryItem(name: "roomId", value: String(roomId)), URLQueryItem(name: "isBlocked", value: String(isBlocked))]
    APIRequest.getRequest(endPoint: "/getChatMessages", queryItems: queryItems){(result: Result<[ChatMessage], Error>) in
        switch result{
        case .success(let success):
            completion(success)
        case .failure(let error):
            print(error)
            completion(nil)
        }
    }
}
