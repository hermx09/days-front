//
//  FavoriteManager.swift
//  days
//
//  Created by 長山瑞 on 2025/07/03.
//
import Foundation
import Combine

class FavoriteManager: ObservableObject {
    @Published var isFavoriteList: [Int: Bool] = [:]
    @Published var isCommentFavoriteList: [Int: Bool] = [:]
    @Published var isResponseCommentFavoriteList: [Int: Bool] = [:]    
    
    func loadFavorites(userId: String, posts: [postResponse]) {
        getActionPost(userId: userId) { results in
            DispatchQueue.main.async {
                guard let results = results else { return }
                let favoritePostIds = Set(results.filter { $0.actionName == "favorite" }.map { $0.postId })
                for post in posts {
                    self.isFavoriteList[post.postId] = favoritePostIds.contains(post.postId)
                }
            }
        }
    }
}

