//
//  authControl.swift
//  days
//
//  Created by 長山瑞 on 2024/10/06.
//

import Foundation

struct myRequest: Codable{
    var idName: String
    var passName: String
}

struct authCheckResponse: Codable{
    var token: String?
    var result: User
}

struct userData: Codable, Equatable, Identifiable{
    var id: Int
    var name: String
    var password: String
    var email: String
    var date: String
    var userId: String
    var faculty: Int
}

struct tokenResponse: Codable{
    var message: String
    var startFlg: Bool
}
func loginCheck(idName: String, passName: String, userInfo: User, completion: @escaping(User?) -> Void){    
    if idName == "" || passName == ""{
        print("IDまたはPASSWORDが不正です")
        completion(nil)
        return
    }
    
    guard let url = URL(string: "http://192.168.86.79:3000/authCheck") else{
        completion(nil)
        return
    }
    
    let requestData = myRequest(idName: idName, passName: passName)
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do{
        let jsonData = try JSONEncoder().encode(requestData)
        request.httpBody = jsonData
    }catch{
        print("Error encording data: \(error)")
        completion(nil)
        return
    }
    
    URLSession.shared.dataTask(with: request){data, response, error in
        if let error = error{
            print("Error: \(error)")
            completion(nil)
            return
        }
                
        if let data = data{
            do{
                let responseData = try JSONDecoder().decode(authCheckResponse.self, from: data)
                if(responseData.result.status == "pending"){
                    print("認証中です")
                    completion(nil)
                }
                if let token = responseData.token{
                    saveToken(token: token)
                }
                completion(responseData.result)
            }catch{
                print("Error encording response: \(error)")
                completion(nil)
            }
        }
    }.resume()
    
}

func sendToken(userInfo: User, completion: @escaping(tokenResponse?) -> Void){
    if(userInfo.status == "pending"){
        print("認証中です")
        return
    }
    guard let token = UserDefaults.standard.string(forKey: "jwtToken") else{
        print("トークンが見つかりません")
        completion(nil)
        return
    }
    guard let url = URL(string: "http://192.168.86.79:3000/protected") else{
        completion(nil)
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request){ data, response, error in
        if let error = error{
            print("Error: \(error)")
            completion(nil)
            return
        }
        if let data = data{
            do{
                let responseData = try JSONDecoder().decode(tokenResponse.self, from: data)                
                completion(responseData)
            }catch{
                print("Error encording response: \(error)")
                completion(nil)
            }
        }
    }.resume()
}

func saveToken(token: String){
    UserDefaults.standard.set(token, forKey: "jwtToken")
}

func getToken() -> String?{
    return UserDefaults.standard.string(forKey: "jwtToken")
}
