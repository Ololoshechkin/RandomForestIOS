//
//  ViewController.swift
//  RandomForest
//
//  Created by Vadim on 06.02.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var samplesCountTextbox: UITextField!
    
    @IBOutlet weak var validationTestCountTextbox: UITextField!
    
    @IBOutlet weak var correctLabel: UILabel!
    
    @IBOutlet weak var VisualiserView: UIView!
    
    let dimentionCount = 2, classCount = 4
    
    var decisionTree: DecisionTree = DecisionTree()
    
    @IBAction func startButton(_ sender: Any) {
        let samplesCount = Int(samplesCountTextbox.text!) ?? 100
        let validationTestCount = Int(validationTestCountTextbox.text!) ?? 100
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
        
        let Width = Double(VisualiserView.bounds.width)
        let Height = Double(VisualiserView.bounds.height)
        
        VisualiserView.layer.sublayers?.removeAll()
        
        let coloring = decisionTree.getColoring()
        for rectWithClass in coloring {
            let rect = CGRect(x: rectWithClass.rect.minX * CGFloat(Width),
                              y: rectWithClass.rect.minY * CGFloat(Height),
                              width: rectWithClass.rect.width * CGFloat(Width),
                              height: rectWithClass.rect.height * CGFloat(Height))
            let curColor = getColor(ofClass: rectWithClass.class)
            drawRect(rect, curColor, alphaComp: 0.5)
        }
        
        let samplesSubarray = samples.getRandomSubarray(withSize: min(samples.count, 2000))
        for sample in samplesSubarray {
            let x = sample.object.feature(number: 0) * Width
            let y = sample.object.feature(number: 1) * Height
            drawCircle(x, y, radius: 2.0, color: getColor(ofClass: sample.class))
        }
    }
    
    func drawCircle(_ x: Double, _ y: Double, radius r: Double, color: UIColor) {
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: x,y: y),
            radius: 2.0,
            startAngle: CGFloat(0),
            endAngle:CGFloat(M_PI * 2),
            clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1.0
        
        VisualiserView.layer.addSublayer(shapeLayer)
    }
    
    func drawRect(_ rect: CGRect, _ color: UIColor, alphaComp alpha: Double = 1.0) {
        let rectPath = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(0.0))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = rectPath.cgPath
        
        shapeLayer.fillColor = color.withAlphaComponent(CGFloat(alpha)).cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1.0
        
        VisualiserView.layer.addSublayer(shapeLayer)
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
    
    func getColor(ofClass curClass: Int) -> UIColor {
        switch curClass {
        case 0:
            return UIColor.red
        case 1:
            return UIColor.blue
        case 2:
            return UIColor.brown
        case 3:
            return UIColor.cyan
        default:
            return UIColor.green
        }
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

