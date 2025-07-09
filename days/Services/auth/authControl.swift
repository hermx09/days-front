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

struct myResponse: Codable{
    var token: String?
    var loginFlg: Bool
}

struct tokenResponse: Codable{
    var message: String
    var startFlg: Bool
}
func loginCheck(idName: String, passName: String, completion: @escaping(Bool?) -> Void){
    
    if idName == "" || passName == ""{
        print("IDまたはPASSWORDが不正です")
        completion(nil)
        return
    }
    
    print("id: \(idName)  pass: \(passName)")
    guard let url = URL(string: "http://192.168.86.220:3000/authCheck") else{
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
        print("チェック開始")
        if let error = error{
            print("Error: \(error)")
            completion(nil)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse{
            print("Status Code: \(httpResponse.statusCode)")
        }
        
        if let data = data{
            do{
                let responseData = try JSONDecoder().decode(myResponse.self, from: data)
                print("Response: \(responseData)")
                if let token = responseData.token{
                    if(responseData.loginFlg){
                        saveToken(token: token)
                    }
                }
                completion(responseData.loginFlg)
            }catch{
                print("Error encording response: \(error)")
                completion(nil)
            }
        }
    }.resume()
    
}

func sendToken(completion: @escaping(tokenResponse?) -> Void){
    guard let token = UserDefaults.standard.string(forKey: "jwtToken") else{
        print("トークンが見つかりません")
        completion(nil)
        return
    }
    
    guard let url = URL(string: "http://192.168.86.220:3000/protected") else{
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
        if let httpResponse = response as? HTTPURLResponse{
            print("Status code: \(httpResponse.statusCode)")
        }
        if let data = data{
            do{
                let responseData = try JSONDecoder().decode(tokenResponse.self, from: data)
                print("Response: \(responseData)")
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
