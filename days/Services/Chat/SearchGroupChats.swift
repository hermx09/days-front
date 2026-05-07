import Foundation

// completionの型はResult<[BoardResponse], Error>を想定
func searchGroupChats(userId: Int, searchGroupChatsKeyword: String, completion: @escaping (Result<[GetGroupChatsResponse], Error>) -> Void) {
    let queryItems = [
        URLQueryItem(name: "keyword", value: searchGroupChatsKeyword),
        URLQueryItem(name: "userId", value: String(userId))
    ]
    APIRequest.getRequest(endPoint: "/searchGroupChats", queryItems: queryItems){(result: Result<[GetGroupChatsResponse], Error>) in
        switch result{
        case .success(let chats):
            completion(.success(chats))
        case .failure(let error):
            print("エラー: \(error)")
            completion(.failure(error))
        }
    }
}
