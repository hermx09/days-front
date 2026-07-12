import Foundation
import SwiftUI

@MainActor
final class PostDetailViewModel: ObservableObject {

    @Published var commentResponseList: [commentResponse] = []

    @Published var isFavorite = false

    @Published var isSavePost = false

    @Published var nextFavoriteCount = 0

    @Published var isCommentFavoriteList: [Int: Bool] = [:]

    @Published var isResponseCommentFavoriteList: [Int: Bool] = [:]

    @Published var favoriteCount: [Int: Int] = [:]

    @Published var savePostCount: [Int: Int] = [:]

    func loadInitialData(
        postId: Int,
        userId: String
    ) async {

        await loadComments(postId: postId)

        await loadPostFavorite(
            postId: postId,
            userId: userId
        )

        await loadSavePost(
            postId: postId,
            userId: userId
        )
    }

    func loadComments(postId: Int) async {

        await withCheckedContinuation { continuation in

            getComments(postId: postId) { results in

                guard let results else {
                    continuation.resume()
                    return
                }

                self.commentResponseList = results

                continuation.resume()
            }
        }
    }

    func loadPostFavorite(
        postId: Int,
        userId: String
    ) async {

        await withCheckedContinuation { continuation in

            getActionPost(userId: userId) { results in

                guard let results else {
                    continuation.resume()
                    return
                }

                self.isFavorite = results.contains {
                    $0.postId == postId &&
                    $0.actionName == "favorite"
                }

                continuation.resume()
            }
        }
    }

    func doToggleFavorite(
        postId: Int,
        userId: String,
        post: postResponse,
        intUserId: Int
    ) async {

        await withCheckedContinuation { continuation in

            toggleFavorite(
                postId: postId,
                userId: userId,
                actionName: "favorite"
            ) { result in

                guard let result else {
                    continuation.resume()
                    return
                }

                if result {

                    self.isFavorite = true
                    self.favoriteCount[postId, default: 0] += 1

                    NotificationUtil.sendFavoriteNotification(
                        for: .post(post),
                        userId: userId,
                        intUserId: intUserId
                    )

                } else {

                    self.isFavorite = false
                    self.favoriteCount[postId, default: 0] -= 1
                }

                continuation.resume()
            }
        }
    }

    func loadSavePost(
        postId: Int,
        userId: String
    ) async {

        await withCheckedContinuation { continuation in

            isPostSaved(
                userId: userId,
                postId: postId,
                actionName: "save"
            ) { result in

                guard let result else {
                    continuation.resume()
                    return
                }

                self.isSavePost = result

                continuation.resume()
            }
        }
    }
}
