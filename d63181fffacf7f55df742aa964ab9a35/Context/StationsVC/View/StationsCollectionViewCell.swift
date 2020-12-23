//
//  StationsCollectionViewCell.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import UIKit

class StationsCollectionViewCell: BaseCollectionViewCell {

    //MARK: - IBOutlets
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.setshadowRadiusView(radius: 12, shadowRadiuss: 1, shadowheight: 5, shadowOpacity: 1, shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.08))
        }
    }
    
    // MARK: - Properties
    var stationsCollectionCellViewModel: StationsCollectionCellViewModel = StationsCollectionCellViewModel() {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Private Functions
    private func updateUI() {
    }
}
