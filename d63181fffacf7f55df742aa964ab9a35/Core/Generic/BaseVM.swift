//
//  BaseVM.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//

import Foundation

class BaseVM {
    private(set) var state = Observable(State.unknown)

    func setState(_ state: State) {
        self.state.value = state
    }
    
    func handlePopup(error: String?) {
        if let err = error {
            self.setState(.error(err))
        } else {
            self.setState(.error(nil))
        }
    }
}
