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
        DispatchQueue.main.async {
//            Coordinator.shared.removeControllersInNavigation([ControllerKeys.splash.rawValue, ControllerKeys.main.rawValue, ControllerKeys.stations.rawValue, ControllerKeys.faves.rawValue])
            delay(1) {
                Coordinator.shared.removeControllersInNavigation([ControllerKeys.main.rawValue])
                Coordinator.shared.requestNavigation(.main)
//                Coordinator.shared.requestPresent(.main)
            }
                        
//            Coordinator.shared.requestPresent(.main)
//            NavigationProcessHelper.shared.handleFlow(model: .home, presentationType: .present)
//            Coordinator.shared.removeControllersInNavigation(["splash"])
//            Coordinator.shared.requestPresent(.main)
//            Coordinator.shared.requestNavigation(.main)
//            Coordinator.shared.requestNavigation(.main)
        }
/*
        guard Network.reachability.isReachable else {
//            self.exitAppAlert()
            return
        }
//        runActivityIndicator()
        StationsRequest.shared.getStationsList { (response, err) in
            guard !(response?.isEmpty ?? false) else {
                return
            }
            print(response as Any)
        }
*/
    }

}
