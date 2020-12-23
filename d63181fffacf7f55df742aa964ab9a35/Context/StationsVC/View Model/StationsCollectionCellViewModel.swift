//
//  StationsCollectionCellViewModel.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import UIKit

class StationsCollectionCellViewModel: BaseVM {
    
    private var station: Station
    
    init(station: Station = Station()) {
        self.station = station
    }
    
    var name: String {
        return station.name ?? ""
    }
    
    var coordinateX: Double {
        return station.coordinateX ?? 0.0
    }
    
    var coordinateY: Double {
        return station.coordinateY ?? 0.0
    }
    
    var capacity: Int {
        return station.capacity ?? 0
    }
    
    var stock: Int {
        return station.stock ?? 0
    }
    
    var need: Int {
        return station.need ?? 0
    }
}
