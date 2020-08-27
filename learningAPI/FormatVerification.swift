//
//  FormatVerification.swift
//  learningAPI
//
//  Created by Alvin Tseng on 2020/8/26.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import Foundation
class FormatVerification{
    class func verifyEmail(_ email:String) -> VerifyResult {
        guard email.count != 0 else {
            return .empty
        }
        guard email.count <= 16 else {
            return .long
        }
        return .ok
    }

    /// 驗證密碼
    class func verifyPassword(_ password:String) -> VerifyResult {
        guard password.count != 0 else {
            return .empty
        }
        guard password.count >= 8 else {
            return .less
        }
        guard Validate.passWord(password).isRight else {
            return .failed(message: "characters and only 0-9,a-z,A-Z")
        }
        return .ok
    }
    enum Validate {
        ///需要拓展可以添加相應block以及相應狀態,類似身份證等等
        case passWord(_: String)
        case email(_: String)

        var isRight: Bool {
            ///正則表達式字符串
            var predicateStr:String!
            ///需要驗證的字符串
            var currObject:String!
            switch self {
            case let .passWord(str):
                predicateStr = "^[A-Za-z0-9]+$"
                currObject = str
            case let .email(str):
                predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{1,16})$"
                currObject = str
            }
            let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
            return predicate.evaluate(with: currObject)
        }
    }
    

}
enum VerifyResult {
    case ok     ///正確
    case empty  ///爲空
    case less
    case long
    case failed(message: String)  ///錯誤,返回錯誤原因
}
