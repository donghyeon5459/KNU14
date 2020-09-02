//
//  MainTabBarController.swift
//  AvoidCoronaApp
//
//  Created by 윤영신 on 2020/06/15.
//  Copyright © 2020 Azderica. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "Arial", size: 15)], for: .normal)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
    }
}
