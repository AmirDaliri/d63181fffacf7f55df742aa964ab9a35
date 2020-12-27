//
//  FaveTableViewCellViewModel.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 27.12.2020.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import UIKit

class FaveTableViewCellViewModel: BaseVM {
    private var stationTabel: StationTabel
    
    init(model: StationTabel = StationTabel()) {
        self.stationTabel = model
    }

    var name: String {
        return stationTabel.name ?? ""
    }
    
    var eus: String {
        return "\(stationTabel.capacity)/\(stationTabel.need)"
    }
}
