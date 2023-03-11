//
//  DataManager.swift
//  VERODigitalSolutions-iOSTask
//
//  Created by Mehmet Ali Demir on 2.03.2023.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    func fetchToken(completionHandler: @escaping (Result<TokenModelResponse, Error>) -> Void) {
        guard let url = URL(string: "https://api.baubuddy.de/index.php/login") else { return }
        
        var request = URLRequest(url: url)
        
        request.addValue("Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let parameters = [
            "username": "365",
            "password": "1"
        ] as [String : Any]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = postData as Data
        } catch {
            print("decode error")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completionHandler(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(TokenModelResponse.self, from: data)
                completionHandler(.success(decodedData))
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }

    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        fetchToken { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let tokenModel):
                guard let url = URL(string: "https://api.baubuddy.de/dev/index.php/v1/tasks/select") else {
                    return
                }
                
                var request = URLRequest(url: url)
                
                request.addValue("Bearer \(tokenModel.oauth.access_token)", forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "GET"
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard let data = data else {
                        completion(.failure(error!))
                        return
                    }
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode([Task].self, from: data)
                        print(decodedData)
                        completion(.success(decodedData))
                    } catch {
                        print(error)
                    }
                    
                }
                task.resume()
            }
        }
    }
    
}
