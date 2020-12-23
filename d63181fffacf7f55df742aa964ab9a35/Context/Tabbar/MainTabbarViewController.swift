//
//  MainTabbarViewController.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//

import UIKit

class MainTabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    static var tabBarHeight: CGFloat = deviceHasTopNotch ? 100.0 : 85.0
    private let buttonWidth = UIScreen.main.bounds.size.width / CGFloat(kControllerTreeKeys.count)
    private var buttons: [UIButton] = []
    
    static var selectedTextColor: UIColor { return .orange }
    static var normalTextColor: UIColor { return UIColor.black}
    static var backgroundColor: UIColor { return .white}
    static var footerLineColor: UIColor { return .black }
    static let selectedTextFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    static let normalTextFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    
    var selectedIndexTitle: String {
        return kControllerTreeKeys[selectedItemIndex]
    }
    
    var selectedItemIndex: Int = 0 {
        didSet {
            selectedIndex = selectedItemIndex
            for button in buttons {
                button.isSelected = button.tag == selectedItemIndex
                button.imageView?.tintColor = button.isSelected ? MainTabbarViewController.selectedTextColor : MainTabbarViewController.normalTextColor
                button.tintColor = .darkGray
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.isOpaque = false
        tabBar.isTranslucent = false
        tabBar.isHidden = false
        tabBar.layer.drawShadow(color: .colorAlpha(color: .rgb(red: 51, green: 51, blue: 67), alpha: 0.12), alpha: 1, x: 0, y: -7, blur: 20, spread: 0)

        
        reloadButtons()
        configureUI()
        delay(0.1) {
            self.selectedItemIndex = 0
        }
    }
    
    func configureUI() {
        tabBar.tintColor = MainTabbarViewController.backgroundColor
        tabBar.barTintColor = MainTabbarViewController.backgroundColor
        view.backgroundColor = MainTabbarViewController.backgroundColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let items = tabBar.items, items.count > 0 {
            for index in 0...items.count-1 {
                let item = items[index]
                item.isAccessibilityElement = false
                item.accessibilityLabel = buttons[index].titleLabel?.text
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
//        navigationController?.navigationBar.isHidden = true
        super.viewDidLayoutSubviews()
        if #available(iOS 13.0, *) {
            var tabFrame = tabBar.frame
            tabFrame.size.height = MainTabbarViewController.tabBarHeight
            tabFrame.origin.y = view.frame.size.height - MainTabbarViewController.tabBarHeight
            tabBar.frame = tabFrame
        }
    }
}

extension MainTabbarViewController {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let didSelectIndex = tabBar.items?.firstIndex(of: item) ?? 0
        selectedItemIndex = didSelectIndex
    }
    
    private func reloadButtons() {
        tabBar.barStyle = .black
        tabBar.tintAdjustmentMode = .normal
        tabBar.isAccessibilityElement = false
        
        if buttons.isEmpty {
            for key in kControllerTreeKeys {
                let tag: Int = kControllerTree[key]!.index
                let button = createButton(key)
                button.translatesAutoresizingMaskIntoConstraints = false
                tabBar.addSubview(button)
                button.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: 10).isActive = true
                button.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor, constant: CGFloat(tag) * buttonWidth).isActive = true
                button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
                if #available(iOS 11.0, *) {
                    button.bottomAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
                }
//                button.isHidden = key == kControllerTreeCenterItem
                buttons.append(button)
            }
        }
    }
    
    private func createButton(_ key: ControllerKey) -> UIButton {
        let tag: Int = kControllerTree[key]!.index
        let iconName: String = kControllerTree[key]!.iconName
        let title: String = kControllerMap[key]!.title
        let selected: Bool = tag == tabBar.items?.firstIndex(of: tabBar.selectedItem!) ?? 0
        let font = MainTabbarViewController.selectedTextFont
        let button = UIButton(frame: CGRect.zero)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        button.tag = tag
        button.isSelected = selected
        button.titleLabel?.font = font
        button.titleLabel?.textColor = selected ? MainTabbarViewController.selectedTextColor : MainTabbarViewController.normalTextColor
        button.setTitleColor(MainTabbarViewController.normalTextColor, for: .normal)
        button.setTitleColor(MainTabbarViewController.selectedTextColor, for: .selected)
        button.setTitle(title, for: .normal)
        let normalAttributes = [
            NSAttributedString.Key.foregroundColor: MainTabbarViewController.normalTextColor,
            NSAttributedString.Key.font: MainTabbarViewController.normalTextFont
        ]
        
        let selectedAttributes = [
            NSAttributedString.Key.foregroundColor: MainTabbarViewController.selectedTextColor,
            NSAttributedString.Key.font: MainTabbarViewController.selectedTextFont
        ]
        let normalAttributed: NSAttributedString = NSAttributedString(string: title, attributes: normalAttributes)
        let selectedAttributed: NSAttributedString = NSAttributedString(string: title, attributes: selectedAttributes)
        
        button.setAttributedTitle(normalAttributed, for: .normal)
        button.setAttributedTitle(selectedAttributed, for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.accessibilityLabel = title
        button.accessibilityHint = ""
        button.isAccessibilityElement = false
        button.setImage(UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        let imageViewSize: CGSize = UIImage(named: iconName)!.size
        let fixedHeight: CGFloat = 44
        let padding: CGFloat = 2
        button.backgroundColor = .clear
        
        let titleSize: CGSize = title.size(withAttributes: [NSAttributedString.Key.font: font])
        button.titleEdgeInsets = UIEdgeInsets(top: fixedHeight + padding, left: -imageViewSize.width, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        return button
    }
    
    @objc private func buttonAction(_ button: UIButton) {
        selectedItemIndex = button.tag
    }
}
/*

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = MainTabbarViewController.tabBarHeight
        return sizeThatFits
    }
}
*/

extension UINavigationBar {

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 120.0)
    }

}
