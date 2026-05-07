//
//  getFaculties.swift
//  days
//
//  Created by 長山瑞 on 2024/10/08.
//

import Foundation

struct facultiesResponse: Codable{
    var facultyName: String
    var fieldType: Int
}

func getFaculties(completion: @escaping([facultiesResponse]?) -> Void){
    
    guard let url = URL(string: "http://192.168.86.79:3000/getFaculties")else{
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
        }
        
        if let data = data{
            do{
                let responseData = try JSONDecoder().decode([facultiesResponse].self, from: data)                
                completion(responseData)
            }catch{
                print("Error encording response: \(error)")
                completion(nil)
            }
        }
    }.resume()
}
