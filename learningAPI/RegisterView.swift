//
//  RegisterUIView.swift
//  learningAPI
//
//  Created by Alvin Tseng on 2020/8/25.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import UIKit

class RegisterView: UIView {
    var delegate:TakeRegisterDataDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        add()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var glassView : UIView = {
        var uiView = UIView (frame: CGRect(x: 30, y: 30, width: ScreenSize.width.value * 0.9, height: ScreenSize.hight.value * 0.9))
        uiView.center = CGPoint(x: ScreenSize.centerX.value, y: ScreenSize.centerY.value)
        uiView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        uiView.layer.cornerRadius = 15
        return uiView
    }()
    var backgroundImage : UIImageView = {
        var uiImage = #imageLiteral(resourceName: "stack-of-paper-1058406.png")
        var imageView = UIImageView(image: uiImage, highlightedImage: nil)
        imageView.frame = CGRect(x: 0, y: 0, width: ScreenSize.width.value, height: ScreenSize.hight.value)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    var helloLabel:UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        label.center = CGPoint(x: ScreenSize.centerX.value, y: ScreenSize.centerY.value * 0.25)
        label.text = "Register"
        label.font = .systemFont(ofSize: 100)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    var emailTextField: UITextField = {
        var textField = UITextField(frame: CGRect(x: 30, y: 25, width: 300, height: 50))
        textField.placeholder = "Email"
        textField.text = "admin"
        textField.center = CGPoint(x: ScreenSize.centerX.value, y: ScreenSize.centerY.value - 100 )
        textField.keyboardType = .emailAddress
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(pushView) , for: UIControl.Event.touchDown)
        return textField
    }()
    var passwordTextField: UITextField = {
        var textField = UITextField(frame: CGRect(x: 30, y: 50, width: 300, height: 50))
        textField.placeholder = "Password"
        textField.text = "00000000"
        textField.center = CGPoint(x: ScreenSize.centerX.value, y: ScreenSize.centerY.value  )
        textField.keyboardType = .emailAddress
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(pushView) , for: UIControl.Event.touchDown)
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    var rePasswordTextField: UITextField = {
        var textField = UITextField(frame: CGRect(x: 30, y: 100, width: 300, height: 50))
        textField.placeholder = "Password"
        textField.text = "00000000"
        textField.center = CGPoint(x: ScreenSize.centerX.value, y: ScreenSize.centerY.value + 100 )
        textField.keyboardType = .emailAddress
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(pushView) , for: UIControl.Event.touchDown)
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    var signInButton : UIButton = {
        var button = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        button.setTitle("Sign in", for: .normal)
        button.titleLabel?.text = "Sign in"
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 20
        button.center = CGPoint(x: ScreenSize.centerX.value, y: ScreenSize.centerY.value + 200)
        button.addTarget(self , action: #selector(singIn), for: UIControl.Event.touchDown)
        return button
    }()
    var backButton : UIButton = {
        var button = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        button.setTitle("Back", for: .normal)
        button.titleLabel?.text = "Back"
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 20
        button.center = CGPoint(x: ScreenSize.centerX.value, y: ScreenSize.centerY.value + 250)
        button.addTarget(self , action: #selector(ViewController.register), for: UIControl.Event.touchDown)
        return button
    }()
    func add(){
        addSubview(backgroundImage)
        //addSubview(glassView)
        addSubview(helloLabel)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(rePasswordTextField)
        addSubview(signInButton)
        addSubview(backButton)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    @objc func pushView(){
        let animate = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.center = CGPoint(x: ScreenSize.centerX.value, y: ScreenSize.centerY.value * 0.5)
        }
        animate.startAnimation()
    }
    @objc func singIn(){
        let registerAccount = RegisterAccount(
            email: emailTextField.text ?? "",
            passWord: passwordTextField.text ?? "",
            rePassword: rePasswordTextField.text ?? "")
        self.delegate?.getRegisterData(registerAccount: registerAccount)
    }

    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
extension RegisterView:UITextFieldDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let animate = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
            self.center = CGPoint(x: ScreenSize.centerX.value, y: ScreenSize.centerY.value )
        }
        animate.startAnimation()
        self.endEditing(true)
    }
}
protocol TakeRegisterDataDelegate{
    func getRegisterData(registerAccount:RegisterAccount)
}
