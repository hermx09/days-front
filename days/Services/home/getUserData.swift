//
//  getUserData.swift
//  days
//
//  Created by 長山瑞 on 2024/10/21.
//

import Foundation

struct userDataResponse: Codable{
    var id: Int
    var name: String
    var userId: String
    var email: String
    var faculty: Int
}

func getUserData(userId: String, completion: @escaping(User?) -> Void){
    var components = URLComponents(string: "http://192.168.86.79:3000/getUserData")
        
        components?.queryItems = [
            URLQueryItem(name: "userId", value: userId)
        ]
        
        guard let url = components?.url else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    URLSession.shared.dataTask(with: request){data, response, err in
        if let err = err{
            print("Error: \(err)")
            completion(nil)
            return
        }
                
        do{
            if let data = data{
                let responseData = try JSONDecoder().decode(User.self, from: data)
                completion(responseData)
            }
        }catch{
            print("Error decoding response: \(error)")
            completion(nil)
        }
    }.resume()
    
}
