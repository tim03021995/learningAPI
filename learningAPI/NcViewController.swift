//
//  NcViewController.swift
//  learningAPI
//
//  Created by Alvin Tseng on 2020/8/24.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import UIKit

class NcViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage()
        navigationBar.setBackgroundImage(image, for: .default)
        navigationBar.tintColor = .white
        //navigationBar.backItem
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
