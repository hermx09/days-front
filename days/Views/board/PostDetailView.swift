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
    
    var body: some View {
        
            VStack{
                PostHeader(selectedBoard: $selectedBoard)
                HStack{
                    Image(systemName: "person.circle")
                    VStack{
                        Text(postDetail.posterId)
                        Text(postDetail.createdAt)
                    }
                }
                Text(postDetail.postTitle)
                Text(postDetail.postMessage)
                HStack{
                    Image(systemName: "heart.fill")
                    Text("\(postDetail.favorite)")
                    Image(systemName: "bubble")
                    Image(systemName: "star")
                }
                ForEach(commentResponseList){comment in
                    VStack{
                        Divider()
                        Button(action:{
                            
                        }, label:{
                            Text(comment.commentMessage)
                        })
                    }
                    .foregroundColor(.black)
                }
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
                            insertComment(commentMessage: commentMessage, commenterId: userId, postId: postDetail.postId){result in
                                DispatchQueue.main.async{
                                    print(result)
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
                        .submitLabel(.search)
                    Spacer()
                    Button(action: {
                        focus = false
                        insertComment(commentMessage: commentMessage, commenterId: userId, postId: postDetail.postId){result in
                            DispatchQueue.main.async{
                                print(result)
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
                .foregroundColor(.orange)
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
                .background(Color(red: 0.95, green: 0.95, blue: 0.95), in:
                                RoundedRectangle(cornerRadius: 40))
                .padding(10)
            }
        
        .navigationBarHidden(true)
        .onAppear{
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
