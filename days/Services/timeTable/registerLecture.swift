//
//  registerLecture.swift
//  days
//
//  Created by 長山瑞 on 2024/10/15.
//

import Foundation

struct registerRequest: Codable{
    var userId: String
    var lectureId: Int
}

struct registerResponse: Codable{
    var registerResponse: String
}

func registerLecture(userId: String, lectureId: Int, completion: @escaping(String?) -> Void){
    
    guard let url = URL(string: "http://192.168.86.79:3000/registerLecture")else{
        completion(nil)
        return
    }
    
    var request = URLRequest(url: url)
    var requestData = registerRequest(userId: userId, lectureId: lectureId)
    
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do{
        var jsonData = try JSONEncoder().encode(requestData)
        request.httpBody = jsonData
    }catch{
        print("Encoding error: \(error)")
        completion(nil)
    }
    
    URLSession.shared.dataTask(with: request){data, response, error in
        if let error = error{
            print("Request error: \(error)")
            completion(nil)
            return
        }            
        
        if let data = data{
            do{
                var responseData = try JSONDecoder().decode(registerResponse.self, from: data)                
                completion(responseData.registerResponse)
            }catch{
                print("Decoding error: \(error)")
                completion(nil)
                return
            }
        }
    }.resume()
    
}
