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
        self.present(controller, animated: true, completion: nil)
    }
    func showListViewController(){
        let vc = ListViewController()
        show(vc, sender: nil)
    }
    enum AlertType{
        case succes,failure,error
    }
}
