import SwiftUI

struct ScrollCommentView: View {
    let comments: [commentResponse]
    @Binding var scrollTargetCommentId: Int?
    @Binding var isCommentFavoriteList: [Int: Bool]
    @Binding var isResponseCommentFavoriteList: [Int: Bool]
    @Binding var userId: String
    @Binding var intUserId: Int
    @FocusState.Binding var isFocused: Bool

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                VStack {
                    ForEach(comments) { comment in
                        CommentView(
                            comment: comment,
                            targetCommentId: .constant(0),
                            isFocused: $isFocused,
                            isCommentFavoriteList: $isCommentFavoriteList,
                            isResponseCommentFavoriteList: $isResponseCommentFavoriteList,
                            userId: $userId,
                            intUserId: $intUserId
                        )
                        .id(comment.commentId)
                    }
                }
            }
            .onAppear {
                print("✅ コメント更新: \(comments.count)件")
                if let targetId = scrollTargetCommentId {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            scrollProxy.scrollTo(targetId, anchor: .top)
                        }
                        scrollTargetCommentId = nil
                    }
                }
            }
        }
        .onAppear {
            print("✅ ScrollCommentView onAppear 呼ばれた")
        }
    }
}
