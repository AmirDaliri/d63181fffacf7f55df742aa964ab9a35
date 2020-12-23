//
//  SplashViewController.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//

import UIKit

class SplashViewController: BaseVC {
    
    // MARK: - Lifecycle Methods
    private var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        isNavigationBarHidden = true
        
        delay(1) {
            Coordinator.shared.removeControllersInNavigation([ControllerKeys.main.rawValue])
            Coordinator.shared.requestNavigation(.main)
        }
    }
}
