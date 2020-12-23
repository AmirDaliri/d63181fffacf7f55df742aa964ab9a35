//
//  BaseView.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import UIKit

protocol UIViewLoading {}

extension UIViewLoading where Self: BaseView {

    static func loadFromNib() -> Self {
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        return (nib.instantiate(withOwner: self, options: nil).first as? Self)!
    }

    func lookForSuperviewOfType<T: UIView>(_ type: T.Type) -> T? {
        var viewOrNil: UIView? = self
        while let view = viewOrNil {
            if let lookForSuperview = view as? T {
                return lookForSuperview
            }
            viewOrNil = view.superview
        }
        return nil
    }
}

class BaseView: UIView, UIViewLoading {
    
    private(set) var stateDeeplink = Observable(false)
    private var disposal: Disposal = Disposal()
    
    func setStateDeeplink(_ state: Bool) {
        self.stateDeeplink.value = state
    }
    
    func configureUI() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInit()
        setupView()
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInit()
        setupView()
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
    }

}
extension BaseView : SetupFunctions {
    
    //MARK: - SetupFunctions
    func setupInit() {
    
    }
    func setupView() {
        setupAddView()
        setupAddConstraint()
        setupStyleView()
    }
    func setupAddView() {
        
    }
    func setupAddConstraint() {
        
    }
    func setupStyleView() {
        
    }
    func setupCollectionView() {
        
    }
    func setupTableView() {
        
    }
}
