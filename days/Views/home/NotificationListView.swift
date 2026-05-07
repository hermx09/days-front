//
//  NotificationListView.swift
//  days
//
//  Created by 長山瑞 on 2025/09/14.
//

import SwiftUI
import Foundation

struct NotificationListView: View {
    @State var notificationList: [NotificationResponse] = []
    @Binding var intUserId: Int
    @Binding var homePath: NavigationPath
    //    @Binding var showPostDetailSheet: Bool
    @Binding var selectedPostForSheet: postResponse?
    @Binding var selectedScrollTargetCommentId: Int?
    @Binding var userId: String
    @State private var selectedPost: PostDetailScreen? = nil
    var body: some View {
        VStack{
            List(notificationList) { (notification: NotificationResponse) in
                Button(action: {
                    NotificationUtil.getPostInfoByNotification(referenceTable: notification.referenceTable, referenceId: notification.referenceId){result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let post):
                                //                                selectedPostForSheet = post
                                //                                selectedPost = PostDetailScreen(post: post, scrollTargetCommentId: nil)
                                if notification.referenceTable == "Comments" {
                                    //                                    selectedScrollTargetCommentId = notification.referenceId
                                    homePath.append(
                                        PostDetailScreen(
                                            post: post,
                                            scrollTargetCommentId: nil
                                        )
                                    )
                                } else {
                                    //                                    selectedPost = PostDetailScreen(post: post, scrollTargetCommentId: notification.referenceId)
                                    homePath.append(
                                        PostDetailScreen(
                                            post: post,
                                            scrollTargetCommentId: notification.referenceId
                                        )
                                    )
                                    //                                    selectedScrollTargetCommentId = nil
                                }
                                //                                showPostDetailSheet = true
                            case .failure(let error):
                                print("Error fetching post info: \(error)")
                            }
                        }
                    }
                }, label: {
                    VStack(alignment: .leading) {
                        
                        switch notification.type {
                        case "favorite":
                            if notification.referenceTable == "Posts" {
                                Text("\(notification.actorName) さんが あなたの投稿にいいねしました")
                                //postsだったら解決してそのまま遷移
                            } else if notification.referenceTable == "Comments" {
                                Text("\(notification.actorName) さんが あなたのコメントにいいねしました")
                                //comentsだったら解決して、commentId渡して遷移
                            }
                        default:
                            Text("通知はありません")
                        }
                        Text(notification.createdAt)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                    }
                }
                )
            }
            //            .sheet(item: $selectedPost) { screen in
            //                PostDetailView(
            //                    postDetail: .constant(screen.post),
            //                    userId: $userId,
            //                    postId: .constant(screen.post.postId),
            //                    selectedBoard: $selectedBoard,
            //                    nextFavoriteCount: .constant(screen.post.favorite),
            //                    favoriteCount: $favoriteCount,
            //                    savePostCount: $savePostCount,
            //                    intUserId: $intUserId,
            //                    scrollTargetCommentId: .constant(screen.scrollTargetCommentId)
            //                )
            //            }
        }
        .navigationDestination(item: $selectedPost) { screen in

            PostDetailView(
                postDetail: .constant(screen.post),
                userId: $userId,
                postId: .constant(screen.post.postId),
                intUserId: $intUserId,
                scrollTargetCommentId: .constant(screen.scrollTargetCommentId)
            )
        }
        .onAppear{
            NotificationUtil.fetchNotifications(recipientId: intUserId){result in
                DispatchQueue.main.async{
                    switch result {
                    case .success(let notifications):
                        self.notificationList = notifications
                        NotificationUtil.markNotificationsAsRead(recipientId: intUserId, completion: {_ in})
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}


