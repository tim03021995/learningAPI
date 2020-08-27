//
//  ListViewController.swift
//  learningAPI
//
//  Created by Alvin Tseng on 2020/8/18.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    let listView = ListView()
    var list = List(){
        didSet{
            listView.list = list
            self.view = listView
            #warning("jimmy")
            //self.listView.listTableView.reloadData()
        }
    }
    override func loadView() {
        super.loadView()
        listView.delegate = self
        self.view = listView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    func getData(){
        API.getList { (result) in
            switch result{
            case .success(let data):
                self.list = data
            case .failure(let error):
                self.errorHanlde(error)
            }
        }
    }
    @objc func add (){
        let controller = UIAlertController(title: "ADD", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .destructive, handler: nil )
        
        let okAction = UIAlertAction(title: "ok", style: .default) { (make) in
            //存資料
            if let text = (controller.textFields?[0].text){
                print(text)
                self.addList(item: text)
            }
        }
        let attributedString = NSAttributedString(string: "Create", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30), //your font here
            NSAttributedString.Key.foregroundColor : UIColor.white
        ])
        cancelAction.setValue(UIColor.mainColor, forKey: "titleTextColor")
        okAction.setValue(UIColor.white, forKey: "titleTextColor")
        
        controller.addTextField { (tf) in
            tf.placeholder = "input title"
        }
        controller.setValue(attributedString, forKey: "attributedTitle")
        controller.addAction(cancelAction)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
        let subview = (controller.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.layer.cornerRadius = 1
        subview.backgroundColor = .mainColor2
    }
    func addList(item:String){
        API.createList(item: item) { (result) in
            switch result{
            case .success(let data):
                self.getData()
                self.alert(alertType: .succes, message: data.message, reason: nil, action: nil)
            case .failure(let error):
                self.errorHanlde(error)
            }
        }
    }
    func editList(listElement:ListElement,item:String){
        API.updataList(listElement: listElement, item: item) { (result) in
            switch result{
            case .success(let data):
                self.getData()
                self.alert(alertType: .succes, message: data.message, reason: nil, action: nil)
            case .failure(let error):
                self.errorHanlde(error)
            }
        }
    }
}
extension ListViewController:ListDataDelegate{
    func delectList() {
        <#code#>
    }
    
    func editList() {
        <#code#>
    }
    
    func createList() {
        <#code#>
    }
    
    func reloadList() {
        self.getData()
    }
}
