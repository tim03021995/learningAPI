//
//  ListView.swift
//  learningAPI
//
//  Created by Alvin Tseng on 2020/8/26.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import UIKit
protocol ListDataDelegate {
    func reloadList()
    func delectList()
    func editList()
    func createList()
}
class ListView: UIView {
    var list = List(){
        didSet{
            self.listTableView.reloadData()
        }
    }
    var listTableViewIsEditing = false
    var listTableView:UITableView={
        var tableView = UITableView(frame: CGRect(x: 0, y: 150, width: ScreenSize.width.value * 0.9, height: ScreenSize.hight.value * 0.8),style: .grouped)
        tableView.center = CGPoint(x: ScreenSize.centerX.value, y: ScreenSize.centerY.value)
        var headerView:UIView = {
            var view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 100))
            var listTitle:UILabel = {
                var label = UILabel(frame: CGRect(x:20, y: 20, width: tableView.frame.size.width * 0.75, height: 50))
                //                label.center = CGPoint(x: ScreenSize.centerX.value, y: ScreenSize.centerY.value * 0.25)
                label.text = "Reminders"
                label.font = .systemFont(ofSize: 50)
                label.adjustsFontSizeToFitWidth = true
                label.textColor = .white
                return label
            }()
            var editBotton:UIButton = {
                var button = UIButton(frame: CGRect(x: 260, y: 20, width:  tableView.frame.size.width * 0.25, height: 50))
                button.setTitle("EDIT", for: .normal)
                button.titleLabel?.font = .monospacedDigitSystemFont(
                    ofSize: ScreenSize.width.value * 0.04,
                    weight: .thin)
                button.backgroundColor = .mainColor
                button.layer.cornerRadius = 15
                button.addTarget(self, action: #selector(edit), for: .touchDown)
                return button
            }()
            view.addSubview(listTitle)
            view.addSubview(editBotton)
            return view
        }()
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        tableView.allowsMultipleSelection = false
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.indicatorStyle = .white
        tableView.allowsSelectionDuringEditing = true
        tableView.tableHeaderView = headerView
        tableView.layer.cornerRadius = 15
        tableView.backgroundColor = .mainColor2
        
        return tableView
    }()
    var addBotton:UIButton = {
        var button = UIButton(frame: CGRect(
            x: ScreenSize.width.value * 0.8,
            y: ScreenSize.hight.value * 0.8,
            width: 50,
            height: 50))
        //button.setTitle("ADD", for: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
//        button.titleLabel?.font = .monospacedDigitSystemFont(
//            ofSize: ScreenSize.width.value * 0.04,
//            weight: .thin)
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(ListViewController.add), for: .touchDown)
        return button
    }()
    var delegate:ListDataDelegate?
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        addSubview(listTableView)
        addSubview(addBotton)
        setView()
        setListTableView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setView(){
        self.backgroundColor = .backgroundColor
    }
    func addSubview(){
        addSubview(listTableView)
    }
    func setListTableView(){
        listTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
    }
    
    @objc func edit (){
        listTableView.setEditing(!listTableView.isEditing, animated: true)
        if (!listTableView.isEditing) {
            listTableViewIsEditing = true
        } else {
            listTableViewIsEditing = false
        }
    }

    
}
extension ListView:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let item = list[index]
        let name = item
        if editingStyle == .delete {
            ListDataManager.shared.delectList(listElement: item) {
                tableView.beginUpdates()
                 tableView.deleteRows(
                     at: [indexPath], with: .fade)
                 tableView.endUpdates()
                 print("刪除的是 \(name)")
            }
            self.delegate?.reloadList()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "Cell", for: indexPath) as
        UITableViewCell
        let status = list[indexPath.row].status
        cell.backgroundColor = .mainColor2
        cell.tintColor = .textColor
        if let label = cell.textLabel{
            let id = "\(list[indexPath.row].id)"
            print(id)
            let item = list[indexPath.row].item
            let updateTime = list[indexPath.row].updateTime
            let updateUser = list[indexPath.row].updateUser
            label.textColor = .white
            label.text = id + " " + item  + " " + updateTime + " " + updateUser
        }
        if status == "已完成" {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
}



