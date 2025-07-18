//
//  getFaculties.swift
//  days
//
//  Created by 長山瑞 on 2024/10/08.
//

import Foundation

struct placesResponse: Codable{
    var placeName: String
}

func getPlaces(completion: @escaping([placesResponse]?) -> Void){
    print("キャンパス取得")
    
    guard let url = URL(string: "http://192.168.86.220:3000/getPlaces") else{
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
                let responseData = try JSONDecoder().decode([placesResponse].self, from: data)
                print("Response: \(responseData)")
                completion(responseData)
            }catch{
                print("Error encording response: \(error)")
                completion(nil)
            }
        }
    }.resume()
}
