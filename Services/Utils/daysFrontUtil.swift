//
//  Main.swift
//  days
//
//  Created by 長山瑞 on 2024/12/19.
//

import Foundation

struct APIRequest{
    static func getRequest<T: Decodable>(endPoint: String, queryItems: [URLQueryItem]? = nil, completion: @escaping(Result<T, Error>) -> Void){
        var components = URLComponents(string: "http://192.168.86.79:3000" + endPoint)
        components?.queryItems = queryItems
        
        guard let url = components?.url else{
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error{
                completion(.failure(error))
                return
            }
            
            if let data = data{
                
                if let responseString = String(data: data, encoding: .utf8) {
                }
                
                do{
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedData = try decoder.decode(T.self, from: data)
                    completion(.success(decodedData))
                }catch{
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    static func getRequestAsync<T: Decodable>(
        endPoint: String,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> T {
        
        var components = URLComponents(
            string: Config.baseURL + endPoint
        )
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw NSError(
                domain: "",
                code: httpResponse.statusCode,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Server Error: \(httpResponse.statusCode)"
                ]
            )
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(T.self, from: data)
    }
    
    static func postRequest<T: Decodable>(endPoint: String, body: Data? = nil, completion: @escaping(Result<T, Error>) -> Void){
        var components = URLComponents(string: "http://192.168.86.79:3000" + endPoint)
        
        guard let url = components?.url else{
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = body
        }
        
        URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error{
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            if let responseString = String(data: data, encoding: .utf8) {
            }
            
            do{
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            }catch{
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func postRequestVoid(endPoint: String, body: Data?, completion: @escaping (Result<Void, Error>) -> Void) {
        var request = URLRequest(url: URL(string: "http://192.168.86.79:3000" + endPoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }.resume()
    }
    
    static func uploadMultipart<T: Decodable>(
        endPoint: String,
        body: Data,
        boundary: String,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var components = URLComponents(string: "http://192.168.86.79:3000" + endPoint)
        
        guard let url = components?.url else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

public func timeAgoWithDateFormat(from dateString: String) -> String {
    // DateFormatterで文字列をDate型に変換
    let formatter = ISO8601DateFormatter()
    guard let date = formatter.date(from: dateString) else { return "" }
    
    // 現在の日時を取得
    let now = Date()
    
    // Calendarを使って時間差を計算
    let calendar = Calendar.current
    let components = calendar.dateComponents([.second, .minute, .hour, .day], from: date, to: now)
    
    // 差に応じて適切な形式で表示
    if let years = components.year, years > 0 {
        return "\(years)年前"
    } else if let months = components.month, months > 0 {
        return "\(months)か月前"
    } else if let days = components.day, days >= 7 {
        // 7日以上経過していたら日付表示
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: date)
    } else if let days = components.day, days > 0 {
        return "\(days)日前"
    } else if let hours = components.hour, hours > 0 {
        return "\(hours)時間前"
    } else if let minutes = components.minute, minutes > 0 {
        return "\(minutes)分前"
    } else if let seconds = components.second, seconds > 0 {
        return "\(seconds)秒前"
    } else {
        return "今"
    }
}

