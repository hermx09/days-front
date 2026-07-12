import SwiftUI

@MainActor
class ChatRoomViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []  // チャット履歴
    @Published var isLoading = false
    @Published var roomTitle: String = "チャット"
    @Published var isBlocked: Bool = false
    
    let roomId: Int
    let currentUserId: Int
    private let chatType: ChatView.ChatTab
    
    init(roomId: Int, currentUserId: Int, chatType: ChatView.ChatTab) {
        self.roomId = roomId
        self.currentUserId = currentUserId
        self.chatType = chatType
    }
    
    /// 履歴読み込み
    func fetchMessages() {
        isLoading = true
        do {
            getChatMessages(roomId: roomId, isBlocked: isBlocked){result in
                DispatchQueue.main.async{
                    guard let result = result else{
                        return
                    }
                    let fetchedMessages = result
                    self.messages = fetchedMessages.sorted(by: { $0.createdAt < $1.createdAt }) // 古い順に並べる
                    if let lastMessageId = self.messages.last?.messageId {
                        self.markAsRead(lastMessageId: lastMessageId)
                    }
                }
            }
        } catch {
            print("❌メッセージ取得失敗: \(error)")
        }
        isLoading = false
    }
    
    func updateBlockStatus(isBlocked: Bool) {
        self.isBlocked = isBlocked
    }

    
    /// メッセージ送信
    func sendMessage(messageText: String, isDM: Bool, isBlocked: Bool) {
        guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        // 送信前にローカルに仮メッセージ追加
        let tempMessage = ChatMessage(
            messageId: nil,
            roomId: roomId,
            senderId: currentUserId,
            content: messageText,
            createdAt: ""
        )
        messages.append(tempMessage)
        
        Task {
            do {
                insertChatMessage(
                    roomId: roomId,
                    senderId: currentUserId,
                    content: messageText,
                    isDM: isDM,
                    isBlocked: isBlocked
                ){result in
                    DispatchQueue.main.async{
                        guard let result = result else {
                            return
                        }
                        // 仮メッセージを正式メッセージに置換
                        let sentMessage = result
                        if let index = self.messages.firstIndex(where: { $0.messageId == nil && $0.content == messageText }) {
                            self.messages[index] = sentMessage
                        } else {
                            // もし見つからないなら追加
                            self.messages.append(sentMessage)
                        }
                    }
                }
            } catch {
                print("❌送信失敗: \(error)")
            }
        }
    }
    
    func markAsRead(lastMessageId: Int) {

        markMessagesAsRead(
            roomId: roomId,
            userId: currentUserId,
            lastReadMessageId: lastMessageId
        ) { success in
            if success {                
            }
        }
    }
}
