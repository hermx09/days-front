import SwiftUI

struct postView: View {
    
    @StateObject private var postViewModel: PostViewModel
    
    @FocusState var isAnnouncefocus: Bool
    
    @Binding var selectedBoard: String
    @Binding var postDetail: postResponse
    @Binding var postId: Int
    @Binding var userId: String
    @Binding var boardId: Int
    @Binding var postType: PostType
    @Binding var intUserId: Int
    
    @State var announceName = ""
    @State var isPresentingInsertPostView = false
    
    let board: boardResponse
    
    init(
        board: boardResponse,
        selectedBoard: Binding<String>,
        postResponseList: Binding<[postResponse]>,
        postDetail: Binding<postResponse>,
        postId: Binding<Int>,
        userId: Binding<String>,
        favoriteCount: Binding<[Int: Int]>,
        boardId: Binding<Int>,
        postType: Binding<PostType>,
        intUserId: Binding<Int>
    ) {
        self.board = board
        self._selectedBoard = selectedBoard
        self._postDetail = postDetail
        self._postId = postId
        self._userId = userId
        self._boardId = boardId
        self._postType = postType
        self._intUserId = intUserId
        
        self._viewModel = StateObject(
            wrappedValue: PostViewModel(
                userId: userId.wrappedValue,
                boardId: boardId.wrappedValue,
                postType: postType.wrappedValue
            )
        )
    }
    
    var body: some View {
        VStack {
            
            PostHeader(selectedBoard: $selectedBoard)
            
            ScrollView {
                ForEach(postViewModel.postResponseList) { post in
                    
                    VStack {
                        Divider()
                        
                        NavigationLink(value: post) {
                            VStack(alignment: .leading) {
                                
                                Text(post.postTitle)
                                Text(post.postMessage)
                                    .font(.callout)
                                
                                HStack {
                                    
                                    Button {
                                        postViewModel.toggleFavorite(post: post, intUserId: intUserId)
                                    } label: {
                                        Image(systemName: postViewModel.favoriteMap[post.postId] ?? false ? "heart.fill" : "heart")
                                            .foregroundColor(.red)
                                    }
                                    
                                    Text("\(postViewModel.favoriteCount[post.postId] ?? 0)")
                                    
                                    Image(systemName: "bubble")
                                    Text("\(postViewModel.commentCount[post.postId] ?? 0)")
                                    
                                }
                                .font(.caption)
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            postId = post.postId
                            postDetail = post
                        })
                    }
                }
            }
            
            Spacer()
        }
        .task {
            await postViewModel.loadPosts()
        }
        .navigationBarHidden(true)
    }
}
