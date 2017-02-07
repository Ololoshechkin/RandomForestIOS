//
//  DecisionTreeNode.swift
//  RandomForest
//
//  Created by Vadim on 06.02.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import Foundation

class DecisionTreeNode {
    
    public var dimentionCount: Int
    
    public var numberOfClasses: Int {
        didSet(newClassesCnt) {
            classProbabilities = [Double](
                repeating: 0.0, count : numberOfClasses
            )
        }
    }
    
    public var isLeaf: Bool
    
    public var separatingPlane: SeparatingPlane
    
    public var leftSon: DecisionTreeNode?
    
    public var rightSon: DecisionTreeNode?
    
    public var classProbabilities: [Double]
    
    init(dimentionCount dim: Int = 1, classCount nmb: Int = 1) {
        dimentionCount = dim
        numberOfClasses = nmb
        isLeaf = false
        separatingPlane = SeparatingPlane()
        leftSon = nil
        rightSon = nil
        classProbabilities = [Double](repeating: 0.0, count : numberOfClasses)
    }

    func getNextNode(forObject object: Object) -> DecisionTreeNode {
        return (separatingPlane.predicateLeft(for: object) ? leftSon : rightSon)!
    }
    
    func getProbability(forClass classNumber: Int) -> Double {
        return classProbabilities[classNumber]
    }
    
    func getMostPossibleClassNumber() -> Int {
        return classProbabilities.index(of: classProbabilities.max()!)!
    }
    
}
