//
//  Object.swift
//  RandomForest
//
//  Created by Vadim on 06.02.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import Foundation

class Object {
    
    public var dimentionsCount: Int {
        didSet {
            if objectFeatures.count != dimentionsCount {
                objectFeatures = [Double](repeating: 0.0, count: dimentionsCount)
            }
        }
    }
    
    public var objectFeatures: [Double] {
        didSet {
            if objectFeatures.count != dimentionsCount {
                dimentionsCount = objectFeatures.count
            }
        }
    }
    
    init(dimentionsCount dimCnt: Int = 0,
         objectFeatures features: [Double] = [Double]()) {
        dimentionsCount = dimCnt
        objectFeatures = features
    }
    
    func feature(number i: Int) -> Double {
        return objectFeatures[i]
    }
    
}
