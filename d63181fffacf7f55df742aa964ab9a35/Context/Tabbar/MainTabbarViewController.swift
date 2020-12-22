//
//  MainTabbarViewController.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//

import UIKit

class MainTabbarViewController: UITabBarController {

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
    }
    
    var selectedItemIndex: Int = 2 {
        didSet {
            selectedIndex = selectedItemIndex
        }
    }
}
