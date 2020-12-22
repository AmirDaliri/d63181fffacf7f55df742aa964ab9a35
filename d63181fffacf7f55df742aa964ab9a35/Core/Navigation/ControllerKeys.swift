//
//  ControllerKeys.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//

import UIKit

typealias ControllerKey = String

let kControllerMap: [ ControllerKey: (classType: UIViewController.Type, title: String)] =
    [
        ControllerKeys.splash.rawValue: (SplashViewController.self, ""),
        ControllerKeys.main.rawValue: (MainTabbarViewController.self, ""),
//        ControllerKeys.stations.rawValue: (<#vc name#>.self, ""),
//        ControllerKeys.faves.rawValue: (<#vc name#>.self, "")
    ]

enum ControllerKeys: ControllerKey {
    case splash
    case main
    case stations
    case faves
}

var kControllerTree: [ControllerKey: (index: Int, iconName: String)] = [
    ControllerKeys.stations.rawValue: (0, "stations"),
    ControllerKeys.faves.rawValue: (1, "faves")
]

var kControllerTreeKeys: [ControllerKey] {
    return kControllerTree.keys.sorted { kControllerTree[$0]!.index < kControllerTree[$1]!.index }
}

var kControllerTreeCenterItem: ControllerKey {
    return kControllerTree.filter({$0.value.index == 2}).first!.0
}
