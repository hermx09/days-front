//
//  searchLecture.swift
//  days
//
//  Created by 長山瑞 on 2024/10/08.
//

import Foundation


struct lectureResponse: Codable, Equatable, Identifiable{
    let id = UUID()
    var faculty: String
    var year: String
    var springFlg: Int
    var autumnFlg: Int
    var day: String
    var period: Int
    var lectureName: String
    var teacherName: String
    var roomNum: String
    var place: String
    var lectureId: Int
}

func searchLecture(faculty: String, year: String, springFlg: Bool, autumnFlg: Bool, day: String, period: Int, lectureName: String, teacherName: String, place: String, completion: @escaping([lectureResponse]?) -> Void){
    print("検索送信")
    var components = URLComponents(string: "http://192.168.86.220:3000/searchLecture")
        
        components?.queryItems = [
            URLQueryItem(name: "faculty", value: faculty),
            URLQueryItem(name: "year", value: year),
            URLQueryItem(name: "springFlg", value: String(springFlg)),
            URLQueryItem(name: "autumnFlg", value: String(autumnFlg)),
            URLQueryItem(name: "day", value: day),
            URLQueryItem(name: "period", value: String(period)),
            URLQueryItem(name: "lectureName", value: lectureName),
            URLQueryItem(name: "teacherName", value: teacherName),
            URLQueryItem(name: "place", value: place)
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
                let responseData = try JSONDecoder().decode([lectureResponse].self, from: data)
                print("Response: \(responseData)")
                completion(responseData)
            }
        }catch{
            print("Error decoding response: \(error)")
            completion(nil)
        }
    }.resume()
    
}
