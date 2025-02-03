//
//  getUserLectures.swift
//  days
//
//  Created by 長山瑞 on 2024/10/17.
//

import Foundation

struct requestUserLectures: Codable{
    var userId: String
}

struct responseUserLectures: Codable, Equatable, Identifiable{
    let id = UUID()
    var lectureName: String
    var teacherName: String
    var roomNum: String
    var lectureTime: Int
    var day: Int
}

func getUserLectures(userId: String, completion: @escaping([responseUserLectures]?) -> Void){
    
    var components = URLComponents(string: "http://localhost:3000/getUserLectures")
        
        components?.queryItems = [
            URLQueryItem(name: "userId", value: userId)
        ]
        
        // URLを生成
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
                let responseData = try JSONDecoder().decode([responseUserLectures].self, from: data)
                print("Response: \(responseData)")
                completion(responseData)
            }
        }catch{
            print("Error decoding response: \(error)")
            completion(nil)
        }
    }.resume()
    
}
