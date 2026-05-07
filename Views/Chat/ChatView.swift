import SwiftUI

struct ChatView: View {
    enum ChatTab {
        case group, personal
    }
    
    @State private var selectedTab: ChatTab = .group
    @Binding var selectedRoomId: Int?
    @State private var selectedChatType: ChatTab? = nil
    @State private var selectedTitle: String = ""
    @Binding var intUserId: Int
    @Binding var userId: String
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path){
            VStack {
                // タブボタンとか中身はそのまま
                HStack {
                    Button(action: {
                        selectedTab = .group
                    }) {
                        Text("グループチャット")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedTab == .group ? Color.blue.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        selectedTab = .personal
                    }) {
                        Text("個人チャット")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedTab == .personal ? Color.blue.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                Divider()
                
                if selectedTab == .group {
                    GroupChatListView(intUserId: $intUserId) { roomId, groupTitle in
                        selectedRoomId = roomId
                        selectedChatType = .group
                        selectedTitle = groupTitle
                    }
                } else {
                    PersonalChatListView(intUserId: $intUserId) { roomId, partnerName in
                        selectedRoomId = roomId
                        selectedChatType = .personal
                        selectedTitle = partnerName
                    }
                }
                
                Spacer()
                NavigationLink(
                    destination: Group {
                            if let roomId = selectedRoomId, let chatType = selectedChatType {
                                ChatRoomView(roomId: roomId, chatType: chatType, currentUserId: intUserId, selectedTitle: selectedTitle, path: $path)
                                    .onDisappear {
                                        selectedRoomId = nil
                                        selectedChatType = nil                                        
                                    }
                            } else {
                                EmptyView()
                            }
                        },
                    tag: selectedRoomId ?? -1,
                    selection: $selectedRoomId,
                    label: { EmptyView() }
                )
                .hidden()
            }
            .navigationDestination(for: ChatNavigation.self) { nav in
                ChatRoomView(
                    roomId: nav.roomId,
                    chatType: nav.chatType,
                    currentUserId: intUserId,
                    selectedTitle: nav.title,
                    path: $path
                )
            }

        }
//        .navigationDestination(for: InsertOrGetPersonalChatResponse, destination: { result in
//            ChatRoomView(roomId: result.roomId, chatType: .personal, currentUserId: intUserId, selectedTitle: result.partnerName)
//        })
    }
}

// ダミービュー
import SwiftUI

struct GroupChatListView: View {
    @State private var selectedGrade: String? = nil
    @Binding var intUserId: Int
    @StateObject private var groupChatViewModel = GroupChatViewModel()
    @State private var showCreateModal = false
    @FocusState var isGroupSearchFocused: Bool
    @State var searchGroupChatsKeyword: String = ""
    
    var onSelectChat: (Int, String) -> Void
    let grades = ["1年生", "2年生", "3年生", "4年生", "全て"]
    
    var filteredChats: [GetGroupChatsResponse] {
        groupChatViewModel.groupChats.filter { chat in
            if let selected = selectedGrade, selected != "全て" {
                return chat.tags.contains(where: { $0.contains(selected) })
            }
            return true
        }
    }
    
    var body: some View {
        VStack {
            // ✅ タイトル + プラスアイコン
            HStack {
                Text("全てのチャット")
                    .font(.title2)
                Spacer()
                
                Button(action: {
                    showCreateModal = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            SearchBarView(text: $searchGroupChatsKeyword, focus: $isGroupSearchFocused, placeholder: "チャットを検索") {
                searchGroupChats(userId: intUserId, searchGroupChatsKeyword: searchGroupChatsKeyword){result in
                    DispatchQueue.main.async{
                        switch result {
                            case .success(let chats):
                                groupChatViewModel.groupChats = chats
                            case .failure(let error):
                                print("検索失敗:", error)
                                // 必要に応じて空配列や前の状態をセット
                                groupChatViewModel.groupChats = []
                            }
                    }
                }
                isGroupSearchFocused = false
            }
            
            // ✅ 学年フィルタ
            HStack(spacing: 10) {
                ForEach(grades, id: \.self) { grade in
                    GradeButtonView(
                        grade: grade,
                        isSelected: selectedGrade == grade
                    ) {
                        selectedGrade = grade
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            ScrollView {
                LazyVStack(spacing: 6) {
                    ForEach(filteredChats, id: \.id) { chat in
                        Button(action: {
                            onSelectChat(chat.id, chat.title)
                                    }) {
                            GroupChatRow(
                                chatName: chat.title,
                                creatorName: chat.creatorName,
                                memberCount: chat.memberCount,
                                unreadCount: chat.unreadCount,
                                tags: chat.tags
                            )
                        }
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
                        )
                        .padding(.horizontal)
                    }
                }
                .foregroundColor(.black)
                .padding(.vertical, 5)
            }
        }
        .onAppear {
            groupChatViewModel.fetchGroupChats(userId: intUserId)            
        }
        // ✅ モーダル表示
        .sheet(isPresented: $showCreateModal) {
            CreateGroupChatView(userId: intUserId) {
                // 作成後にリロード
                groupChatViewModel.fetchGroupChats(userId: intUserId)
            }
        }
    }
}

struct PersonalChatListView: View {
    @StateObject private var viewModel = PersonalChatViewModel()
    @Binding var intUserId: Int
    var onSelectChat: (Int, String) -> Void
    
    var body: some View {
        VStack {
            if viewModel.personalChats.isEmpty {
                Text("DMはまだありません")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(viewModel.personalChats) { chat in
                    PersonalChatRow(
                        partnerName: chat.partnerName,
                        lastMessage: chat.lastMessage ?? "",
                        lastMessageTime: chat.lastMessageTime ?? "",
                        unreadCount: chat.unreadCount ?? 0
                    )
                    .onTapGesture {
                        onSelectChat(chat.id, chat.partnerName)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear {            
            viewModel.fetchPersonalChats(userId: intUserId)
        }
    }
}

struct GradeButtonView: View {
    var grade: String
    var isSelected: Bool = false
    var onTap: () -> Void
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            Text(grade)
                .font(.caption2) // さらに小さいフォント
                .padding(.vertical, 4) // 縦を小さく
                .padding(.horizontal, 10) // 横も少し狭く
                .foregroundColor(isSelected ? .white : .blue)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.blue : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )
        }
    }
}

struct GroupChatRow: View {
    var chatName: String
    var creatorName: String
    var memberCount: Int
//    var lastMessage: String
    var unreadCount: Int
    var tags: [String]
    
    var body: some View {
            VStack(alignment: .leading) {
                VStack(alignment: .leading){
                    HStack(spacing: 8) {
                        VStack(alignment: .leading) {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Text(String(creatorName.prefix(1)))
                                            .font(.caption)
                                            .foregroundColor(.black)
                                    )
                                
                                Text("作成者: \(creatorName)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Text(chatName)
                                    .font(.headline)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "person.3.fill")
                                        .font(.caption2)
                                    Text("\(memberCount)")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            //                        Text(lastMessage)
                            //                            .font(.caption)
                            //                            .foregroundColor(.gray)
                            //                            .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        if unreadCount > 0 {
                            Text("\(unreadCount)")
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.red)
                                .clipShape(Circle())
                                .shadow(color: Color.red.opacity(0.4), radius: 4, x: 0, y: 2)
                        }
                        
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 44, height: 44)
                            .overlay(Text(chatName.prefix(1)).font(.title2).bold())
                    }
                    
                    HStack(spacing: 6) {
                        ForEach(tags, id: \.self) { tag in
                            GroupTagView(tag: tag)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(8)
            .padding(.horizontal)
        }
}



struct GroupTagView: View {
    var tag: String
    
    var body: some View {
        Text(tag)
            .font(.caption2)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(tag == "参加可" ? Color.red : Color.gray)
            )
    }
}

struct PersonalChatRow: View {
    var partnerName: String         // 相手の名前
    var lastMessage: String         // 最後のメッセージ
    var lastMessageTime: String     // 最後のメッセージの時間（"10分前" とかフォーマット済み）
    var unreadCount: Int            // 未読数
    
    var body: some View {
        HStack(spacing: 12) {
            
            // ✅ 左のアイコン（相手のイニシャル）
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 48, height: 48)
                .overlay(
                    Text(String(partnerName.prefix(1)))
                        .font(.headline)
                        .foregroundColor(.blue)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                
                // ✅ 相手の名前
                HStack {
                    Text(partnerName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // ✅ 最後のメッセージ時間
                    Text(lastMessageTime)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // ✅ 最後のメッセージ
                Text(lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // ✅ 未読バッジ
            if unreadCount > 0 {
                Text("\(unreadCount)")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(6)
                    .background(Color.red)
                    .clipShape(Circle())
                    .shadow(color: Color.red.opacity(0.3), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color.white)
        .contentShape(Rectangle()) // タップ範囲拡大
    }
}
struct GroupChat {
    var id: Int
    var name: String
    var creatorName: String
    var memberCount: Int
    var lastMessage: String
    var unreadCount: Int
    var tags: [String]
}

struct CreateGroupChatView: View {
    let userId: Int
    var onCreated: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var groupName = ""
    @State private var description = ""
    @State private var maxMembers = 50
    @State private var isPublic = true
    
    // ✅ タグ管理
    @State private var defaultTags = ["1年生", "2年生", "3年生", "4年生"]
    @State private var selectedTags: Set<String> = []   // 選択中のタグ
    @State private var customTags: [String] = []        // 追加したカスタムタグ
    
    @State private var newTagName = "" // 追加用のタグ名
    
    var allTags: [String] {
        defaultTags + customTags
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("グループ名")) {
                    TextField("グループ名を入力", text: $groupName)
                }

                Section(header: Text("説明")) {
                    TextField("どんなグループか説明を書いてください", text: $description)
                }

                Section(header: Text("最大人数")) {
                    HStack {
                        TextField("人数", value: $maxMembers, format: .number)
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                            .textFieldStyle(.roundedBorder)
                        
                        Text("人").foregroundColor(.gray)
                        
                        Spacer()
                        Stepper("", value: $maxMembers, in: 1...500, step: 1)
                            .labelsHidden()
                    }
                    if maxMembers < 1 || maxMembers > 500 {
                        Text("※ 1〜500人の範囲で入力してください")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }

                Section(header: Text("公開設定")) {
                    Toggle("公開グループにする", isOn: $isPublic)
                }

                Section(header: Text("タグ")) {
                    ForEach(allTags, id: \.self) { tag in
                        Toggle(isOn: Binding(
                            get: { selectedTags.contains(tag) },
                            set: { newValue in
                                if newValue {
                                    selectedTags.insert(tag)
                                } else {
                                    selectedTags.remove(tag)
                                }
                            }
                        )) {
                            Text(tag)
                        }
                    }
                    HStack {
                        TextField("新しいタグを追加", text: $newTagName)
                            .textFieldStyle(.roundedBorder)
                            .submitLabel(.done) // ✅ Returnキーを「確定」にする
                            .onSubmit {
                                addCustomTag() // ✅ Return押した時も追加
                            }
                    }
                }
            }
            .navigationTitle("新規グループ作成")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("作成") {
                        createGroupChat()
                    }
                    .disabled(groupName.isEmpty)
                }
            }
            // ✅ Form 全体をタップしたらキーボード閉じる
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
        }
    }

    
    private func addCustomTag() {
        let trimmed = newTagName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        if !customTags.contains(trimmed) && !defaultTags.contains(trimmed) {
            customTags.append(trimmed)
        }
        selectedTags.insert(trimmed)
        newTagName = ""
    }
    
    private func createGroupChat() {
        let tags = Array(selectedTags)
        insertGroupChat(creatorId: userId, title: groupName, description: description, maxMembers: maxMembers, isPublic: isPublic, tags: tags){result in
            guard let result = result else{
                return
            }
            print(result)
            onCreated()
            dismiss()
        }
    }
}
