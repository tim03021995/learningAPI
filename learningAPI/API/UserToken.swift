//
//  UserToken.swift
//  learningAPI
//
//  Created by Alvin Tseng on 2020/8/17.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import Foundation
class UserToken{
    static let share = UserToken()
    private init(){}
    private(set) var token:String?
    func setToken(token:String){
        self.token = token
    }
    func deinitToken(){
        self.token = ""
    }
}
