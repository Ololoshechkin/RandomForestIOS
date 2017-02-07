//
//  JiniIndexCounter.swift
//  RandomForest
//
//  Created by Vadim on 07.02.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import Foundation
import Darwin

class JiniIndexCounter {
    
    class func getJiniIndex(for distribution: [(object: Object, class: Int)],
                            classCount classCnt: Int) -> Double {
        var probabilities = [Double](
            repeating : 0.0,
            count: classCnt
        )
        var JiniIndex = 0.0
        for obj in distribution {
            probabilities[obj.class] += 1.0
        }
        for curClass in 0..<classCnt {
            probabilities[curClass] /= Double(distribution.count)
            JiniIndex += probabilities[curClass] * probabilities[curClass]
        }
        JiniIndex = 1.0 - JiniIndex
        return JiniIndex
    }
    
    class func getJiniIndex(
            for distribution: [(object: Object, class: Int)],
            classCount classCnt: Int,
            from startPos: Int,
            to endPos: Int
        ) -> Double {
        if endPos < startPos {
            return 0.0
        }
        var probabilities = [Double](
            repeating : 0.0,
            count: classCnt
        )
        var JiniIndex = 0.0
        for objectPos in startPos...endPos {
            probabilities[distribution[objectPos].class] += 1.0
        }
        for curClass in 0..<classCnt {
            probabilities[curClass] /= Double(endPos - startPos + 1)
            JiniIndex += probabilities[curClass] * probabilities[curClass]
        }
        JiniIndex = 1.0 - JiniIndex
        return JiniIndex
    }
    
    class func getSeparatingPlane(for distribution: [(object: Object, class: Int)],
                                  classCount classCnt: Int) -> SeparatingPlane? {
        var bestSeparatingPlane: SeparatingPlane? = nil
        var bestInformativity: Double? = nil
        let dimentions = distribution[0].object.dimentionsCount
        let objectCnt = distribution.count
        var bestPos: Int? = nil
        
        for curDimention in 0..<dimentions {
            
            let currentComparator = {
                (obj1: (Object, Int), obj2: (Object, Int)) -> Bool in
                return obj1.0.feature(number: curDimention) <
                    obj2.0.feature(number: curDimention)
            }
            
            let sortedDistribution = distribution.sorted(by: currentComparator)
            let getObject = {(i: Int) -> Object in return sortedDistribution[i].object}
            let getClass = {(i: Int) -> Int in return sortedDistribution[i].class}
            var leftJiniIndex = 0.0, rightJiniIndex = 1.0
            var leftClassCnt = [Double](repeating: 0.0, count: classCnt)
            var rightClassCnt = [Double](repeating: 0.0, count: classCnt)
            for i in 0..<objectCnt {
                rightClassCnt[getClass(i)] += 1.0
            }
            for curClass in 0..<classCnt {
                rightJiniIndex -= (rightClassCnt[curClass] / Double(objectCnt)) ** 2
            }
            var pos = 0
            while pos < objectCnt {
                repeat {
                    let curClass = getClass(pos)
                    // left Jini-index update:
                    let leftCoefficent = (Double(pos) / Double(pos + 1)) ** 2
                    leftJiniIndex = (1.0 - leftJiniIndex) * leftCoefficent
                    leftJiniIndex -= (leftClassCnt[curClass] / Double(pos + 1)) ** 2
                    leftClassCnt[curClass] += 1.0
                    leftJiniIndex += (leftClassCnt[curClass] / Double(pos + 1)) ** 2
                    leftJiniIndex = 1.0 - leftJiniIndex
                    // right Jini-index update:
                    let rightCoefficent = (Double(objectCnt - pos) / Double(objectCnt - pos - 1)) ** 2
                    rightJiniIndex = (1.0 - rightJiniIndex) * rightCoefficent
                    rightJiniIndex -= (rightClassCnt[curClass] / Double(objectCnt - pos - 1)) ** 2
                    rightClassCnt[curClass] -= 1.0
                    rightJiniIndex += (rightClassCnt[curClass] / Double(objectCnt - pos - 1)) ** 2
                    rightJiniIndex = 1.0 - rightJiniIndex
                    // now we will correctly separate [0..oldPos] from (oldPos; cnt) :
                    pos += 1
                } while (pos + 1 < objectCnt &&
                    getObject(pos + 1).feature(number: curDimention) ==
                    getObject(pos).feature(number: curDimention))
                
                let leftShare = Double(pos) / Double(objectCnt)
                let rightShare = 1.0 - leftShare
                let curInformativity = -leftShare * leftJiniIndex - rightShare * rightJiniIndex
                
                if (bestInformativity == nil || curInformativity > bestInformativity!) {
                    bestInformativity = curInformativity
                    let curTreshold = getObject(pos - 1).feature(number: curDimention)
                    bestSeparatingPlane = SeparatingPlane(
                        byDimention: curDimention,
                        andTresholdValue: curTreshold
                    )
                }
            }
        }
        return bestSeparatingPlane
    }
    
}
