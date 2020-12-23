//
//  CALayer+Extension.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import UIKit

extension CALayer {
    
    func drawShadow( color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0,  y: CGFloat = 2,blur:CGFloat = 4, spread: CGFloat = 0){
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
            return
        }
        let dx = -spread
        let rect = bounds.insetBy(dx: dx, dy: dx)
        shadowPath = UIBezierPath(rect: rect).cgPath
    }
}
