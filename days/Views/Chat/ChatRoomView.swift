import SwiftUI


struct ChatNavigation: Hashable, Equatable {
    let roomId: Int
    let chatType: ChatView.ChatTab
    let title: String
}


struct ChatRoomView: View {
    @StateObject private var chatRoomViewModel: ChatRoomViewModel
    let roomId: Int
    let chatType: ChatView.ChatTab
    let currentUserId: Int
    let selectedTitle: String
    let isDM: Bool
    @State private var newMessage: String = ""
    @State private var textEditorHeight: CGFloat = 36
    @Binding var path: NavigationPath
    @FocusState private var isInputActive: Bool    // フォーカス管理
    @Environment(\.dismiss) private var dismiss
    @State var isBlocked: Bool = false
    
    init(roomId: Int, chatType: ChatView.ChatTab, currentUserId: Int, selectedTitle: String, path: Binding<NavigationPath>) {
        _chatRoomViewModel = StateObject(wrappedValue: ChatRoomViewModel(roomId: roomId, currentUserId: currentUserId, chatType: chatType))
        self.roomId = roomId
        self.chatType = chatType
        self.currentUserId = currentUserId
        self.selectedTitle = selectedTitle
        _path = path
        self.isDM = chatType == .personal
    }
    
    var body: some View {
        VStack {
            // メッセージ一覧
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(chatRoomViewModel.messages) { message in
                            ChatBubbleView(message: message, currentUserId: currentUserId, chatType: chatType, path: $path, isBlocked: $isBlocked)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .onChange(of: chatRoomViewModel.messages.count) { _ in
                    if let lastId = chatRoomViewModel.messages.last?.id {
                        withAnimation {
                            scrollProxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            if isBlocked {
                Text("このユーザーをブロックしています")
                    .foregroundColor(.gray)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemGroupedBackground))
            } else {
                HStack(spacing: 10) {
                    GrowingTextEditor(text: $newMessage, dynamicHeight: $textEditorHeight)
                        .focused($isInputActive)
                        .frame(height: max(36, textEditorHeight))
                        .padding(4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                        .overlay(
                            Group {
                                if newMessage.isEmpty {
                                    Text("メッセージを入力")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 12)
                                        .allowsHitTesting(false)
                                }
                            }, alignment: .topLeading
                        )

                    Button(action: {
                        chatRoomViewModel.sendMessage(messageText: newMessage, isDM: isDM, isBlocked: isBlocked)
                        newMessage = ""
                        isInputActive = false
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(newMessage.isEmpty ? Color.gray : Color.blue)
                            .clipShape(Circle())
                    }
                    .disabled(newMessage.isEmpty)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.white)
            }
        }
        .onAppear {
            if(chatType == .personal){
                getDMPartner(roomId: roomId, userId: currentUserId){partner in
                    DispatchQueue.main.async{
                        guard let partner = partner else {
                            return
                        }
                        checkBlockStatus(userId: currentUserId, targetId: partner[0].id){result in
                            DispatchQueue.main.async{
                                isBlocked = result
                                chatRoomViewModel.updateBlockStatus(isBlocked: result)
                                chatRoomViewModel.fetchMessages()
                            }
                        }
                    }
                }
            }else if chatType == .group {
                // グループチャットならブロック解除（falseにセット）
                isBlocked = false
                chatRoomViewModel.updateBlockStatus(isBlocked: false)
                chatRoomViewModel.fetchMessages()
            }
        }
        .navigationTitle(selectedTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
        }
        // 画面の外側をタップしたらキーボードを閉じる
        .contentShape(Rectangle())  // 背景全体にタップを反応させる
        .onTapGesture {
            isInputActive = false
        }
    }
}

// ✅ メッセージデータ構造
struct ChatMessage: Identifiable, Codable {
    let messageId: Int?
    let roomId: Int
    let senderId: Int
    let content: String
    let createdAt: String
    
    func isMine(currentUserId: Int) -> Bool {
            return senderId == currentUserId
        }
    let id = UUID()
    
    // createdAtをDate型に変換するComputed Property
    var createdAtDate: Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: createdAt)
    }

        
    // createdAtを"HH:mm"形式の文字列に変換
    var createdAtTimeString: String {
        guard let date = createdAtDate else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

// ✅ 吹き出しビュー
struct ChatBubbleView: View {
    let message: ChatMessage
    let currentUserId: Int
    let chatType: ChatView.ChatTab
    @Binding var path: NavigationPath
    @State private var pendingNavigation: ChatNavigation? = nil
    @Binding var isBlocked: Bool
    
    @State private var showProfileModal = false
    
    var isMine: Bool {
        message.isMine(currentUserId: currentUserId)
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            
            if !isMine {
                Button(action: {
                    showProfileModal = true
                }) {
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 30, height: 30)
                        .overlay(
                            Text(String(message.senderId).prefix(1))
                                .font(.headline)
                                .foregroundColor(.white)
                        )
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $showProfileModal, onDismiss: {
                    if(chatType == .personal){
                        checkBlockStatus(userId: currentUserId, targetId: message.senderId){result in
                            isBlocked = result
                        }
                    }
                }) {
                    // ✅ プロフィールモーダル
                    UserProfileView(
                        userId: message.senderId,
                        currentUserId: currentUserId,
                        chatType: chatType,
                        onNavigate: {nav in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    pendingNavigation = nav
                                }
                        }
                        
                    )
                    .presentationDetents([.medium, .large])
                }
                .onChange(of: pendingNavigation) { newValue in
                    if let nav = newValue {
                        print("Navigating to: \(nav)")
                        path.append(nav)
                        pendingNavigation = nil
                    }
                }
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text(message.content)
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(15)
                    
                    Text(message.createdAtTimeString)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
            } else {
                Spacer()
                HStack(alignment: .bottom, spacing: 4) {
                    Text(message.createdAtTimeString)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    Text(message.content)
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct UserProfileView: View {
    let userId: Int
    let currentUserId: Int
    let chatType: ChatView.ChatTab

    var onNavigate: ((ChatNavigation) -> Void)? = nil
    @State private var navigationTarget: ChatNavigation? = nil

    @Environment(\.dismiss) private var dismiss
    @State private var isBlocking = false

    var body: some View {
            VStack(spacing: 20) {
                Circle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Text(String(userId).prefix(1))
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    )

                Text("ユーザーID: \(userId)")
                    .font(.title2)

                Divider()

                if chatType == .group {
                    Button {
                        sendDM()
                    } label: {
                        Label("DMを送る", systemImage: "message")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(12)
                    }
                }

                Button {
                    if isBlocking {
                        unblockUser(blockerId: currentUserId, blockedId: userId) { _ in
                            isBlocking = false
                            isBlocking = false
                        }
                    } else {
                        blockUser(blockerId: currentUserId, blockedId: userId) { _ in
                            isBlocking = true
                            isBlocking = true
                        }
                    }
                } label: {
                    Label(isBlocking ? "ブロック解除する" : "ブロックする", systemImage: isBlocking ? "hand.thumbsup.fill" : "hand.raised.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isBlocking ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                        .cornerRadius(12)
                }


                Spacer()

                Button("閉じる") {
                    dismiss()
                }
                .padding(.top, 20)
            }
            .padding()
//            .alert("ブロックしました", isPresented: $isBlocking) {
//                Button("OK", role: .cancel) { dismiss() }
//            }
            .onAppear{
                checkBlockStatus(userId: currentUserId, targetId: userId){result in
                    DispatchQueue.main.async{
                        isBlocking = result
                        print(isBlocking)
                    }
                }
            }
        
    }

    private func sendDM() {
        insertOrGetPersonalChat(partnerId: userId, userId: currentUserId) { result in
            DispatchQueue.main.async {
                guard let result = result else { return }
                let nav = ChatNavigation(
                    roomId: result.roomId,
                    chatType: .personal,
                    title: result.partnerName
                )
                dismiss()
                
                onNavigate?(nav)
                
            }
        }
    }
}
