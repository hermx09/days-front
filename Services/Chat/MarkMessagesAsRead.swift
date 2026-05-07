//
//  markMessagesAsRead.swift
//  days
//
//  Created by 長山瑞 on 2025/07/27.
//

import Foundation

struct MarkMessagesAsReadRequest: Codable, Equatable{
    let roomId: Int
    let userId: Int
    let lastReadMessageId: Int
}

func markMessagesAsRead(roomId: Int, userId: Int, lastReadMessageId: Int, completion: @escaping (Bool) -> Void) {
    let requestBody = MarkMessagesAsReadRequest(roomId: roomId, userId: userId, lastReadMessageId: lastReadMessageId)
    let jsonData = try? JSONEncoder().encode(requestBody)

    APIRequest.postRequest(endPoint: "/markMessagesAsRead", body: jsonData) { (result: Result<Bool, Error>) in
        switch result {
        case .success:
            completion(true)
        case .failure(let error):
            print("❌ 既読更新失敗: \(error)")
            completion(false)
        }
    }
}
