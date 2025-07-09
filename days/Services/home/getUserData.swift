//
//  getUserData.swift
//  days
//
//  Created by 長山瑞 on 2024/10/21.
//

import Foundation

struct userDataResponse: Codable{
    var userName: String
    var userId: String
    var email: String
    var faculty: String
}

func getUserData(userId: String, completion: @escaping(userDataResponse?) -> Void){
    var components = URLComponents(string: "http://192.168.86.220:3000/getUserData")
        
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
        
        if let httpResponse = response as? HTTPURLResponse{
            print("StatusCode: \(httpResponse.statusCode)")
        }
        
        do{
            if let data = data{
                print("data: \(data)")
                let responseData = try JSONDecoder().decode(userDataResponse.self, from: data)
                print("Response: \(responseData)")
                completion(responseData)
            }
        }catch{
            print("Error decoding response: \(error)")
            completion(nil)
        }
    }.resume()
    
}
