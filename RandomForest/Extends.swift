//
//  Created by DaRk-_-D0G on 13/04/2015.
//  Copyright (c) 2015 DaRk-_-D0G. All rights reserved.
//  Yannickstephan.com
//  redwolfstudio.fr

import Foundation
import CoreGraphics
import Darwin

public extension Int {
    /// Returns a random Int point number between 0 and Int.max.
    public static var random:Int {
        get {
            return Int(arc4random())
        }
    }
    /**
     Random integer between 0 and n-1.
     
     - parameter n: Int
     
     - returns: Int
     */
    public static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    /**
     Random integer between min and max
     
     - parameter min: Int
     - parameter max: Int
     
     - returns: Int
     */
    public static func random(min: Int, max: Int) -> Int {
        //return Int.random(max - min + 1) + min
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
}

public extension Double {
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random:Double {
        get {
            return Double(arc4random()) / 0xFFFFFFFF
        }
    }
    /**
     Create a random number Double
     
     - parameter min: Double
     - parameter max: Double
     
     - returns: Double
     */
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}

public extension Float {
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random:Float {
        get {
            return Float(arc4random()) / 0xFFFFFFFF
        }
    }
    /**
     Create a random num Float
     
     - parameter min: Float
     - parameter max: Float
     
     - returns: Float
     */
    public static func random(min min: Float, max max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}

public extension CGFloat {
    /// Randomly returns either 1.0 or -1.0.
    public static var randomSign:CGFloat {
        get {
            return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
        }
    }
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random:CGFloat {
        get {
            return CGFloat(Float.random)
        }
    }
    /**
     Create a random num CGFloat
     
     - parameter min: CGFloat
     - parameter max: CGFloat
     
     - returns: CGFloat random number
     */
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random * (max - min) + min
    }
}

infix operator ** { associativity left precedence 170 }
public func ** (num: Double, power: Double) -> Double {
    if (power == 2.0) {
        return num * num
    }
    return pow(num, power)
}

public extension Array {
    public mutating func getRandomSubarray(withSize size: Int) -> Array<Element> {
        var currentCount = self.count
        var updatesLog: [(first: Int, second: Int)] = []
        var randomSubarray: Array<Element> = []
        while currentCount != self.count - size {
            let i = Int.random(min: 0, max: currentCount - 1)
            randomSubarray.append(self[i])
            updatesLog.append((first: i, second: currentCount - 1))
            (self[i], self[currentCount - 1]) = (self[currentCount - 1], self[i])
            currentCount -= 1
        }
        updatesLog.reverse()
        for update in updatesLog {
            (self[update.first], self[update.second]) = (self[update.second], self[update.first])
        }
        return randomSubarray
    }
}
