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
    func getAccountData(userName: String, passWord: String) {
        getValue(email: userName, passWord: passWord)
    }

    fileprivate func errorHanlde(_ error: (NetworkError)) {
        switch error {
        case .invalidUrl:
            print(error)
        case .requestFailed(let error):
            print(error)
        case .invalidData:
            print(error)
        case .invalidResponse(let error):
            self.alert(alertType: .error, message: error.message, reason: error.reason, action: nil)
            self.alert(alertType: .error, message: error.message, reason: error.reason) {
                //密碼清空
            }
            print(error)
        case .invalidJSONDecoder:
            print(error)
        case .tokenError:
            print(error)
        case .nilData:
            print(error)
        case .nonHTTPResponse:
            print(error)
        }
    }
    
    func getValue(email:String,passWord:String){
        let account = Account(username: email, password: passWord)
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
        present(vc, animated: true, completion: nil)
    }
}
//enum LoginStatus{
//    case succes,failure
//}

