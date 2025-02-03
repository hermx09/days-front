//
//  postView.swift
//  days
//
//  Created by 長山瑞 on 2024/10/22.
//

import SwiftUI

struct postView: View {
    @FocusState var focus: Bool
    @Binding var selectedBoard: String
    @State var announceName = ""
    @Binding var postResponseList: [postResponse]
    @Binding var postDetail: postResponse
    @Binding var postId: Int
    @Binding var userId: String
    @State var commentResponseList: [commentResponse] = []
    @State var commentCount: [Int: Int] = [:]
    
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
                
                ForEach(postResponseList){post in
                    VStack{
                        Divider()
                        NavigationLink(destination: PostDetailView(postDetail: $postDetail, userId: $userId, postId: $postId, selectedBoard: $selectedBoard)
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
                                                commentResponseList = results
                                                commentCount[post.postId] = results.count
                                            }
                                        }
                                    }
                                HStack{
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
                }
                Spacer()
            }
        
        .navigationBarHidden(true)
        }
    
}

/*
#Preview {
    postView(postFlg: false)
}*/
