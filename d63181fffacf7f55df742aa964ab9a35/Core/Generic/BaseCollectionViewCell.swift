//
//  BaseCollectionViewCell.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, UICollectionViewCellLoading {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureUI() {
        backgroundColor = .clear
    }
    
}

// MARK:- SetupFunctions
extension BaseCollectionViewCell : SetupFunctions {
    func setupView() {}
}

protocol UICollectionViewCellLoading {
}

extension UICollectionViewCellLoading where Self: BaseCollectionViewCell {
    static func loadFromNib() -> Self {
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        return (nib.instantiate(withOwner: self, options: nil).first as? Self)!
    }
}

extension UICollectionViewCell: Reusable { }

extension UICollectionView {
    func register<T: UICollectionViewCell>(cellClass: T.Type = T.self) {
        let bundle = Bundle(for: cellClass.self)
        if bundle.path(forResource: cellClass.reuseIdentifier, ofType: "nib") != nil {
            let nib = UINib(nibName: cellClass.reuseIdentifier, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
        } else {
            register(cellClass.self, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
        }
    }
}

@objc protocol SetupFunctions : NSObjectProtocol {
    @objc optional func setupView()
}

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
