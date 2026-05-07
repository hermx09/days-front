import Combine
import Foundation

class PersonalChatViewModel: ObservableObject {
    @Published var personalChats: [GetPersonalChatsResponse] = []
    @Published var errorMessage: String? = nil
    
    func fetchPersonalChats(userId: Int) {
        getPersonalChats(userId: userId) { [weak self] response in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let chats = response {
                    self.personalChats = chats                
                    self.errorMessage = nil
                } else {
                    self.errorMessage = "個人チャットの取得に失敗しました"
                }
            }
        }
    }
}
