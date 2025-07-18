//
//  getBoards.swift
//  days
//
//  Created by 長山瑞 on 2024/10/22.
//

import Foundation

struct boardResponse: Codable, Identifiable, Hashable{
    let id = UUID()
    var boardId: Int
    var boardName: String
    var creatorId: String
}

func getBoards(completion: @escaping([boardResponse]?) -> Void){
    guard let url = URL(string: "http://192.168.86.220:3000/getBoards")else{
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
            print(data)
            do{
                let responseData = try JSONDecoder().decode([boardResponse].self, from: data)
                print("Response: \(responseData)")
                completion(responseData)
            }catch{
                print("Error encording response: \(error)")
                completion(nil)
            }
        }
    }.resume()
}
