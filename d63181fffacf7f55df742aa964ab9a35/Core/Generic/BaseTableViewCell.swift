//
//  BaseTableViewCell.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//

import UIKit

class BaseTableViewCell: UITableViewCell, UITableViewCellLoading {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
}

// MARK:- SetupFunctions
extension BaseTableViewCell : SetupFunctions {
    func setupView() {}
}

protocol UITableViewCellLoading {
}

extension UITableViewCellLoading where Self: BaseTableViewCell {
    static func loadFromNib() -> Self {
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        return (nib.instantiate(withOwner: self, options: nil).first as? Self)!
    }
}

extension UITableViewCell: Reusable { }

extension UITableView {
    func register<T: UITableViewCell>(cellClass: T.Type = T.self) {
        let bundle = Bundle(for: cellClass.self)
        if bundle.path(forResource: cellClass.reuseIdentifier, ofType: "nib") != nil {
            let nib = UINib(nibName: cellClass.reuseIdentifier, bundle: bundle)
            register(nib, forCellReuseIdentifier: cellClass.reuseIdentifier)
        } else {
            register(cellClass.self, forCellReuseIdentifier: cellClass.reuseIdentifier)
        }
    }
}
