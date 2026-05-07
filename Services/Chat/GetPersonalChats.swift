//
//  getBoards.swift
//  days
//
//  Created by 長山瑞 on 2024/10/22.
//

import Foundation

struct GetPersonalChatsResponse: Codable, Identifiable, Hashable{
    var roomId: Int
    var partnerId: Int
    var partnerName: String
    var lastMessage: String?
    var lastMessageTime: String?
    var unreadCount: Int
    var id: Int { roomId }
}

func getPersonalChats(userId: Int, completion: @escaping([GetPersonalChatsResponse]?) -> Void){
    let queryItems = [URLQueryItem(name: "userId", value: String(userId))]
    APIRequest.getRequest(endPoint: "/getPersonalChats", queryItems: queryItems){(result: Result<[GetPersonalChatsResponse], Error>) in
        switch result{
        case .success(let success):
            completion(success)
        case .failure(let error):
            print(error)
            completion(nil)
        }
    }
}
