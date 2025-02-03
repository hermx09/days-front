//
//  getBoards.swift
//  days
//
//  Created by 長山瑞 on 2024/10/22.
//

import Foundation

struct postResponse: Codable, Equatable, Identifiable{
    let id = UUID()
    var postId: Int
    var postTitle: String
    var postMessage: String
    var posterId: String
    var favorite: Int
    var boardId: Int
    var createdAt: String
    var isAnonymous: Bool
}

func getPosts(boardId: Int, completion: @escaping([postResponse]?) -> Void){
    
    var components = URLComponents(string: "http://localhost:3000/getPosts")
    components?.queryItems = [
        URLQueryItem(name: "boardId", value: String(boardId))
    ]
    guard let url = components?.url else{
        return completion(nil)
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    URLSession.shared.dataTask(with: request){data, response, err in
        if let err = err{
            print("Error: \(err)")
            completion(nil)
        }
        
        if let response = response as? HTTPURLResponse{
            print("StatusCode: \(response.statusCode)")
        }
        
        if let data = data{
            do{
                let responseData = try JSONDecoder().decode([postResponse].self, from: data)
                print("Response: \(responseData)")
                completion(responseData)
            }catch{
                print("Error decording response: \(error)")
                completion(nil)
            }
        }
    }.resume()
}
