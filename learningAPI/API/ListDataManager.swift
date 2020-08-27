//
//  ListDataManager.swift
//  learningAPI
//
//  Created by Alvin Tseng on 2020/8/25.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import UIKit
class ListDataManager{
    static let shared = ListDataManager()
    private init(){
    }//只允許自己實體化
    
    #warning("oberServer,   不要存下來")
    private(set) var list = List()
    
    func createList (listElement:ListElement){
        list.append(listElement)
        sortList()
        saveUserDefaults()
    }
    func editList(index:Int,listElement:ListElement){
        list[index] = listElement
        sortList()
        saveUserDefaults()
    }
    func delectList (listElement:ListElement,completionHandler:@escaping()->Void){
        API.deleteList(listElement: listElement) { (result) in
            switch result{
            case .success(_):
                completionHandler()
                print("d")
            case .failure(_):
                print("f")
            }
        }
    }
    
    
    
//    func loadList(){
//        loadUserDefaults()
//    }
    private func sortList(){
        list.sort { (listElement1, listElement2) -> Bool in
            listElement1.updateTime < listElement2.updateTime
        }
    }
    private func saveUserDefaults(){
//        UserDefaults.standard.set(try? PropertyListEncoder().encode(alarmArray), forKey:"alarmArray")
    }
    func loadList(completionHandler:@escaping()->Void){
        API.getList { (result) in
            switch result{
                
            case .success(let data):
                self.list = data
                completionHandler()
            case .failure(let error):
                switch error {
                    
                case .invalidUrl:
                    print("invalidUrl")
                    //self.loginAlert(loginStatus: .failure, message: "invalidUrl")
                case .requestFailed(let message):
                    print(message.localizedDescription)
                    //self.loginAlert(loginStatus: .failure, message: message.localizedDescription)
                case .invalidData:
                    print("invalidUrl")
                    //self.loginAlert(loginStatus: .failure, message: "invalidUrl")
                case .invalidResponse(let message):
                    print(message.reason)
                    //self.loginAlert(loginStatus: .failure, message: message.reason)
                case .invalidJSONDecoder:
                    print("invalidUrl")
                    //self.loginAlert(loginStatus: .failure, message: "invalidUrl")
                case .tokenError:
                    print("invalidUrl")
                    //self.loginAlert(loginStatus: .failure, message: "invalidUrl")
                case .nilData:
                    print("nilData")
                case .nonHTTPResponse:
                    print("nonHTTPResponse")
                }
                print(error)
            }
        }
    }
}
