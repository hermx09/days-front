//
//  postView.swift
//  days
//
//  Created by 長山瑞 on 2024/10/22.
//

import SwiftUI

enum PostType: Hashable {
    case all
    case myPosts
    case commented
    case saved
    case popular
    case favorite
}

func titleForPostType(type: PostType) -> String {
    switch type {
    case .all:
        return "すべての投稿"
    case .myPosts:
        return "自分の投稿"
    case .commented:
        return "コメントした投稿"
    case .saved:
        return "保存した投稿"
    case .popular:
        return "人気投稿"
    case .favorite:
        return "いいねした投稿"
    }
}

struct postView: View {
    @StateObject var favoriteManager = FavoriteManager()
    @FocusState var isAnnouncefocus: Bool
    @Binding var selectedBoard: String
    @State var announceName = ""
    @Binding var postResponseList: [postResponse]
    @Binding var postDetail: postResponse
    @Binding var postId: Int
    @Binding var userId: String
    @State var commentResponseList: [commentResponse] = []
    @State var commentCount: [Int: Int] = [:]
    @Binding var favoriteCount: [Int: Int]
    @Binding var boardId: Int
    @State var nextFavoriteCount: Int = 0
    @State var isFavoriteList : [Int: Bool] = [:]
    //@State var isFavorite: Bool = false
    @State var isPresentingInsertPostView = false
    @State var isPostAnonymous: Bool = false
    let board: boardResponse
    @Binding var postType: PostType
    
    init(
            board: boardResponse,
            selectedBoard: Binding<String>,
            postResponseList: Binding<[postResponse]>,
            postDetail: Binding<postResponse>,
            postId: Binding<Int>,
            userId: Binding<String>,
            favoriteCount: Binding<[Int: Int]>,
            boardId: Binding<Int>,
            postType: Binding<PostType>
        ) {
            self.board = board
            self._selectedBoard = selectedBoard
            self._postResponseList = postResponseList
            self._postDetail = postDetail
            self._postId = postId
            self._userId = userId
            self._favoriteCount = favoriteCount
            self._boardId = boardId
            self._postType = postType
        }
    
    func bindingForFavorite(postId: Int) -> Binding<Bool> {
        Binding<Bool>(
            get: {
                favoriteManager.isFavoriteList[postId] ?? false
            },
            set: { newValue in
                favoriteManager.isFavoriteList[postId] = newValue
            }
        )
    }
    
    var body: some View {
        VStack{
            PostHeader(selectedBoard: $selectedBoard)
            HStack{
                Image(systemName: "speaker.2")
                    .padding(.leading, 7)
                TextField("アナウンス", text: $announceName)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.leading, 10)
                    .font(.caption)
                    .focused($isAnnouncefocus)
                    .foregroundColor(.black)
                    .padding(7)
            }
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.1))
            .background(Color(red: 0.95, green: 0.95, blue: 0.95), in: RoundedRectangle(cornerRadius: 40))
            .padding()
            ScrollView{
                ForEach(postResponseList){post in
                    VStack{
                        Divider()
                        NavigationLink(value: post){
                            VStack{
                                Text(post.postTitle)
                                Text(post.postMessage)
                                    .font(.callout)
                                    .onAppear{
                                        getComments(postId: post.postId){results in
                                            DispatchQueue.main.async{
                                                guard let results = results else{
                                                    print("取得失敗")
                                                    return
                                                }
                                                commentResponseList = results
                                                commentCount[post.postId] = results.count
                                                favoriteCount[post.postId] = post.favorite
                                            }
                                        }
                                    }
                                HStack{
                                    Button(action: {
                                        toggleFavorite(postId: post.postId, userId: userId, actionName: "favorite"){result in
                                            guard let result = result else{
                                                return
                                            }
                                            if(result){
                                                favoriteCount[post.postId, default: 0] += 1
                                                favoriteManager.isFavoriteList[post.postId] = true
                                                nextFavoriteCount += 1
                                            }else{
                                                favoriteCount[post.postId, default: 0] -= 1
                                                favoriteManager.isFavoriteList[post.postId] = false
                                                nextFavoriteCount -= 1
                                            }
                                        }
                                    }, label: {
                                        Image(systemName: favoriteManager.isFavoriteList[post.postId] ?? false ? "heart.fill": "heart")
                                            .resizable()
                                            .frame(width: 8, height: 8)
                                            .foregroundColor(favoriteManager.isFavoriteList[post.postId] ?? false ? .red: .gray)
                                    })
                                    Text("\(favoriteCount[post.postId] ?? 0)")
                                    Image(systemName: "bubble")
                                        .resizable()
                                        .frame(width: 8, height: 8)
                                    Text("\(commentCount[post.postId] ?? 0)")
                                    Text(post.createdAt)
                                    if(post.isAnonymous){
                                        Text("匿名")
                                    }else{
                                        Text(post.posterId)
                                    }
                                }
                                .font(.caption)
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            postId = post.postId
                            postDetail = post
                        })
                    }
                    .foregroundColor(.black)
                    .onAppear{
                        getPostFavorite(postId: post.postId){result in
                            DispatchQueue.main.async{
                                guard let result = result else{
                                    return
                                }
                                favoriteCount[post.postId, default: 0] = result
                                nextFavoriteCount = favoriteCount[post.postId, default: 0]
                            }
                        }
                    }
                }
            }
            Spacer()
            Button(action: {
                isPresentingInsertPostView = true
            },label: {
                Image(systemName: "pencil")
                Text("作成")
            }
            )
            .foregroundColor(Color(red: 1.0, green: 0.32, blue: 0.32))
            .padding()
            .background(Color.white) // 背景色
            .cornerRadius(10) // 角丸
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
        }
        .sheet(isPresented: $isPresentingInsertPostView, onDismiss: {
            getPosts(boardId: boardId, userId: userId, postType: postType) { results in
                DispatchQueue.main.async {
                    guard let results = results else {
                        print("取得失敗")
                        return
                    }
                    postResponseList = results
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        favoriteManager.loadFavorites(userId: userId, posts: results)
                    }
                }
            }
        }) {
                insertPostView(isPresentingInsertPostView: $isPresentingInsertPostView, userId: $userId, boardId: $boardId)
            }
            .onAppear{
                getPosts(boardId: boardId, userId: userId, postType: postType) { results in
                    DispatchQueue.main.async {
                        guard let results = results else {
                            print("取得失敗")
                            return
                        }
                        postResponseList = results
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            favoriteManager.loadFavorites(userId: userId, posts: results)
                        }
                    }
                }
            }
        .navigationBarHidden(true)
        }
    
}

/*
#Preview {
    postView(postFlg: false)
}*/
