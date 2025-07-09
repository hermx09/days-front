//
//  sendRequest.swift
//  days
//
//  Created by 長山瑞 on 2024/09/22.
//

import Foundation

struct MyRequest: Codable{
    let friendName: String
}
struct MyResponse: Codable, Identifiable{
    let id = UUID()
    var resultName: String
    var userId: String
}


func sendPostRequest(friendName: String, completion: @escaping([MyResponse]?) -> Void){
    print("リクエスト送信")
    guard let url = URL(string: "http://192.168.86.220:3000/searchFriends")else{
        completion(nil)
        return}
    
    let requestData = MyRequest(friendName: friendName)
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
        
        if let httpResponse = response as? HTTPURLResponse{
            print("Status code: \(httpResponse.statusCode)")
        }
        
        if let data = data{
            do{
                let responseData = try JSONDecoder().decode([MyResponse].self, from: data)
                print("Response: \(responseData)")
                completion(responseData)
            }catch{
                print("Error decoding response: \(error)")
                completion(nil)
            }
        }
    }.resume()
}
