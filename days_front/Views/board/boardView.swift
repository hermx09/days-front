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
    @Binding var boardPath: NavigationPath
    @State var searchBoardsKeyword: String = ""
    @FocusState var searchBoardsFocus: Bool
    @State var searchBoardsResponseList: [boardResponse] = []
    
    @ViewBuilder //パフォーマンス考えるなら全型統一でもいい
    func iconForPostType(type: PostType) -> some View {
        switch type {
        case .myPosts:
            Image(systemName: "person")
        case .commented:
            Image(systemName: "bubble.fill").foregroundColor(.green)
        case .saved:
            Image(systemName: "star.circle.fill").foregroundColor(.yellow)
        case .popular:
            Image(systemName: "smiley").foregroundColor(.orange)
        case .favorite:
            Image(systemName: "heart").foregroundColor(.red)
        case .all:
            Image(systemName: "doc.text")
        }
    }
    
    func titleForPostType(type: PostType) -> String {
        switch type {
        case .myPosts: return "自分の投稿"
        case .commented: return "コメントした投稿"
        case .saved: return "保存した投稿"
        case .popular: return "人気の投稿"
        case .favorite: return "お気に入りの投稿"
        case .all: return "全ての投稿"
        }
    }
    
    var body: some View {
        ScrollView{
            VStack{
                VStack{
                    HStack{
                        Text("掲示板")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.bottom)
                    ForEach([PostType.myPosts, .commented, .saved, .popular], id: \.self) { type in
                        Button(action: {
                            boardPath.append(type)
                        }) {
                            HStack {
                                iconForPostType(type: type)
                                Text(titleForPostType(type: type))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                        }
                        .padding(.bottom, 10)
                    }
                    //            Button(action: {}, label: {
                    //                HStack{
                    //                    Image(systemName: "sun.max")
                    //                        .foregroundColor(.orange)
                    //                    Text("みんなが見ている投稿")
                    //                        .foregroundColor(.black)
                    //                    Spacer()
                    //                }
                    //            })
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
                .padding(EdgeInsets(top: 40, leading: 40, bottom: 10, trailing: 40))
                SearchBarView(text: $searchBoardsKeyword, focus: $searchBoardsFocus, placeholder: "掲示板検索") {
                    searchBoards(searchBoardsKeyword: searchBoardsKeyword){results in
                        DispatchQueue.main.async{
                            switch results {
                            case .success(let boards):
                                searchBoardsResponseList = boards
                            case .failure(let error):
                                print("検索失敗: \(error.localizedDescription)")
                            }
                        }
                    }
                }
                .padding(10)
                ForEach(searchBoardsResponseList) { board in
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
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 20, trailing: 40))
            }
            .onTapGesture {
                searchBoardsFocus = false
            }
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
}
