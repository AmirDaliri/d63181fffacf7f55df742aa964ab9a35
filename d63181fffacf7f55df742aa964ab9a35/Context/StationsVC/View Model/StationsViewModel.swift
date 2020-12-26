//
//  StationsViewModel.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import Foundation
import UIKit

class StationsViewModel: BaseVM {
    
    private var responseModel: Stations
    private var backupResponseModel = Stations()

    init(model: Stations = Stations()) {
        self.responseModel = model
    }
    
    func getStations() {
        setState(.loading)
        Spinner.start()
        StationsRequest.shared.getStationsList { (response, err) in
            DispatchQueue.main.async {
                Spinner.stop()
                guard let model = response else {
                    self.handlePopup(error: err)
                    self.setState(.error(err))
                    return
                }
                self.responseModel = model
                self.backupResponseModel = model
                self.setState(.success)
            }
        }
    }
    
    var numberOfRows: Int {
        return responseModel.count
    }
    
    var stationList: [Station] {
        return self.responseModel
    }
    
    func stationAtIndex(_ index: Int) -> Station {
        return responseModel[index]
    }
    
    func createStationsCollectionCellViewModel(_ index: Int) -> StationsCollectionCellViewModel {
        return StationsCollectionCellViewModel(station: stationAtIndex(index))
    }
    
    var isEmpty: Bool {
        return !(responseModel.count > 0)
    }
    
    func filterWithName(_ name: String?, _ completion: @escaping () -> Void) {
        if let txt = name, txt != "", txt.count > 2 {
            let filter =  responseModel.filter( { $0.name!.lowercased().contains(txt.lowercased())})
            responseModel = filter
            completion()
        }
    }
    
    func resetFilter(_ completion: @escaping () -> Void) {
        responseModel = backupResponseModel
        completion()
    }
}
