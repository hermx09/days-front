import Foundation

struct InsertUserRequest: Codable, Equatable {
    let userId: String
    let password: String
    let email: String
    let nickname: String
    let university: Int
    let grade: Int
}

struct User: Codable, Identifiable, Equatable {
    let id: Int
    let name: String    
    let email: String
//    let date: String   // APIがISO8601形式ならDate型に変換してもOK
    let userId: String
    let faculty: Int
    let status: String
}

func insertUser(userId: String,
                password: String,
                email: String,
                nickname: String,
                university: Int,
                grade: Int,
                completion: @escaping (User?) -> Void) {
    
    let requestBody = InsertUserRequest(
        userId: userId,
        password: password,
        email: email,
        nickname: nickname,
        university: university,
        grade: grade
    )
    
    let jsonData = try? JSONEncoder().encode(requestBody)
    
    APIRequest.postRequest(endPoint: "/insertUser", body: jsonData) { (result: Result<User, Error>) in
        switch result {
        case .success(let user):
            completion(user)
        case .failure(let error):
            print("ユーザー登録失敗:", error)
            completion(nil)
        }
    }
}
