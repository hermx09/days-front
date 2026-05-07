import Combine
import Foundation

class GroupChatViewModel: ObservableObject {
    @Published var groupChats: [GetGroupChatsResponse] = []
    @Published var errorMessage: String? = nil
    
    func fetchGroupChats(userId: Int) {
        getGroupChats (userId: userId){ [weak self] response in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let chats = response {
                    self.groupChats = chats
                    self.errorMessage = nil                    
                } else {
                    self.errorMessage = "データの取得に失敗しました"
                    print(self.errorMessage)
                }
            }
        }
    }
}
