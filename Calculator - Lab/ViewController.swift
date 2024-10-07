//
//  ViewController.swift
//  Calculator - Lab
//
//  Created by Dylan on 9/4/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var inputLabel: UILabel!
    
    @IBOutlet weak var zero: UIButton!
    
    @IBOutlet weak var decimal: UIButton!
    
    @IBOutlet weak var one: UIButton!
    
    @IBOutlet weak var two: UIButton!
    
    @IBOutlet weak var three: UIButton!
    
    @IBOutlet weak var four: UIButton!
    
    @IBOutlet weak var five: UIButton!
    
    @IBOutlet weak var six: UIButton!
    
    @IBOutlet weak var seven: UIButton!
    
    @IBOutlet weak var eight: UIButton!
    
    @IBOutlet weak var nine: UIButton!
    
    @IBOutlet weak var plus: UIButton!
    
    @IBOutlet weak var subtract: UIButton!
    
    @IBOutlet weak var multiply: UIButton!
    
    @IBOutlet weak var divide: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var equalButton: UIButton!
    
    private var currentInput = "0"
    private var currentResult: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        currentInput = "0"
        inputLabel.text = currentInput
    }
    
    @IBAction func opoeratorButtonTapped(_ sender: UIButton) {
        if let buttonTitle = sender.configuration?.title {
            currentInput += " " + buttonTitle + " "
            inputLabel.text = currentInput
        }
    }
    
    @IBAction func numberButtonTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.configuration?.title else { return }
        let currentInputAsDouble = Double(currentInput)
        if currentInput == "0" || currentInputAsDouble == currentResult {
            currentInput = buttonTitle
        } else {
            currentInput += buttonTitle
        }
        inputLabel.text = currentInput
    }
    
    @IBAction func equalButtonTapped(_ sender: UIButton) {
        let result = evaluateExpression(currentInput)
        inputLabel.text = String(result)
        currentInput = String(result)
    }
    
    private func evaluateExpression(_ expression: String) -> Double {
        let tokens = tokenize(expression)
        let postfix = infixToPostfix(tokens)
        return evaluatePostfix(postfix)
    }
    
    private func tokenize(_ expression: String) -> [String] {
        let operators = Set("+-*/")
        var tokens = [String]()
        var currentNumber = ""
        
        for character in expression {
            if character.isWhitespace {
                continue
            }
            if operators.contains(character) {
                if !currentNumber.isEmpty {
                    tokens.append(currentNumber)
                    currentNumber = ""
                }
                tokens.append(String(character))
            } else {
                currentNumber.append(character)
            }
        }
        if !currentNumber.isEmpty {
            tokens.append(currentNumber)
        }
        
        return tokens
    }
    
    private func infixToPostfix(_ tokens: [String]) -> [String] {
        var output = [String]()
        var operators = [String]()
        let precedence: [String: Int] = ["+": 1, "-": 1, "*": 2, "/": 2]
        
        for token in tokens {
            if let _ = Double(token) {
                output.append(token)
            } else {
                while let last = operators.last, let lastPrecedence = precedence[last], let tokenPrecedence = precedence[token], lastPrecedence >= tokenPrecedence {
                    output.append(operators.removeLast())
                }
                operators.append(token)
            }
        }
        
        while let last = operators.popLast() {
            output.append(last)
        }
        
        return output
    }
    
    private func evaluatePostfix(_ tokens: [String]) -> Double {
        var stack = [Double]()
        
        for token in tokens {
            if let number = Double(token) {
                stack.append(number)
            } else {
                guard stack.count >= 2 else {
                    print("Error: Insufficient operands for operation \(token)")
                    return 0.0
                }
                let right = stack.removeLast()
                let left = stack.removeLast()
                let result: Double
                
                switch token {
                case "+":
                    result = left + right
                case "-":
                    result = left - right
                case "*":
                    result = left * right
                case "/":
                    if right == 0 {
                        print("Error: Division by zero")
                        return 0.0
                    }
                    result = left / right
                default:
                    print("Error: Unknown operator \(token)")
                    return 0.0
                }
                stack.append(result)
            }
        }
        
        guard let finalResult = stack.last else {
            print("Error: No result found")
            return 0.0
        }
        self.currentResult = finalResult
        return finalResult
    }
}
