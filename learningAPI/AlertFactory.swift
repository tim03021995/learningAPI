//
//  MakeAlert.swift
//  learningAPI
//
//  Created by Alvin Tseng on 2020/8/26.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import UIKit

class AlertFactory{
    static func getAlertController(alertType:AlertType,message: String,reason:(String)?,action:(()->Void)?) -> UIAlertController{
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
        }
        
        let controller = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok", style: .default) { (make) in
            if let action = action{
                action()
            }
        }
        controller.addAction(OKAction)
        return controller
    }
    enum AlertType{
        case succes,failure,error
    }
//    var alertType:AlertType
//    var alertMessage:String?
//    init(alertType:AlertType,message:String) {
//        self .alertType = alertType
//        self .alertMessage = message
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//   func loginAlert(loginStatus:LoginStatus,message:String){
//        let controller = UIAlertController()
//        switch loginStatus {
//        case .succes:
//            controller.title = "Login Succes"
//            let okAction = UIAlertAction(title: "OK", style: .default) { (make) in
//    //            self.showListViewController()
//            }
//            controller.addAction(okAction)
//        case .failure:
//            controller.title = "Error"
//            controller.message = message
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            controller.addAction(okAction)
//        }
//    }
}
//enum AlertType{
//    case succes,failure,error
//}
