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
    @State var intUserId: Int = 0
    @State var friendId: String = ""
    @State var faculty: Int = 0
    @State var userName: String = ""
    @State var boardResponseList: [boardResponse] = []
    @State var selectedBoard = ""
    @State var postId = 0
    @State var postResponseList: [postResponse] = []
    @State var postDetail: postResponse = postResponse(postId: 0, postTitle: "", postMessage: "", posterId: "", favorite: 0, boardId: 0, createdAt: "0", isAnonymous: false)
    @State var favoriteCount: [Int: Int] = [:]
    @State var savePostCount: [Int: Int] = [:]
    @State var postType: PostType = .all
    @State private var selectedRoomId: Int? = nil
    @State var selectedUniversity: Int = 0
    @State var selectedGrade: Int = 0
    @State var userInfo: User = User(id: 0, name: "", email: "", userId: "", faculty: 0, status: "pending")
    @State var isAllBoardSearching: Bool = false
    @State var showNotifications: Bool = false
//    @State private var showPostDetailSheet: Bool = false
    @State private var selectedPostForSheet: postResponse?
    @State var selectedScrollTargetCommentId: Int? = nil
    
    @State private var currentTab: Screen = .home{
        didSet{
            validateToken()
        }
    }
    
    /// ✅ 遷移履歴を管理するパス
    @State private var homePath = NavigationPath()
    @State private var timeTablePath = NavigationPath()
    @State private var boardPath = NavigationPath()
    @State private var authPath = NavigationPath()
    @State private var scrollPath = NavigationPath()
    
    func validateToken() {
        sendToken(userInfo: userInfo) { result in
            DispatchQueue.main.async {
                print(result)
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
        if (auth) {
            NavigationStack(path: $authPath){
                authView(auth: $auth, tabClick1: .constant(false), userId: $userId, userName: $userName, faculty: $faculty, intUserId: $intUserId, authPath: $authPath, userInfo: $userInfo)
                    .navigationDestination(for: AuthStep.self) { step in
                        switch step {
                        case .checkPolicy:
                            CheckPolicyView(onNext: {
                                authPath.append(AuthStep.selectSchool)
                            })
                        case .selectSchool:
                            SchoolSelectionView{university, grade in
                                selectedUniversity = university
                                selectedGrade = grade
                                authPath.append(AuthStep.verifyPhone)
                            }
                        case .verifyPhone:
                            PhoneVerificationView(onNext: {
                                authPath.append(AuthStep.registerUser)
                            })
                        case .registerUser:
                            RegisterUserView(selectedUniversity: $selectedUniversity, selectedGrade: $selectedGrade, userInfo: $userInfo, onNext: {
                                authPath.append(AuthStep.authUser)
                            })
                        case .authUser:
                            AuthUserView(path: $authPath)
                        case .authNewStudent:
                            AuthNewStudentView(userInfo: $userInfo, auth: $auth, userId: $userId, intUserId: $intUserId, tabClick1: .constant(false), authPath: $authPath)
                        case .authCurrentStudent:
                            AuthCurrentStudentView()
                        case .authGraduate:
                            AuthGraduateView()
                        }
                    }
            }
        } else {
            VStack(spacing: 0) {
                switch currentTab {
                case .home:
                    NavigationStack(path: $homePath){
                        homeView(tabClick1: .constant(false), settingFlg: .constant(false), userId: $userId, intUserId: $intUserId, homePath: $homePath, favoriteCount: $favoriteCount, onSettingView: {
                            homePath.append(Screen.setting)
                        }, isAllBoardSearching: $isAllBoardSearching, showNotifications: $showNotifications, /*showPostDetailSheet: $showPostDetailSheet, */selectedPostForSheet: $selectedPostForSheet, selectedScrollTargetCommentId: $selectedScrollTargetCommentId)
                        .onAppear{
                            validateToken()
                        }
                        .navigationDestination(for: Screen.self){screen in
                            switch screen {
                            case .setting:
                                settingView(auth: $auth, settingFlg: .constant(false), homePath: $homePath)
                            default:
                                EmptyView()
                            }
                        }
                        .navigationDestination(for: PostType.self) { type in
                            postView(
                                board: boardResponse(boardId: 0, boardName: titleForPostType(type: type), creatorId: userId),
                                selectedBoard: $selectedBoard,
                                postResponseList: $postResponseList,
                                postDetail: $postDetail,
                                postId: $postId,
                                userId: $userId,
                                favoriteCount: $favoriteCount,
                                boardId: .constant(0),
                                postType: .constant(type),
                                intUserId: $intUserId
                            )
                            .onAppear{
                                selectedBoard = titleForPostType(type: type)
                            }
                        }
                        .navigationDestination(for: boardResponse.self) { board in
                            postView(
                                board: board,
                                selectedBoard: $selectedBoard,
                                postResponseList: $postResponseList,
                                postDetail: $postDetail,
                                postId: $postId,
                                userId: $userId,
                                favoriteCount: $favoriteCount,
                                boardId: .constant(board.boardId),
                                postType: .constant(.all),
                                intUserId: $intUserId
                            )
                            .onAppear {
                                selectedBoard = board.boardName
                            }
                        }
                        .navigationDestination(for: PostDetailScreen.self) { screen in
                            PostDetailView(
                                postDetail: .constant(screen.post),
                                userId: $userId,
                                postId: .constant(screen.post.postId),
                                selectedBoard: $selectedBoard,
                                nextFavoriteCount: .constant(screen.post.favorite),
                                favoriteCount: $favoriteCount,
                                savePostCount: $savePostCount,
                                intUserId: $intUserId,
                                scrollTargetCommentId: .constant(nil)
                            )
                        }
//                        .sheet(isPresented: $showPostDetailSheet) {
//                            if let post = selectedPostForSheet {
//                                PostDetailView(
//                                    postDetail: .constant(post),
//                                    userId: $userId,
//                                    postId: .constant(post.postId),
//                                    selectedBoard: $selectedBoard,
//                                    nextFavoriteCount: .constant(post.favorite),
//                                    favoriteCount: $favoriteCount,
//                                    savePostCount: $savePostCount,
//                                    intUserId: $intUserId,
//                                    scrollTargetCommentId: $selectedScrollTargetCommentId
//                                )
//                            }
//                        }
                    }
                case .timetable:
                    NavigationStack(path: $timeTablePath){
                        timeTableView(
                            tabClick2: .constant(false),
                            addLectureFlg: .constant(false),
                            userId: $userId,
                            friendId: $friendId,
                            friendTableFlg: .constant(false),
                            searchLectureResultFlg: .constant(false),
                            onAddLectureView: {
                                timeTablePath.append(Screen.addLecture)
                            },
                            onFriendTableView: {
                                timeTablePath.append(Screen.friendTable)
                            }
                        )
                        .navigationDestination(for: Screen.self){screen in
                            switch screen {
                            case .addLecture:
                                addLectureView(lectureData: $lectureData, searchLectureResultFlg: Binding.constant(false), addLectureFlg: Binding.constant(false), onSearchLectureResultView: {
                                    timeTablePath.append(Screen.searchLectureResult)
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
                    NavigationStack(path: $boardPath) {
                        boardView(
                            selectedBoard: $selectedBoard,
                            postId: $postId,
                            postDetail: $postDetail,
                            postResponseList: $postResponseList,
                            userId: $userId,
                            boardResponseList: $boardResponseList,
                            boardPath: $boardPath
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
                                boardId: .constant(board.boardId),
                                postType: .constant(.all),
                                intUserId: $intUserId
                            )
                            .onAppear{
                                selectedBoard = board.boardName
                            }
                        }
                        .navigationDestination(for: PostType.self) { type in
                            postView(
                                board: boardResponse(boardId: 0, boardName: titleForPostType(type: type), creatorId: userId),
                                selectedBoard: $selectedBoard,
                                postResponseList: $postResponseList,
                                postDetail: $postDetail,
                                postId: $postId,
                                userId: $userId,
                                favoriteCount: $favoriteCount,
                                boardId: .constant(0),
                                postType: .constant(type),
                                intUserId: $intUserId
                            )
                            .onAppear{
                                selectedBoard = titleForPostType(type: type)
                            }
                        }
                        .navigationDestination(for: postResponse.self) { post in
                            PostDetailView(
                                postDetail: .constant(post),
                                userId: $userId,
                                postId: .constant(post.postId),
                                selectedBoard: $selectedBoard,
                                nextFavoriteCount: .constant(post.favorite),
                                favoriteCount: $favoriteCount,
                                savePostCount: $savePostCount,
                                intUserId: $intUserId,
                                scrollTargetCommentId: .constant(nil)
                            )
                        }
                    }
                    
                case .chat:
                    ChatView(selectedRoomId: $selectedRoomId, intUserId: $intUserId, userId: $userId)
                case .otherTab:
                    Text("TabName画面 placeholder")
                    
                default:
                    NavigationStack(path: $homePath){
                        homeView(tabClick1: .constant(false), settingFlg: .constant(false), userId: $userId, intUserId: $intUserId, homePath: $homePath, favoriteCount: $favoriteCount, onSettingView: {
                            homePath.append(Screen.setting)
                        }, isAllBoardSearching: $isAllBoardSearching, showNotifications: $showNotifications, /*showPostDetailSheet: $showPostDetailSheet, */selectedPostForSheet: $selectedPostForSheet, selectedScrollTargetCommentId: $selectedScrollTargetCommentId)
                        .onAppear{
                            validateToken()
                        }
                        .navigationDestination(for: Screen.self){screen in
                            switch screen {
                            case .setting:
                                settingView(auth: $auth, settingFlg: .constant(false), homePath: $homePath)
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
            if currentTab == tab {
                switch tab {
                case .home:
                    homePath = NavigationPath()
                    isAllBoardSearching = false
                    showNotifications = false
                case .timetable:
                    timeTablePath = NavigationPath()
                case .board:
                    boardPath = NavigationPath()
                case .chat:
                    selectedRoomId = nil
                default:
                    break
                }
            } else {
                currentTab = tab
            }
        } label: {
            VStack {
                Image(systemName: systemName)
                Text(title).font(.caption)
            }
            .foregroundColor(currentTab == tab ? .blue : .gray)
        }
    }
}
