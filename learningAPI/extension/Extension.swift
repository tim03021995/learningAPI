//
//  Extension.swift
//  learningAPI
//
//  Created by Alvin Tseng on 2020/8/26.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import UIKit

let fullScreenSize = UIScreen.main.bounds.size

enum ScreenSize{
    case centerX,centerY,width,hight
    var value:CGFloat{
        switch self {
        case .centerX:
            return fullScreenSize.width * 0.5
        case .centerY:
            return fullScreenSize.height * 0.5
        case .width:
            return fullScreenSize.width
        case .hight:
            return fullScreenSize.height
        }
    }
}
extension UIViewController{
    func alert(alertType:AlertType,message: String,reason:(String)?,action:(()->Void)?) {
        var title:String
        switch alertType {
        case .succes:
            title = "Login Succes"
            
        case .failure:
            title = "failure"
            
        case .error:
            if let reason = reason{
                title = reason
            }else{
                title = "Error"
            }
        case .wrong:
            if let reason = reason{
                title = reason
            }else{
                title = "Wrong"
            }
        }
        
        let controller = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default) { (make) in
            if let action = action{
                action()
            }
        }
        let newTitle = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30), //your font here
            NSAttributedString.Key.foregroundColor : UIColor.white
        ])
        let newMessage = NSAttributedString(string: message, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), //your font here
            NSAttributedString.Key.foregroundColor : UIColor.white
        ])
        
        okAction.setValue(UIColor.white, forKey: "titleTextColor")
        controller.setValue(newTitle, forKey: "attributedTitle")
        controller.setValue(newMessage, forKey: "attributedMessage")
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
        let subview = (controller.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.layer.cornerRadius = 1
        subview.backgroundColor = .mainColor2
    }
    func showListViewController(){
        let vc = ListViewController()
        show(vc, sender: nil)
    }
    func errorHanlde(_ error: (NetworkError)) {
        switch error {
        case .invalidUrl:
            self.alert(alertType: .error, message: "invalidUrl", reason: nil, action: nil)
        case .requestFailed(let error):
            self.alert(alertType: .error, message: error.localizedDescription, reason: nil, action: nil)
        case .invalidData:
            self.alert(alertType: .error, message: "invalidData", reason: nil, action: nil)
        case .invalidResponse(let error):
            self.alert(alertType: .error, message: error.reason,reason: nil, action: nil)
        case .invalidJSONDecoder:
            self.alert(alertType: .error, message: "invalidJSONDecoder", reason: nil, action: nil)
        case .tokenError:
            self.alert(alertType: .error, message: "tokenError", reason: nil, action: nil)
            
        case .nilData:
            self.alert(alertType: .error, message: "nilData", reason: nil, action: nil)
        case .nonHTTPResponse:
            self.alert(alertType: .error, message: "nonHTTPResponse", reason: nil, action: nil)
        }
    }
    enum AlertType{
        case succes,failure,error,wrong
    }
    func registerFormatVerification(_ registerAccount:RegisterAccount) -> Bool{
        let email = registerAccount.email
        let passWord = registerAccount.passWord
        let rePassWord = registerAccount.rePassword
        let emailVerifyResult = FormatVerification.verifyEmail(email)
        let passWordVerifyResult = FormatVerification.verifyPassword(passWord)
        func rePassWordVerifyResult()->Bool{
            switch passWordVerifyResult {
            case .ok:
                if passWord == rePassWord{
                    return true
                }else{
                    alert(alertType: .failure, message: "password is different.", reason: nil, action: nil)
                    return false
                }
            case .empty:
                alert(alertType: .failure, message: "password can not null.", reason: nil, action: nil)
                return false
            case .less:
                alert(alertType: .failure, message: "password should over 8 characters and only", reason: nil, action: nil)
                return false
            case .long:
                alert(alertType: .failure, message: "password can not over 16 characters", reason: nil, action: nil)
                return false
            case .failed(message: let message):
                alert(alertType: .failure, message: message, reason: nil, action: nil)
                return false
            }
        }
        
        switch  emailVerifyResult{
        case .ok:
            return rePassWordVerifyResult()
        case .empty:
            alert(alertType: .failure, message: "username can not null.", reason: nil, action: nil)
            return false
        case .less:
            alert(alertType: .failure, message: "username can not null.", reason: nil, action: nil)
            return false
        case .long:
            alert(alertType: .failure, message: "username can not over 16 characters", reason: nil, action: nil)
            return false
        case .failed(message: let message):
            alert(alertType: .error, message: message, reason: nil, action: nil)
            return false
        }
    }
    
    
}
extension UIColor{
    static let backgroundColor = #colorLiteral(red: 0.2198180258, green: 0.2119601667, blue: 0.1993695199, alpha: 1)
    static let mainColor = #colorLiteral(red: 0.8108343909, green: 0.6783475234, blue: 0.3883202828, alpha: 1)
    static let mainColor2 = #colorLiteral(red: 0.5186856389, green: 0.4789885879, blue: 0.4369061887, alpha: 1)
    static let textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
}
