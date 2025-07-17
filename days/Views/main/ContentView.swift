//
//  ContentView.swift
//  days
//
//  Created by 長山瑞 on 2024/08/21.
//

import SwiftUI

enum Screen: Hashable {
    case home
    case timetable
    case board
    case chat
    case otherTab
    case setting
    case addLecture
    case searchLectureResult
    case friendTable
}


struct ContentView: View {
    @State var auth: Bool = true

    @Binding var lectureData: [lectureResponse]
    @State var userId: String = ""
    @State var friendId: String = ""
    @State var faculty: String = ""
    @State var userName: String = ""
    @State var boardResponseList: [boardResponse] = []
    @State var selectedBoard = ""
    @State var postId = 0
    @State var postResponseList: [postResponse] = []
    @State var postDetail: postResponse = postResponse(postId: 0, postTitle: "", postMessage: "", posterId: "", favorite: 0, boardId: 0, createdAt: "0", isAnonymous: false)
    @State var favoriteCount: [Int: Int] = [:]

    @State private var currentTab: Screen = .home{
        didSet{
            validateToken()
        }
    }

    /// ✅ 遷移履歴を管理するパス
    @State private var path = NavigationPath()
    
    func validateToken() {
            sendToken { result in
                DispatchQueue.main.async {
                    if let result = result {
                        // トークン有効な場合
                        if result.startFlg == false {
                            // サーバーが無効判定
                            auth = true
                            userId = ""
                            UserDefaults.standard.removeObject(forKey: "jwtToken")
                            print("サーバーがトークン無効判定 → ログイン画面へ")
                        }
                    } else {
                        // APIエラー or トークンなし
                        auth = true
                        userId = ""
                        UserDefaults.standard.removeObject(forKey: "jwtToken")
                        print("トークン無効またはエラー → ログイン画面へ")
                    }
                }
            }
    }


    var body: some View {
        if auth {
            authView(auth: $auth, tabClick1: .constant(false), userId: $userId, userName: $userName, faculty: $faculty)
        } else {
            VStack(spacing: 0) {
                    switch currentTab {
                    case .home:
                        NavigationStack(path: $path){
                            homeView(tabClick1: .constant(false), settingFlg: .constant(false), onSettingView: {
                                path.append(Screen.setting)
                            })
                                .onAppear{
                                    validateToken()
                                }
                                .navigationDestination(for: Screen.self){screen in
                                    switch screen {
                                        case .setting:
                                            settingView(auth: $auth, settingFlg: .constant(false), path: $path)
                                        default:
                                            EmptyView()
                                    }
                                }
                        }
                    case .timetable:
                        NavigationStack(path: $path){
                            timeTableView(
                                tabClick2: .constant(false),
                                addLectureFlg: .constant(false),
                                userId: $userId,
                                friendId: $friendId,
                                friendTableFlg: .constant(false),
                                searchLectureResultFlg: .constant(false),
                                onAddLectureView: {
                                    path.append(Screen.addLecture)
                                },
                                onFriendTableView: {
                                    path.append(Screen.friendTable)
                                }
                            )
                            .navigationDestination(for: Screen.self){screen in
                                switch screen {
                                    case .addLecture:
                                    addLectureView(lectureData: $lectureData, searchLectureResultFlg: Binding.constant(false), addLectureFlg: Binding.constant(false), onSearchLectureResultView: {
                                        path.append(Screen.searchLectureResult)
                                    })
                                    case .friendTable:
                                        friendTableView(tabClick2: Binding.constant(false), friendId: $friendId)
                                    case .searchLectureResult:
                                        searchLectureResult(lectureData: $lectureData, userId: $userId)
                                    default:
                                        EmptyView()
                                }
                            }
                        }

                    case .board:
                        NavigationStack(path: $path) {
                            boardView(
                                selectedBoard: $selectedBoard,
                                postId: $postId,
                                postDetail: $postDetail,
                                postResponseList: $postResponseList,
                                userId: $userId,
                                boardResponseList: $boardResponseList
                            )
                            /// ✅ 遷移先のマッピング
                            .navigationDestination(for: boardResponse.self) { board in
                                postView(
                                    board: board,
                                    selectedBoard: $selectedBoard,
                                    postResponseList: $postResponseList,
                                    postDetail: $postDetail,
                                    postId: $postId,
                                    userId: $userId,
                                    favoriteCount: $favoriteCount,
                                    boardId: .constant(board.boardId)
                                )
                                .onAppear{
                                    selectedBoard = board.boardName
                                }
                            }
                            .navigationDestination(for: postResponse.self) { post in
                                        PostDetailView(
                                            postDetail: .constant(post),
                                            userId: $userId,
                                            postId: .constant(post.postId),
                                            selectedBoard: $selectedBoard,
                                            nextFavoriteCount: .constant(post.favorite),
                                            favoriteCount: $favoriteCount
                                        )
                            }
                        }

                    case .chat:
                        Text("チャット画面 placeholder")

                    case .otherTab:
                        Text("TabName画面 placeholder")

                    default:
                        NavigationStack(path: $path){
                            homeView(tabClick1: .constant(false), settingFlg: .constant(false), onSettingView: {
                                path.append(Screen.setting)
                            })
                                .onAppear{
                                    validateToken()
                                }
                                .navigationDestination(for: Screen.self){screen in
                                    switch screen {
                                        case .setting:
                                        settingView(auth: $auth, settingFlg: .constant(false), path: $path)
                                        default:
                                            EmptyView()
                                    }
                                }
                        }
                    }
                

                Divider()

                // タブバー
                HStack {
                    tabButton(tab: .home, systemName: "house", title: "ホーム")
                    Spacer()
                    tabButton(tab: .timetable, systemName: "calendar", title: "時間割")
                    Spacer()
                    tabButton(tab: .board, systemName: "text.bubble", title: "掲示板")
                    Spacer()
                    tabButton(tab: .chat, systemName: "message", title: "チャット")
                    Spacer()
                    tabButton(tab: .otherTab, systemName: "ellipsis", title: "その他")
                }
                .padding()
                .background(Color(.systemGray6))
            }
        }
    }

    @ViewBuilder
    private func tabButton(tab: Screen, systemName: String, title: String) -> some View {
        Button {
            currentTab = tab
        } label: {
            VStack {
                Image(systemName: systemName)
                Text(title).font(.caption)
            }
            .foregroundColor(currentTab == tab ? .blue : .gray)
        }
    }
}
