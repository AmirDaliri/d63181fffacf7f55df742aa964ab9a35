//
//  BaseVC.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//

import UIKit
import CoreData

enum NavigationBarButtonType: Int {
    case favorites = 1
    case favorite = 2
    case unFavorite = 3
}

class BaseVC: UIViewController {
            
    // MARK: Preferred Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: Preferred View Controller Styles
    var isNavigationBarHidden: Bool = false {
        didSet {
            configureNavigationBar()
        }
    }
    
    var pageTitle: String? {
        didSet {
            self.title = self.pageTitle
        }
    }
    
    // MARK: Base Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
        
    func configureUI() {
        view.clipsToBounds = true
        configureNavigationBar()
    }
    
    deinit {
        self.data = nil
    }
    
    // MARK: - Configure NavigationBar
    func configureNavigationBar() {
        if !isNavigationBarHidden {
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.barTintColor = .darkGray
            navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.5254901961, blue: 0, alpha: 1)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
    
    //MARK: - this function configured for use in bindUI error case.
    public func handleAlertView(title: String?, message: String) {
        if let alertTitle = title {
            AlertBuilder().title(alertTitle).message(message)
                .addCancelAction(title: "OK")
            .show(in: self)
        } else {
            AlertBuilder().message(message)
                .addCancelAction(title: "OK")
            .show(in: self)
        }
    }
}
