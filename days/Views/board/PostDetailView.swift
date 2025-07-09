//
//  PostDetail.swift
//  days
//
//  Created by 長山瑞 on 2024/12/03.
//

import SwiftUI

struct PostDetailView: View {
    @State var commentMessage: String = ""
    @State var isCheck = false
    @Binding var postDetail: postResponse
    @Binding var userId: String
    @FocusState var focus: Bool
    @Binding var postId: Int
    @State var commentResponseList: [commentResponse] = []
    @Binding var selectedBoard: String
    @Binding var nextFavoriteCount: Int
    @Binding var isFavorite: Bool
    @State var targetCommentId: Int = 0
    
    var body: some View {
        
            VStack{
                    PostHeader(selectedBoard: $selectedBoard)
                VStack(alignment: .leading){
                    HStack{
                        Image(systemName: "person.circle")
                            .resizable()
                                .frame(width: 30, height: 30)
                        VStack(alignment: .leading){
                            Text(postDetail.posterId)
                                .font(.body)
                            Text(postDetail.createdAt)
                                .font(.caption2)
                                .foregroundColor(Color(red: 0.4039, green: 0.3961, blue: 0.3961))
                        }
                    }
                    Text(postDetail.postTitle)
                        .font(.headline)
                        .padding(5)
                    Text(postDetail.postMessage)
                        .font(.caption)
                    HStack{
                        Button(action: {
                            toggleFavorite(postId: postId, userId: userId, actionName: "favorite"){result in
                                print("開始")
                                
                                guard let result = result else{
                                    return
                                }
                                if(result){
                                    isFavorite = true
                                    nextFavoriteCount += 1
                                }else{
                                    isFavorite = false
                                    nextFavoriteCount -= 1
                                }
                            }
                        }, label: {
                            Image(systemName: isFavorite ? "heart.fill": "heart")
                                .resizable()
                                .frame(width: 8, height: 8)
                                .foregroundColor(isFavorite ? .red: .gray)
                        })
                        Text("\(nextFavoriteCount)")
                        Image(systemName: "bubble")
                        Text("\(commentResponseList.count)")
                        Image(systemName: "star")
                    }
                }
                .padding(EdgeInsets(top: 30, leading: 30, bottom: 10, trailing: 30))
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
                ScrollView{
                    ForEach(commentResponseList){comment in
                        CommentView(comment: comment, targetCommentId: $targetCommentId, isFocused: $focus)
                    }
                }
                .padding(30)
                Spacer()
                HStack{
                    Button(action: {
                        isCheck.toggle()
                    }, label: {
                        HStack{
                            Image(systemName: getSystemNameByCheckBox(isCheck: isCheck))
                                .frame(width: 10, height: 10)
                            Text("匿名")
                                .font(.callout)
                        }
                        
                        .padding(.leading, 10)
                    })
                    TextField("コメントを入力してください", text: $commentMessage)
                        .font(.caption)
                        .foregroundColor(.black)
                        .onSubmit {
                            let trimmedMessage = commentMessage.trimmingCharacters(in: .whitespacesAndNewlines)
                                    guard !trimmedMessage.isEmpty else {
                                        return
                                    }
                            insertComment(commentMessage: commentMessage, commenterId: userId, postId: postDetail.postId, targetCommentId: targetCommentId){result in
                                DispatchQueue.main.async{
                                    targetCommentId = 0
                                    print(result)
                                    commentMessage = ""
                                    getComments(postId: postId){results in
                                        DispatchQueue.main.async{
                                            guard let results = results else{
                                                print("取得失敗")
                                                return
                                            }
                                            commentResponseList = results
                                        }
                                    }
                                }
                            }
                        }
                        .focused($focus)
                        .submitLabel(.send)
                    Spacer()
                    Button(action: {
                        focus = false
                        let trimmedMessage = commentMessage.trimmingCharacters(in: .whitespacesAndNewlines)
                                guard !trimmedMessage.isEmpty else {
                                    return
                                }
                        insertComment(commentMessage: commentMessage, commenterId: userId, postId: postDetail.postId, targetCommentId: targetCommentId){result in
                            DispatchQueue.main.async{
                                targetCommentId = 0
                                print(result)
                                commentMessage = ""
                                getComments(postId: postId){results in
                                    DispatchQueue.main.async{
                                        guard let results = results else{
                                            print("取得失敗")
                                            return
                                        }
                                        commentResponseList = results
                                    }
                                }
                            }
                        }
                    }, label: {
                        Image(systemName: "paperplane")
                            .padding(.trailing, 10)
                    })
                }
                .foregroundColor(Color(red: 1.0, green: 0.392, blue: 0.392))
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
                .background(Color(red: 0.95, green: 0.95, blue: 0.95), in:
                                RoundedRectangle(cornerRadius: 40))
                .padding(10)
            }
        
        .navigationBarHidden(true)
        .onAppear{
            print("どっち", isFavorite)
            getActionPost(userId: userId){results in
                DispatchQueue.main.async{
                    guard let results = results else{
                        return
                    }
                    isFavorite = results.contains { result in
                        result.postId == postId && result.actionName == "favorite"
                    }
                }
            }
            getPostFavorite(postId: postId){result in
                DispatchQueue.main.async{
                    guard let result = result else{
                        return
                    }
                    nextFavoriteCount = result
                }
            }
            getComments(postId: postId){results in
                DispatchQueue.main.async{
                    guard let results = results else{
                        print("取得失敗")
                        return
                    }
                    commentResponseList = results
                }
            }
        }
    }
}

func getSystemNameByCheckBox(isCheck: Bool) -> String{
    if(isCheck){
        return "checkmark.square"
    }else{
        return "square"
    }
}

/*#Preview {
    PostDetailView()
}*/
