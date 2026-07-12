//
//  getBoards.swift
//  days
//
//  Created by 長山瑞 on 2024/10/22.
//

import Foundation

struct GetGroupChatsResponse: Codable, Identifiable, Hashable{
    var roomId: Int
    var title: String
    var creatorName: String
    var maxMembers: Int
    var isPublic: Bool
    var memberCount: Int
    var tags: [String]
    var unreadCount: Int
    var id: Int { roomId }
}

func getGroupChats(userId: Int, completion: @escaping([GetGroupChatsResponse]?) -> Void){
    let queryItems = [URLQueryItem(name: "userId", value: String(userId))]
    APIRequest.getRequest(endPoint: "/getGroupChats", queryItems: queryItems){(result: Result<[GetGroupChatsResponse], Error>) in
        switch result{
        case .success(let success):
            completion(success)
        case .failure(let error):
            print(error)
            completion(nil)
        }
    }
}
