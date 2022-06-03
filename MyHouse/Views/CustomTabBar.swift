//
//  CustomTabBar.swift
//  MyHouse
//
//  Created by Матвей on 31.05.2022.
//

import UIKit

class CustomTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        tabBar.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: tabBar.frame.height - 30)
        tabBar.barTintColor = UIColor(named: "AccentColor")

        super.viewDidLayoutSubviews()
    }
    


}
