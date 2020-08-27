//
//  ViewController.swift
//  learningAPI
//
//  Created by Alvin Tseng on 2020/8/17.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import UIKit
class ViewController: UIViewController,TakeDataDelegate{
    
    override func loadView() {
        super .loadView()
        let loginView = LoginView()
        loginView.delegate = self
        self.view = loginView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func getToken(userName: String, passWord: String) {
        let account = Account(username: userName, password: passWord)
        API.login(account: account) { (result) in
            switch result{
            case .success(let data):
                self.alert(alertType: .succes, message: data.message, reason: nil) {
                    self.showListViewController()
                }
                print(UserToken.share.token ?? "")
            case .failure(let error):
                self.errorHanlde(error)
            }
        }
    }

    @objc func register(){
        let vc = RegisterViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}
//enum LoginStatus{
//    case succes,failure
//}

