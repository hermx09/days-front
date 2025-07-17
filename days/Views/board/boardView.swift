//
//  boardView.swift
//  days
//
//  Created by 長山瑞 on 2024/09/20.
//

import SwiftUI

struct boardView: View {
    @Binding var selectedBoard: String
    @Binding var postId: Int
    @Binding var postDetail: postResponse
    @Binding var postResponseList: [postResponse]
    @Binding var userId: String
    @Binding var boardResponseList: [boardResponse]
    @State var boardId: Int = 0
    
    var body: some View {
        
        VStack{
            HStack{
                Text("掲示板")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.bottom)
            Button(action: {}, label: {
                HStack{
                    Image(systemName: "person")
                    Text("自分の投稿")
                        .foregroundColor(.black)
                    Spacer()
                }
            })
            .padding(.bottom, 10)
            Button(action: {}, label: {
                HStack{
                    Image(systemName: "bubble.fill")
                        .foregroundColor(.green)
                    Text("コメントした投稿")
                        .foregroundColor(.black)
                    Spacer()
                }
            })
            .padding(.bottom, 10)
            Button(action: {}, label: {
                HStack{
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(.yellow)
                    Text("保存した投稿")
                        .foregroundColor(.black)
                    Spacer()
                }
            })
            .padding(.bottom, 10)
            Button(action: {}, label: {
                HStack{
                    Image(systemName: "sun.max")
                        .foregroundColor(.orange)
                    Text("みんなが見ている投稿")
                        .foregroundColor(.black)
                    Spacer()
                }
            })
            .padding(.bottom, 10)
            Button(action: {}, label: {
                HStack{
                    Image(systemName: "smiley")
                        .foregroundColor(.orange)
                    Text("人気投稿")
                        .foregroundColor(.black)
                    Spacer()
                }
            })
            .padding(.bottom, 20)
            Divider()
                .background(.gray)
            
            ForEach(boardResponseList) { board in
                            NavigationLink(value: board) {
                                HStack {
                                    Image(systemName: "paperclip")
                                        .rotationEffect(.degrees(-43))
                                    Text(board.boardName)
                                    Spacer()
                                }
                            }
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                        }
        }
        .padding(40)
        Spacer()
        .onAppear{
            getBoards(){results in
                DispatchQueue.main.async{
                    guard let results = results else{
                        return
                    }
                    boardResponseList = results
                }
            }
        }
    }
}

/*
 #Preview {
 boardView()
 }
 */
