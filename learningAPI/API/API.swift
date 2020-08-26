//
//  API.swift
//  learningAPI
//
//  Created by Alvin Tseng on 2020/8/17.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import Foundation
class API{
    static func login(account:Account,completionHandler: @escaping (Result<Message,NetworkError>) -> Void){
        let parameters = "{\n    \"username\": \"\(account.username)\",\n    \"password\":\"\(account.password)\"\n}"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "http://35.185.131.56:8000/api/userToken")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(.failure(.requestFailed(error)))
                }
                guard let data = data else {
                    completionHandler(.failure(.nilData))
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(.failure(.nonHTTPResponse))
                    return
                }
                switch response.statusCode
                {
                case 200:
                    decodeData(data: data, complitionHandler: completionHandler)
                    if let token = response.allHeaderFields[AnyHashable("userToken")] as? String{
                        UserToken.share.setToken(token: token)
                    }
                default:
                    decodeData(data: data) { (res: Result<ErrorMessage, NetworkError>) in
                        switch res {
                        case .success(let data):
                            completionHandler(.failure(.invalidResponse(data)))
                        case .failure( _):
                            completionHandler(.failure(.invalidJSONDecoder))
                        }
                    }
                }
            }
        }
        task.resume()
    }
    static func register(registerAccount:RegisterAccount,completionHandler: @escaping (Result<Message,NetworkError>) -> Void){
        let parameters = "{\n    \"username\": \"\(registerAccount.email)\",\n    \"password\":\"\(registerAccount.passWord)\",    \n    \"checkpassword\":\"\(registerAccount.rePassword)\"\n}"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "http://35.185.131.56:8000/api/register")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(.failure(.requestFailed(error)))
                }
                guard let data = data else {
                    completionHandler(.failure(.nilData))
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(.failure(.nonHTTPResponse))
                    return
                }
                switch response.statusCode
                {
                case 200:
                    decodeData(data: data, complitionHandler: completionHandler)
                default:
                    decodeData(data: data) { (res: Result<ErrorMessage, NetworkError>) in
                        switch res {
                        case .success(let data):
                            completionHandler(.failure(.invalidResponse(data)))
                        case .failure:
                            completionHandler(.failure(.invalidJSONDecoder))
                        }
                    }
                }
            }
        }
        task.resume()
    }
    static func getList(completionHandler: @escaping (Result<List,NetworkError>) -> Void){
        
        var request = URLRequest(url: URL(string: "http://35.185.131.56:8000/api/task")!,timeoutInterval: Double.infinity)
        if let token = UserToken.share.token {
            request.addValue(token, forHTTPHeaderField: "userToken")
        }else{
            completionHandler(.failure(.tokenError))
        }
        request.httpMethod = "GET"
        
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                let httpResponse = response as! HTTPURLResponse
                if let error = error {
                    completionHandler(.failure(.requestFailed(error)))
                }
                if let data = data , httpResponse.statusCode == 200 {
                    //decode JSON
                    decodeData(data: data) { (res: Result<List, NetworkError>) in
                        switch res {
                        case .success(let data):
                            completionHandler(.success(data))
                        case .failure( _):
                            completionHandler(.failure(.invalidJSONDecoder))
                        }
                    }
                    
                }else{
                    if let data = data{
                        //decode JSON
                        decodeData(data: data) { (res: Result<ErrorMessage, NetworkError>) in
                            switch res {
                            case .success(let data):
                                completionHandler(.failure(.invalidResponse(data)))
                            case .failure( _):
                                completionHandler(.failure(.invalidJSONDecoder))
                            }
                        }
                        
                    }else{
                        completionHandler(.failure(.invalidData))
                    }
                }
            }
        }
        task.resume()
    }
    
    static func deleteList(listElement:ListElement,completionHandler: @escaping (Result<Message,NetworkError>) -> Void){
        print(listElement.id)
        var request = URLRequest(url: URL(string: "http://35.185.131.56:8000/api/task/\(listElement.id)")!,timeoutInterval: Double.infinity)
        print(request)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let token = UserToken.share.token {
            request.addValue(token, forHTTPHeaderField: "userToken")
        }else{
            completionHandler(.failure(.tokenError))
        }
        
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                print(String(data: data, encoding: .utf8)!)
                
            }
        }
        task.resume()
    }
    
    private static func decodeData<T:Codable>(data:Data ,complitionHandler: @escaping (Result<T, NetworkError>) -> Void){
        let decoder = JSONDecoder()
        do{
            let data = try decoder.decode(T.self, from: data)
            complitionHandler(.success((data)))
        }catch{
            complitionHandler(.failure(.invalidJSONDecoder))
        }
        
    }
}
struct Account{
    var username : String
    var password : String
}

enum NetworkError: Error {
    case invalidUrl
    case requestFailed(Error)
    case invalidData
    case invalidResponse(ErrorMessage)
    case invalidJSONDecoder
    case tokenError
    case nilData
    case nonHTTPResponse
}

struct Message:Codable{
    var message:String
}
struct ErrorMessage:Codable {
    var message:String
    var reason:String
}
//struct List:Codable{
//    var no:Int
//    var item:String
//    var status:String
//    var updateTime:Data
//    var updateUser:String
//    enum CodingKeys: String, CodingKey{
//        case no,item,status
//        case updateTime = "update_time"
//        case updateUser = "update_user"
//    }
//    /*
//     "no": 3,
//     "item": "00000",
//     "status": "未完成",
//     "update_time": "2020-08-05 12:04:12",
//     "update_user": "gill"
//     */
//}
// MARK: - ListElement
struct ListElement: Codable {
    let id: Int
    let item, status, updateTime, updateUser: String
    
    enum CodingKeys: String, CodingKey {
        case id , item, status
        case updateTime = "update_time"
        case updateUser = "update_user"
    }
}
struct RegisterAccount{
    let email:String
    let passWord:String
    let rePassword:String
}
typealias List = [ListElement]
