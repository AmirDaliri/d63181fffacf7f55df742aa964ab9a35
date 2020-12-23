//
//  Disposable.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import Foundation

public typealias Disposal = [Disposable]

public final class Disposable {
    
    private let dispose: () -> Void
    
    init(_ dispose: @escaping () -> Void) {
        self.dispose = dispose
    }
    
    deinit {
        dispose()
    }
    
    public func add(to disposal: inout Disposal) {
        disposal.append(self)
    }
}
