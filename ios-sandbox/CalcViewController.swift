//
//  CalcViewController.swift
//  ios-sandbox
//
//  Created by Ross Whitehead on 02/07/2018.
//  Copyright © 2018 Ross Whitehead. All rights reserved.
//

import UIKit

class CalcViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    
    var currentElement: String = ""
    var lastElement: String = ""
    var currentOperator = ""
    var isOperating: Bool = false
    var elements: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Number(_ sender: UIButton) {
        currentElement = currentElement + String(sender.tag - 1)
        display.text = currentElement
    }
    
    @IBAction func Back(_ sender: UIButton) {
        if(elements.count > 1) {
            elements.removeLast()
            currentElement = elements.last!
            display.text = currentElement
        }
    }
    
    @IBAction func Clear(_ sender: UIButton) {
        currentElement = ""
        display.text = ""
        elements = []
        isOperating = false
        return
    }
    
    @IBAction func Equals(_ sender: UIButton) {
        switch currentOperator {
        case "/":
            currentElement = String(Float(lastElement)! / Float(currentElement)!)
        case "X":
            currentElement = String(Float(lastElement)! * Float(currentElement)!)
        case "-":
            currentElement = String(Float(lastElement)! - Float(currentElement)!)
        case "+":
            currentElement = String(Float(lastElement)! + Float(currentElement)!)
        default:
            // should never be here
            return
        }
        
        elements.append(lastElement)
        display.text = currentElement
        isOperating = false
        return
    }
    
    @IBAction func Operator(_ sender: UIButton) {
        
        if(isOperating) {
            switch currentOperator {
            case "/":
                currentElement = String(Float(lastElement)! / Float(currentElement)!)
            case "X":
                currentElement = String(Float(lastElement)! * Float(currentElement)!)
            case "-":
                currentElement = String(Float(lastElement)! - Float(currentElement)!)
            case "+":
                currentElement = String(Float(lastElement)! + Float(currentElement)!)
            default:
                // should never be here
                return
            }
        }
        
        switch sender.tag {
        case 11:
            currentOperator = "/"
        case 12:
            currentOperator = "X"
        case 13:
            currentOperator = "-"
        case 14:
            currentOperator = "+"
        default:
            // should never be here
            return
        }
        
        lastElement = currentElement
        display.text = lastElement
        elements.append(lastElement)
        currentElement = ""
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
