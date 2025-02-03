//
//  resisterLecture.swift
//  days
//
//  Created by 長山瑞 on 2024/10/15.
//

import Foundation

struct resisterRequest: Codable{
    var userId: String
    var lectureId: Int
}

struct resisterResponse: Codable{
    var resisterResponse: String
}

func resisterLecture(userId: String, lectureId: Int, completion: @escaping(String?) -> Void){
    
    print("登録開始")
    
    guard let url = URL(string: "http://localhost:3000/resisterLecture")else{
        completion(nil)
        return
    }
    
    var request = URLRequest(url: url)
    var requestData = resisterRequest(userId: userId, lectureId: lectureId)
    
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
        
        if let httpResponse = response as? HTTPURLResponse{
            print("StatusCode: \(httpResponse.statusCode)")
        }
        
        if let data = data{
            do{
                var responseData = try JSONDecoder().decode(resisterResponse.self, from: data)
                print("Response: \(responseData)")
                completion(responseData.resisterResponse)
            }catch{
                print("Decoding error: \(error)")
                completion(nil)
                return
            }
        }
    }.resume()
    
}
