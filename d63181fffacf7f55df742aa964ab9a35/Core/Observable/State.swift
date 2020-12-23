//
//  State.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import Foundation

enum State {
    case unknown, loading, success, error(BackendError?)

    static func == (left: State, right: State) -> Bool {
        switch (left, right) {
        case (.unknown, .unknown):
            return true
        case (.loading, .loading):
            return true
        case (.success, .success):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}

public enum BackendError: Error {
    case noInternet(error: Error) ///Internal errors
    case badAPIRequest(error: Error) ///API errors
    case unauthorized(error: Error) ///Auth errors
    case unknown(error: Error) ///Unknown errors
    case objectSerialization(reason: Error?)
    case finishedList(reason: String)
}
