import Foundation
import SwiftUI

@MainActor
class PostViewModel: ObservableObject {

    @Published var posts: [postResponse] = []
    @Published var favoriteCount: [Int: Int] = [:]
    @Published var commentCount: [Int: Int] = [:]
    @Published var isFavoriteList: [Int: Bool] = [:]

    @Published var isLoading = false

    // MARK: - Load Posts
    func loadPosts(boardId: Int, userId: String, postType: PostType) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let results = try await getPosts(
                boardId: boardId,
                userId: userId,
                postType: postType
            )

            self.posts = results

            // 初期値セット
            for post in results {
                self.favoriteCount[post.postId] = post.favorite
            }

            await loadFavorites(userId: userId, posts: results)

        } catch {
            print("loadPosts error:", error)
        }
    }

    // MARK: - Favorites
    func toggleFavorite(post: postResponse, userId: String, intUserId: Int) {
        toggleFavorite(
            postId: post.postId,
            userId: userId,
            actionName: "favorite"
        ) { result in
            DispatchQueue.main.async {
                guard let result = result else { return }

                if result {
                    self.favoriteCount[post.postId, default: 0] += 1
                    self.isFavoriteList[post.postId] = true
                    NotificationUtil.sendFavoriteNotification(
                        for: .post(post),
                        userId: userId,
                        intUserId: intUserId
                    )
                } else {
                    self.favoriteCount[post.postId, default: 0] -= 1
                    self.isFavoriteList[post.postId] = false
                }
            }
        }
    }

    // MARK: - Favorites初期ロード
    func loadFavorites(userId: String, posts: [postResponse]) {
        FavoriteManager().loadFavorites(userId: userId, posts: posts)
    }
}
