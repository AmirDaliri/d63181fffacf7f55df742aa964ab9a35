//
//  StationsViewModel.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import Foundation
import UIKit

protocol StationsVMDelegate: AnyObject {
    func timerUpdated(second: String, timeIsUP: Bool)
}

class StationsViewModel: BaseVM {
    
    private var responseModel: Stations
    private var backupResponseModel = Stations()
    
    weak var delegate: StationsVMDelegate?
    private var timer: Timer?
    private(set) var countdown: Int = 0
    
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
    
    func getUGS(parameter: Int?) -> String {
        if let param = parameter {
            return "UGS: \(param*10000)"
        } else {
            return ""
        }
    }
    
    func getEUS(parameter: Int?) -> String {
        if let param = parameter {
            return "EUS: \(param*20)"
        } else {
            return ""
        }
    }
    
    func getDS(parameter: Int?) -> String {
        if let param = parameter {            
            return "DS: \(param*10000)"
        } else {
            return ""
        }
    }
    
    // MARK: - Timer Method
    func startTimer() {
        countdown = Int(50)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timer?.fire()
    }

    @objc func updateTimer() {
        if countdown > 0 {
            let seconds = String(format: "%02d", (countdown % 60))
            delegate?.timerUpdated(second: "\(seconds)s", timeIsUP: false)
            countdown -= 1
        } else {
            delegate?.timerUpdated(second: "0s", timeIsUP: true)
            invalidateTimer()
        }
    }

    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}
