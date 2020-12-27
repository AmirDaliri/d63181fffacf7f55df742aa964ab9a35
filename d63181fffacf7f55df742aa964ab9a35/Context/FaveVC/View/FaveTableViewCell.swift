//
//  FaveTableViewCell.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 27.12.2020.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import UIKit

class FaveTableViewCell: BaseTableViewCell {

    //MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var eusLabel: UILabel!
    @IBOutlet private weak var faveButton: UIButton!
    
    // MARK: - Properties
    var faveTableViewCellViewModel: FaveTableViewCellViewModel? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Private Functions
    private func updateUI() {
        nameLabel.text = faveTableViewCellViewModel?.name
        eusLabel.text = faveTableViewCellViewModel?.eus
    }
    
    // MARK: - IBAction
    @IBAction func faveButtonTapped(_ sender: UIButton) {
        faveTableViewCellViewModel?.removeItem()
    }
}
