//
//  postView.swift
//  days
//
//  Created by 長山瑞 on 2024/10/22.
//

import SwiftUI

struct postView: View {
    @StateObject var favoriteManager = FavoriteManager()
    @FocusState var focus: Bool
    @Binding var selectedBoard: String
    @State var announceName = ""
    @Binding var postResponseList: [postResponse]
    @Binding var postDetail: postResponse
    @Binding var postId: Int
    @Binding var userId: String
    @State var commentResponseList: [commentResponse] = []
    @State var commentCount: [Int: Int] = [:]
    @State var favoriteCount: [Int: Int] = [:]
    @Binding var boardId: Int
    @State var nextFavoriteCount: Int = 0
    @State var isFavoriteList : [Int: Bool] = [:]
    @State var isFavorite: Bool = false
    
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
                        .focused($focus)
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
                            NavigationLink(destination: PostDetailView(postDetail: $postDetail, userId: $userId, postId: $postId, selectedBoard: $selectedBoard, nextFavoriteCount: $nextFavoriteCount, isFavorite: bindingForFavorite(postId: post.postId))
                                           , label: {
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
                                                    print(results)
                                                    commentResponseList = results
                                                    commentCount[post.postId] = results.count
                                                    favoriteCount[post.postId] = post.favorite
                                                }
                                            }
                                        }
                                    HStack{
                                        Button(action: {
                                            toggleFavorite(postId: post.postId, userId: userId, actionName: "favorite"){result in
                                                print("開始")
                                                
                                                guard let result = result else{
                                                    return
                                                }
                                                //favoriteCount[post.postId] = (favoriteCount[post.postId] ?? 0) + (result ? 1 : -1)
                                                if(result){
                                                    favoriteCount[post.postId, default: 0] += 1
                                                    favoriteManager.isFavoriteList[post.postId] = true
                                                    //                                                isFavorite = true
                                                    nextFavoriteCount += 1
                                                }else{
                                                    favoriteCount[post.postId, default: 0] -= 1
                                                    favoriteManager.isFavoriteList[post.postId] = false
                                                    //                                                isFavorite = false
                                                    nextFavoriteCount -= 1
                                                }
                                            }
                                        }, label: {
                                            Image(systemName: favoriteManager.isFavoriteList[post.postId] ?? false ? "heart.fill": "heart")
                                                .resizable()
                                                .frame(width: 8, height: 8)
                                                .foregroundColor(favoriteManager.isFavoriteList[post.postId] ?? false ? .red: .gray)
                                            //                                        let isFavoriteTest = favoriteManager.isFavoriteList[post.postId] ?? false
                                            //                                        
                                            //                                        Image(systemName: isFavoriteTest ? "heart.fill" : "heart")
                                            //                                            .resizable()
                                            //                                            .frame(width: 8, height: 8)
                                            //                                            .foregroundColor(isFavoriteTest ? .red : .gray)
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
                            )
                            .simultaneousGesture(TapGesture().onEnded {
                                postId = post.postId
                                postDetail = post
                            })
                        }
                        .foregroundColor(.black)
                        .onAppear{
                            print(post.postId)
                            //                        isFavoriteList[post.postId] = isFavorite
                            //                        getActionPost(userId: userId){results in
                            //                            DispatchQueue.main.async{
                            //                                guard let results = results else{
                            //                                    return
                            //                                }
                            //                                for result in results{
                            //                                    print("trueにするpostId", post.postId)
                            //                                    if(result.actionName == "favorite" && result.postId == post.postId){
                            //                                        favoriteManager.isFavoriteList[post.postId] = true
                            //                                    }
                            //                                }
                            //                            }
                            //                        }
                            getPostFavorite(postId: post.postId){result in
                                DispatchQueue.main.async{
                                    guard let result = result else{
                                        return
                                    }
                                    favoriteCount[post.postId, default: 0] = result
                                    nextFavoriteCount = favoriteCount[post.postId, default: 0]
                                    print("今は", favoriteCount, "次は", nextFavoriteCount)
                                    //                                print("前どっち", isFavorite, isFavoriteList)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                Button(action: {
                    
                },
                       label: {
                    Text("投稿")
                }
                )
            }
            .onAppear{
                getPosts(boardId: boardId) { results in
                    DispatchQueue.main.async {
                        guard let results = results else {
                            print("取得失敗")
                            return
                        }
                        print(results)
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
