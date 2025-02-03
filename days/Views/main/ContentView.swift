//
//  ContentView.swift
//  days
//
//  Created by 長山瑞 on 2024/08/21.
//

import SwiftUI

struct ContentView: View {
    @State var auth:Bool = true
    @State var tabClick1:Bool = false
    @State var tabClick2:Bool = false
    @State var tabClick3:Bool = false
    @State var tabClick4:Bool = false
    @State var tabClick5:Bool = false
    @State var settingFlg: Bool = false
    @State var addLectureFlg: Bool = false
    @State var searchLectureResultFlg: Bool = false
    @State var friendTableFlg: Bool = false
    
    @Binding var lectureData: [lectureResponse]
    @State var userId: String = ""
    @State var friendId: String = ""
    @State var faculty: String = ""
    @State var userName: String = ""
    @State var boardResponseList: [boardResponse] = []
    @State var selectedBoard = ""
    @State var postId = 0;
    @State var postResponseList: [postResponse] = []
    @State var postDetail: postResponse = postResponse(postId: 0, postTitle: "", postMessage: "", posterId: "", favorite: 0, boardId: 0, createdAt: "0", isAnonymous: false)
    
    @State private var path: [String] = []
    
    func tabCancel(){
        auth = false
        tabClick1 = false
        tabClick2 = false
        tabClick3 = false
        tabClick4 = false
        tabClick5 = false
        settingFlg = false
        addLectureFlg = false
        searchLectureResultFlg = false
        friendTableFlg = false
    }
    var body: some View {
        if auth{
            authView(auth: $auth, tabClick1: $tabClick1, userId: $userId, userName: $userName, faculty: $faculty)
        }else{
            VStack{
                if tabClick1{
                    homeView(tabClick1: $tabClick1, settingFlg: $settingFlg)
                }else if tabClick2{
                    timeTableView(tabClick2: $tabClick2, addLectureFlg: $addLectureFlg, userId: $userId, friendId: $friendId, friendTableFlg: $friendTableFlg, searchLectureResultFlg: $searchLectureResultFlg)
                }else if tabClick3{
                    NavigationStack(path: $path){
                        boardView(selectedBoard: $selectedBoard, postId: $postId, postDetail: $postDetail, postResponseList: $postResponseList, userId: $userId, boardResponseList: $boardResponseList)
                    }
                    .onAppear{
                        path.removeLast(path.count)
                    }
                }else if settingFlg{
                    settingView(auth: $auth, settingFlg: $settingFlg)
                }else if addLectureFlg{
                    addLectureView(lectureData: $lectureData, searchLectureResultFlg: $searchLectureResultFlg, addLectureFlg: $addLectureFlg)
                }else if searchLectureResultFlg{
                    searchLectureResult(lectureData: $lectureData, userId: $userId)
                }else if friendTableFlg{
                    friendTableView(tabClick2: $tabClick2, friendId: $friendId)
                }
            }
            .toolbar{
                ToolbarItemGroup(placement: .bottomBar){
                    HStack{
                        Button(action: {
                            tabCancel()
                            tabClick1 = true
                        }, label: {
                            if(tabClick1){
                                VStack{
                                    Image(systemName: "star.fill")
                                    Text("ホーム")
                                        .font(.caption)
                                }
                                .foregroundColor(.blue)
                            }else{
                                VStack{
                                    Image(systemName: "star.fill")
                                    Text("ホーム")
                                        .font(.caption)
                                }
                            }
                        })
                        .foregroundColor(.gray)
                        Spacer()
                        Button(action: {
                            tabCancel()
                            tabClick2 = true
                        }, label: {
                            if(tabClick2){
                                VStack{
                                    Image(systemName: "star.fill")
                                    Text("時間割")
                                        .font(.caption)
                                }
                                .foregroundColor(.blue)
                            }else{
                                VStack{
                                    Image(systemName: "star.fill")
                                    Text("時間割")
                                        .font(.caption)
                                }
                            }
                        })
                        .foregroundColor(.gray)
                        Spacer()
                        Button(action: {
                            tabCancel()
                            tabClick3 = true
                        }, label: {
                            if(tabClick3){
                                VStack{
                                    Image(systemName: "star.fill")
                                    Text("掲示板")
                                        .font(.caption)
                                }
                                .foregroundColor(.blue)
                            }else{
                                VStack{
                                    Image(systemName: "star.fill")
                                    Text("掲示板")
                                        .font(.caption)
                                }
                            }
                        })
                        .foregroundColor(.gray)
                        
                        Button(action: {
                            tabCancel()
                            tabClick4 = true
                        }, label: {
                            if(tabClick4){
                                VStack{
                                    Image(systemName: "star.fill")
                                    Text("チャット")
                                        .font(.caption)
                                }
                                .foregroundColor(.blue)
                            }else{
                                VStack{
                                    Image(systemName: "star.fill")
                                    Text("チャット")
                                        .font(.caption)
                                }
                            }
                        })
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                        Button(action: {
                            tabCancel()
                            tabClick5 = true
                        }, label: {
                            if(tabClick5){
                                VStack{
                                    Image(systemName: "star.fill")
                                    Text("TabName")
                                        .font(.caption)
                                }
                                .foregroundColor(.blue)
                            }else{
                                VStack{
                                    Image(systemName: "star.fill")
                                    Text("TabName")
                                        .font(.caption)
                                }
                            }
                        })
                        .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}



/*#Preview {
    ContentView()
}*/
