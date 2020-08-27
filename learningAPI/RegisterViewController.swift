//
//  RegisterViewController.swift
//  learningAPI
//
//  Created by Alvin Tseng on 2020/8/25.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, TakeRegisterDataDelegate {
    var delegate:TakeDataDelegate?
    fileprivate func toRegisterAccount(_ registerAccount: RegisterAccount) {
        API.register(registerAccount: registerAccount) { (result) in
            switch result{
                
            case .success(let data):
                self.alert(alertType: .succes, message: data.message, reason: nil) {
                    self.delegate?.getToken(
                        userName: registerAccount.email,
                        passWord: registerAccount.passWord)
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                self.errorHanlde(error)
            }
        }
    }
    
    func getRegisterData(registerAccount:RegisterAccount) {
        if registerFormatVerification(registerAccount){
            toRegisterAccount(registerAccount)
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
