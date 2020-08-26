//
//  ListViewController.swift
//  learningAPI
//
//  Created by Alvin Tseng on 2020/8/18.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    var listTableViewIsEditing = false
    var listTableView:UITableView={
        var tableView = UITableView(frame: CGRect(x: 0, y: 150, width: ScreenSize.width.value * 0.9, height: ScreenSize.hight.value * 0.8),style: .grouped)
        tableView.center = CGPoint(x: ScreenSize.centerX.value, y: ScreenSize.centerY.value)
        var headerView:UIView = {
            var view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 100))
            var listTitle:UILabel = {
                var label = UILabel(frame: CGRect(x:20, y: 20, width: 200, height: 50))
                //                label.center = CGPoint(x: ScreenSize.centerX.value, y: ScreenSize.centerY.value * 0.25)
                label.text = "Reminders"
                label.font = .systemFont(ofSize: 50)
                label.adjustsFontSizeToFitWidth = true
                label.textColor = .white
                return label
            }()
            var listBotton:UIButton = {
                var button = UIButton(frame: CGRect(x: 250, y: 20, width: 100, height: 50))
                button.setTitle("EDIT", for: .normal)
                button.titleLabel?.font = .monospacedDigitSystemFont(
                    ofSize: ScreenSize.width.value * 0.04,
                    weight: .thin)
                button.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                button.layer.cornerRadius = 15
                button.addTarget(self, action: #selector(edit), for: .touchDown)
                return button
            }()
            view.addSubview(listTitle)
            view.addSubview(listBotton)
            return view
        }()
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        tableView.allowsMultipleSelection = false
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = true
        tableView.indicatorStyle = .white
        tableView.allowsSelectionDuringEditing = true
        tableView.tableHeaderView = headerView
        tableView.layer.cornerRadius = 15
        tableView.backgroundColor = #colorLiteral(red: 0.1476048231, green: 0.1828556955, blue: 0.2575686276, alpha: 1)
        return tableView
    }()
    override func loadView() {
        super.loadView()
        ListDataManager.shared.loadList {
            self.listTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.backgroundColor = #colorLiteral(red: 0.002460680204, green: 0.0409046784, blue: 0.1240068153, alpha: 1)
        addSubview()
    }
    func addSubview(){
        self.view.addSubview(listTableView)
    }
    @objc func edit (){
        listTableView.setEditing(!listTableView.isEditing, animated: true)
        if (!listTableView.isEditing) {
            self.listTableViewIsEditing = true
        } else {
            self.listTableViewIsEditing = false
        }
    }
}
extension ListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ListDataManager.shared.list.count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let item = ListDataManager.shared.list[index]
        let name = item
        if editingStyle == .delete {
            ListDataManager.shared.delectList(listElement: item) {
                tableView.beginUpdates()
                 tableView.deleteRows(
                     at: [indexPath], with: .fade)
                 tableView.endUpdates()
                 print("刪除的是 \(name)")
            }
            ListDataManager.shared.loadList {
                self.listTableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "Cell", for: indexPath) as
        UITableViewCell
        let status = ListDataManager.shared.list[indexPath.row].status
        cell.backgroundColor = #colorLiteral(red: 0.1476048231, green: 0.1828556955, blue: 0.2575686276, alpha: 1)
        if let label = cell.textLabel{
            let id = "\(ListDataManager.shared.list[indexPath.row].id)"
            print(id)
            let item = ListDataManager.shared.list[indexPath.row].item
            let updateTime = ListDataManager.shared.list[indexPath.row].updateTime
            let updateUser = ListDataManager.shared.list[indexPath.row].updateUser
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
