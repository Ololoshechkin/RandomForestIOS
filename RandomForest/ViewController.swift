//
//  ViewController.swift
//  RandomForest
//
//  Created by Vadim on 06.02.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var samplesCountTextbox: UITextField!
    
    @IBOutlet weak var validationTestCountTextbox: UITextField!
    
    @IBOutlet weak var correctLabel: UILabel!
    
    @IBOutlet weak var VisualiserView: UIView!
    
    let dimentionCount = 2, classCount = 4
    
    var decisionTree: DecisionTree = DecisionTree()
    
    @IBAction func startButton(_ sender: Any) {
        let samplesCount = Int(samplesCountTextbox.text!)!
        let validationTestCount = Int(validationTestCountTextbox.text!)!
        decisionTree = DecisionTree(dimentionCount: 2, classCount: 4)
        var samples: [(object: Object, class: Int)] = []
        for _ in 0..<samplesCount {
            var objectFeatures = [Double]()
            for _ in 0..<dimentionCount {
                objectFeatures.append(Double.random)
            }
            let object = Object(dimentionsCount: dimentionCount,
                                objectFeatures: objectFeatures)
            samples.append((object: object, class: getClass(for: object)))
            //print("point : (\(object.feature(number: 0)), \(object.feature(number: 1)))")
        }
        print("---studying---")
        decisionTree.stydy(by: samples)
        print("---finished studying---")
        var tests = [Object]()
        for _ in 0..<validationTestCount {
            var objectFeatures = [Double]()
            for _ in 0..<dimentionCount {
                objectFeatures.append(Double.random)
            }
            let object = Object(dimentionsCount: dimentionCount,
                                objectFeatures: objectFeatures)
            tests.append(object)
        }
        print("---testing---")
        var correct = 0.0
        for testObject in tests {
            let expectedClass = getClass(for: testObject)
            let treeClass = decisionTree.getMostPossibleClass(for: testObject)
            if expectedClass == treeClass {
                correct += 1.0
            }
        }
        print("---finished testing---")
        correct *= 100.0 / Double(validationTestCount)
        correctLabel.text = "correct: \(correct)%"
    }
    
    
    
    func getClass(for point: Object) -> Int {
        let x = point.feature(number: 0)
        let y = point.feature(number: 1)
        if (0.75 - x <= y && y <= 0.92 - x) {
            return 3
        }
        if (x - 0.5) * (x - 0.5) + (y - 0.5) * (y - 0.5) <= 0.1 {
            return 2
        }
        return (y >= -(x - 0.5) * (x - 0.5) + 0.5 ? 1 : 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

