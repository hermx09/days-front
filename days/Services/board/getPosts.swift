//
//  getBoards.swift
//  days
//
//  Created by 長山瑞 on 2024/10/22.
//

import Foundation

struct postResponse: Codable, Equatable, Identifiable, Hashable{
    let id = UUID()
    var postId: Int
    var postTitle: String
    var postMessage: String
    var posterId: String
    var favorite: Int
    var boardId: Int
    var createdAt: String
    var isAnonymous: Bool
}

struct postInfoForHomeResponse: Codable, Equatable, Identifiable, Hashable{
    let id = UUID()
    var postId: Int
    var boardId: Int
    var boardName: String
    var commentCount: Int
}

//func getPosts(boardId: Int, userId: String, postType: PostType, completion: @escaping([postResponse]?) -> Void){
//    
//    var queryItems: [URLQueryItem] = [
//            URLQueryItem(name: "boardId", value: String(boardId)),
//            URLQueryItem(name: "userId", value: userId)
//        ]
//        
//        // PostType に応じてクエリパラメータ追加
//        switch postType {
//        case .myPosts:
//            queryItems.append(URLQueryItem(name: "postType", value: "myPosts"))
//        case .commented:
//            queryItems.append(URLQueryItem(name: "postType", value: "commented"))
//        case .saved:
//            queryItems.append(URLQueryItem(name: "postType", value: "saved"))
//        case .popular:
//            queryItems.append(URLQueryItem(name: "postType", value: "popular"))
//        default:
//            break // .all の場合は追加なし
//        }
//        
//        APIRequest.getRequest(
//            endPoint: "/getPosts",
//            queryItems: queryItems
//        ) { (result: Result<[postResponse], Error>) in
//            switch result {
//            case .success(let posts):
//                completion(posts)
//            case .failure(let error):
//                completion(nil)
//            }
//        }
//}

func getPosts(
    boardId: Int,
    userId: String,
    postType: PostType
) async throws -> [postResponse] {
    
    var queryItems: [URLQueryItem] = [
        URLQueryItem(name: "boardId", value: String(boardId)),
        URLQueryItem(name: "userId", value: userId)
    ]
    
    // PostType に応じてクエリパラメータ追加
    switch postType {
    case .myPosts:
        queryItems.append(
            URLQueryItem(name: "postType", value: "myPosts")
        )
        
    case .commented:
        queryItems.append(
            URLQueryItem(name: "postType", value: "commented")
        )
        
    case .saved:
        queryItems.append(
            URLQueryItem(name: "postType", value: "saved")
        )
        
    case .popular:
        queryItems.append(
            URLQueryItem(name: "postType", value: "popular")
        )
        
    default:
        break
    }
    
    return try await APIRequest.getRequestAsync(
        endPoint: "/getPosts",
        queryItems: queryItems
    )
}

//func getPostsInfoForHome(completion: @escaping([postInfoForHomeResponse]?) -> Void){
//        
//        APIRequest.getRequest(
//            endPoint: "/getPostsInfoForHome"
//        ) { (result: Result<[postInfoForHomeResponse], Error>) in
//            switch result {
//            case .success(let posts):
//                completion(posts)
//            case .failure(let error):
//                completion(nil)
//            }
//        }
//}

func getPostsInfoForHome() async throws -> [postInfoForHomeResponse] {
    
    return try await APIRequest.getRequestAsync(
        endPoint: "/getPostsInfoForHome"
    )
}
