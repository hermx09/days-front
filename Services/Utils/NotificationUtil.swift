//
//  Notification.swift
//  days
//
//  Created by 長山瑞 on 2025/09/14.
//

import Foundation

struct NotificationRequest: Codable {
    let recipientId: Int
    let actorId: Int
    let type: String
    let referenceTable: String?
    let referenceId: Int?
}

struct NotificationResponse: Codable, Identifiable {
    let id: Int
    let recipientId: Int
    let actorId: Int
    let type: String
    let referenceTable: String
    let referenceId: Int
    let isRead: Bool
    let createdAt: String
    let actorName: String
}

struct MarkAsReadRequest: Encodable {
    let recipientId: Int
}

enum NotificationTarget {
    case post(postResponse)
    case comment(commentResponse)
    case responseComment(responseCommentResponse)
    
    var recipientId: String {
        switch self {
        case .post(let post): return post.posterId
        case .comment(let comment): return comment.commenterId
        case .responseComment(let responseComment): return responseComment.commenterId
        }
    }
    
    var referenceTable: String {
        switch self {
        case .post: return "Posts"
        case .comment: return "Comments"
        case .responseComment: return "ResponseComments"
        }
    }
    
    var referenceId: Int {
        switch self {
        case .post(let post): return post.postId
        case .comment(let comment): return comment.commentId
        case .responseComment(let responseComment): return responseComment.commentId
        }
    }
}


struct NotificationUtil{
    static func insertNotification(
        recipientId: Int,
        actorId: Int,
        type: String,
        referenceTable: String? = nil,
        referenceId: Int? = nil,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let body = NotificationRequest(
            recipientId: recipientId,
            actorId: actorId,
            type: type,
            referenceTable: referenceTable,
            referenceId: referenceId
        )
        
        do {
            let jsonData = try JSONEncoder().encode(body)
            APIRequest.postRequestVoid(endPoint: "/insertNotification", body: jsonData, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    static func fetchNotifications(
        recipientId: Int,
        completion: @escaping (Result<[NotificationResponse], Error>) -> Void
    ) {
        let queryItems = [URLQueryItem(name: "recipientId", value: "\(recipientId)")]
        APIRequest.getRequest(endPoint: "/getNotifications", queryItems: queryItems) { (result: Result<[NotificationResponse], Error>) in
            switch result {
            case .success(let notifications):
                completion(.success(notifications))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func sendFavoriteNotification(for target: NotificationTarget, userId: String, intUserId: Int) {
        if(target.recipientId == userId){
            return
        }
        getUserData(userId: target.recipientId){user in
            guard let user = user else { return }
            NotificationUtil.insertNotification(
                recipientId: user.id,
                actorId: intUserId,
                type: "favorite",
                referenceTable: target.referenceTable,
                referenceId: target.referenceId,
                completion: {_ in}
                
            )
        }
    }
    
    static func getUnreadNotificationsCount(recipientId: Int, completion: @escaping (Result<Int, Error>) -> Void){
        let queryItems = [URLQueryItem(name: "recipientId", value: "\(recipientId)")]
        APIRequest.getRequest(endPoint: "/getUnreadNotificationsCount", queryItems: queryItems) { (result: Result<Int, Error>) in
            switch result {
            case .success(let unreadNotificationsCount):
                completion(.success(unreadNotificationsCount))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func markNotificationsAsRead(recipientId: Int, completion: @escaping (Result<Void, Error>) -> Void){
        let body = MarkAsReadRequest(recipientId: recipientId)
        
        do {
            let jsonData = try JSONEncoder().encode(body)
            APIRequest.postRequestVoid(endPoint: "/markNotificationAsRead", body: jsonData, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    static func getPostInfoByNotification(referenceTable: String, referenceId: Int, completion: @escaping (Result<postResponse, Error>) -> Void){
        let queryItems = [URLQueryItem(name: "referenceTable", value: String(referenceTable)), URLQueryItem(name: "referenceId", value: String(referenceId))]
        APIRequest.getRequest(endPoint: "/getPostInfoByNotification", queryItems: queryItems) { (result: Result<postResponse, Error>) in
            switch result {
            case .success(let postResponse):
                completion(.success(postResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

