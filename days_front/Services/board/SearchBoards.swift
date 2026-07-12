import Foundation

// completionの型はResult<[BoardResponse], Error>を想定
func searchBoards(searchBoardsKeyword: String, completion: @escaping (Result<[boardResponse], Error>) -> Void) {
    let queryItems = [
        URLQueryItem(name: "keyword", value: searchBoardsKeyword)
    ]
    APIRequest.getRequest(endPoint: "/searchBoards", queryItems: queryItems){(result: Result<[boardResponse], Error>) in
        switch result{
        case .success(let boards):
            completion(.success(boards))
        case .failure(let error):
            print("エラー: \(error)")
            completion(.failure(error))
        }
    }
}
