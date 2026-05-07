//
//  GetDMPartner.swift
//  days
//
//  Created by 長山瑞 on 2025/08/04.
//

import Foundation

struct getDMPartnerResponse: Codable, Identifiable, Hashable{
    var id: Int
    var name: String
    var userId: String?
}


func getDMPartner(roomId: Int, userId: Int, completion: @escaping([getDMPartnerResponse]?) -> Void){
    let queryItems = [URLQueryItem(name: "roomId", value: String(roomId)), URLQueryItem(name: "userId", value: String(userId))]
    APIRequest.getRequest(endPoint: "/getDMPartner", queryItems: queryItems){(result: Result<[getDMPartnerResponse], Error>) in
        switch result{
        case .success(let success):
            completion(success)
        case .failure(let error):
            print(error)
            completion(nil)
        }
    }
}
