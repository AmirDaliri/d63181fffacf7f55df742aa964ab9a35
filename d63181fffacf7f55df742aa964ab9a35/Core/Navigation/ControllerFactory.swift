//
//  ControllerFactory.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//

import UIKit

class ControllerFactory {
    
    static func tabBarController(_ controllerKeys: [ControllerKey], datas: [Any]? = nil) -> UITabBarController {

        let tabBarController: MainTabbarViewController = MainTabbarViewController()

        var viewControllers = [UINavigationController]()

        for controllerKey in controllerKeys {

            let index = controllerKeys.firstIndex(of: controllerKey)
            var data: Any?
            if index! < (datas?.count ?? 0) {
                data = datas?[index!]
            } else {
                data = nil
            }
            if let controller = ControllerFactory.viewController(controllerKey,
                                                                 data: data) {

                let navController = navigationController(controller, popGestureEnabled: false)

                viewControllers.append(navController)
            }
        }

        if viewControllers.count > 0 {
            tabBarController.setViewControllers(viewControllers, animated: false)
            let tabBarTitleOffset = UIOffset(horizontal: 0, vertical: 50)
            for controller in viewControllers {
                controller.tabBarItem.titlePositionAdjustment = tabBarTitleOffset
            }
        }

        return tabBarController
    }
    
    static func navigationController(_ root: UIViewController, popGestureEnabled: Bool = false) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: root)
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.barTintColor = UIColor.white
        navigationController.navigationBar.isOpaque = false
        navigationController.navigationBar.isTranslucent = false
        navigationController.interactivePopGestureRecognizer?.isEnabled = popGestureEnabled
        return navigationController
    }
    
    static func viewController(_ controllerKey: ControllerKey,
                               data: Any? = nil) -> UIViewController? {
        
        // Special Case
        if controllerKey == ControllerKeys.main.rawValue {
            return ControllerFactory.mainController(data)
        }
        
        if let nClass = kControllerMap[controllerKey]?.classType {
            let controller = nClass.init()
            controller.controllerKey = controllerKey
            if let safeData = data {
                controller.data = safeData
            }
            var hideTabBarControl: Bool = false
            for contKey in kControllerTreeKeys where contKey == controllerKey {
                hideTabBarControl = true
            }
            controller.hidesBottomBarWhenPushed = !hideTabBarControl
            
            return controller
        }
        
        return nil
    }
    
    static func mainController(_ data: Any? = nil) -> UITabBarController {
        var dataArray: [Any]?
        if let safeData = data {
            if let dArray = safeData as? [Any] {
                dataArray = dArray
            }
            dataArray = [safeData]
        }
        let tabController = ControllerFactory.tabBarController(kControllerTreeKeys,
                                                               datas: dataArray)
        return tabController
    }
}
