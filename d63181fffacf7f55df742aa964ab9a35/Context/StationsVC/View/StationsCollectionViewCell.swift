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
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var eusLabel: UILabel!
    @IBOutlet private weak var dataLabel: UILabel!
    
    // MARK: - Properties
    var stationsCollectionCellViewModel: StationsCollectionCellViewModel = StationsCollectionCellViewModel() {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Private Functions
    private func updateUI() {
        nameLabel.text = stationsCollectionCellViewModel.name
        dataLabel.text = "\(stationsCollectionCellViewModel.stock)/\(stationsCollectionCellViewModel.need)"
    }
    // MARK: - IBAction Method
    
    @IBAction func faveButtonTapped(_ sender: Any) {
        NavigationManager.shared.dismissTopController(.reveal, direction: .fromBottom, data: nil)
    }
    @IBAction func travelButtonTapped(_ sender: Any) {
        NavigationManager.shared.dismissTopController()
    }
}
