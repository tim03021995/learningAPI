//
//  RegisterViewController.swift
//  learningAPI
//
//  Created by Alvin Tseng on 2020/8/25.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, TakeRegisterDataDelegate {
    func getRegisterData(registerAccount:RegisterAccount) {
        API.register(registerAccount: registerAccount) { (result) in
            switch result{
                
            case .success(_):
                self.alert(alertType: .succes, message: "註冊成功", reason: nil) {
                    //123
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let registerView = RegisterView()
        registerView.delegate = self
        self.view = registerView
    }
    @objc func pushView(){
        let animate = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.view.center = CGPoint(x: ScreenSize.centerX.value, y: ScreenSize.centerY.value * 0.5)
        }
        animate.startAnimation()
    }

}
