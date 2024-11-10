//
//  ContentView.swift
//  Calculator
//
//  Created by Łukasz Bilski on 03/11/2024.
//

import SwiftUI

struct ContentView: View {
    // Przechowujemy wyświetlaną wartość
    @State private var displayText : String = "0"
    @State private var displayTextArray : [Character] = ["0"]
    
    //private var digitsArray : [String] = []
    //private var operatorsArray : [String] = []
    let charExample = "x/+-"
    
    var body : some View {
        VStack(spacing: 20){
            // Value Display:
            Text(String(displayText))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.largeTitle)
                .padding()
                .background(Color.gray.opacity(0.2))
            VStack(spacing: 10){
                HStack(spacing: 10){
                    CalculatorButton(title:"⌫", action: {clearOnedigit()})
                    CalculatorButton(title:"AC", action: {clearDisplay()})
                    CalculatorButton(title:"±", action: {changeSign()})
                    CalculatorButton(title:"%", action: {appendToDisplay("%")})
                }
                HStack(spacing: 10){
                    CalculatorButton(title:"1", action: {appendToDisplay("1")})
                    CalculatorButton(title:"2", action: {appendToDisplay("2")})
                    CalculatorButton(title:"3", action: {appendToDisplay("3")})
                    CalculatorButton(title:"÷", action: {appendToDisplay("÷")})
                }
                HStack(spacing: 10){
                    CalculatorButton(title:"4", action: {appendToDisplay("4")})
                    CalculatorButton(title:"5", action: {appendToDisplay("5")})
                    CalculatorButton(title:"6", action: {appendToDisplay("6")})
                    CalculatorButton(title:"x", action: {appendToDisplay("x")})
                }
                HStack(spacing: 10){
                    CalculatorButton(title:"7", action: {appendToDisplay("7")})
                    CalculatorButton(title:"8", action: {appendToDisplay("8")})
                    CalculatorButton(title:"9", action: {appendToDisplay("9")})
                    CalculatorButton(title:"+", action: {appendToDisplay("+")})
                }
                HStack(spacing: 10){
                    CalculatorButton(title:"=", action: {calculateFirst()})
                    CalculatorButton(title:"0", action: {appendToDisplay("0")})
                    CalculatorButton(title:",", action: {appendToDisplay(",")})
                    CalculatorButton(title:"-", action: {appendToDisplay("-")})
                }
            }
        }
        .padding()
    }
    private func updateDisplayText() -> Void {
        displayText = String(displayTextArray)
    }
    //  buttons actions
    private func clearDisplay() -> Void{
        displayTextArray = ["0"]
        updateDisplayText()
    }
    private func clearOnedigit() -> Void{
        if displayTextArray[0] == "-" && displayTextArray.count < 3{
            clearDisplay()
        }else if displayTextArray != ["0"] && displayTextArray.count > 1 {
            displayTextArray.removeLast()
            if displayTextArray.isEmpty {
                displayTextArray = ["0"]
            }
            updateDisplayText()
        }else if displayTextArray != ["0"] {
            displayTextArray = ["0"]
            updateDisplayText()
        }
    }
    private func changeSign() -> Void{//    make a case that usr can change sign later after "*/+-"
        if displayTextArray.first == "-" {
            displayTextArray.remove(at: 0)
        }else if displayTextArray != ["0"] {
            displayTextArray.insert("-", at: 0)
        }
        updateDisplayText()
    }
    private func appendToDisplay(_ digit: String){
        if displayTextArray[0] == "E"{
            if charExample.contains(digit){}else{displayTextArray = Array(digit)}
        }
        if displayTextArray == ["0"] && digit != "%"{
            displayTextArray = Array(digit)
        }else{
            displayTextArray.append(contentsOf: digit)
        }
        updateDisplayText()
    }
    
    // FIND 2 NUMBERS BETWEEN OPERATOR
    private func findNumbers(_ index: Int) -> (Int, Int, String, String){
        var num1Str : String = "", num2Str : String = "", start : Int = 0, end : Int = 0
        for i in stride(from: index - 1, to: -1, by: -1){
            if i == 0{start = 0}
            if displayTextArray[i].isNumber || displayTextArray[i] == "."{
                num1Str = String(displayTextArray[i]) + num1Str
            }else{
                start = i
            }
        }
        
        for i in index + 1..<displayTextArray.count{
            if displayTextArray[i].isNumber || displayTextArray[i] == "."{
                num2Str = num2Str + String(displayTextArray[i])
                end = i
            }
        }
        return (start, end, num1Str, num2Str)
    }
    
    //  MATH ACTIONS
    
    private func percent(_ percentIndex: Int) {
        var num1Str: String, num2Str: String, start: Int, end: Int
        (start, end, num1Str, num2Str) = findNumbers(percentIndex)
        
        guard let num1 = Double(num1Str), let num2 = Double(num2Str) else {
            displayTextArray = Array("Error")
            updateDisplayText()
            return
        }
        
        // Sprawdź kontekst użycia operatora procentowego
        if percentIndex < displayTextArray.count - 1 && displayTextArray[percentIndex + 1].isNumber {
            // 20%x50= case
            let result = (num1 / 100) * num2
            let resultStr = Array(String(result))
            displayTextArray.replaceSubrange(start...end, with: resultStr)
        } else if percentIndex > 0 && displayTextArray[percentIndex - 1].isNumber {
            // 50x20%= case
            let result = (num2 / 100) * num1
            let resultStr = Array(String(result))
            displayTextArray.replaceSubrange(start...end, with: resultStr)
        }
        updateDisplayText()
    }
    private func modulo(_ moduloIndex: Int) -> Void{
        var num1Str : String, num2Str : String, start : Int, end : Int
        
        (start, end, num1Str, num2Str) = findNumbers(moduloIndex)
        
        guard let num1 = Int(num1Str), let num2 = Int(num2Str), num2 != 0 else{
            displayTextArray = Array("Error") // zero divide handling
            updateDisplayText()
            return
        }
        
        let ret = num1 % num2
        let retStr = Array(String(ret))
        //changing array
        displayTextArray.replaceSubrange(start...end, with: retStr)
        updateDisplayText()
    }
    private func multiply(_ multiplyIndex: Int) -> Void{
        var num1Str : String, num2Str : String, start : Int, end : Int
        (start, end, num1Str, num2Str) = findNumbers(multiplyIndex)
        guard let num1 = Int(num1Str), let num2 = Int(num2Str) else{
            displayTextArray = Array("Error")
            updateDisplayText()
            return
        }
        let ret = num1 * num2
        let retStr = Array(String(ret))
        
        displayTextArray.replaceSubrange(start...end, with: retStr)
        updateDisplayText()
    }
    private func divide(_ divideIndex: Int) -> Void{
        var num1Str : String, num2Str : String, start : Int, end : Int
        (start, end, num1Str, num2Str) = findNumbers(divideIndex)
        
        guard let num1 = Double(num1Str), let num2 = Double(num2Str), num2 != 0 else{
            displayTextArray = Array("Error") // zero divide handling
            updateDisplayText()
            return
        }
        
        let ret : Double = num1 / num2
        let retStr = Array(String(ret))
        
        displayTextArray.replaceSubrange(start...end, with: retStr)
        
        updateDisplayText()
    }
    private func plus(_ plusIndex: Int) -> Void{
        var num1Str : String, num2Str : String, start : Int, end : Int
        (start, end, num1Str, num2Str) = findNumbers(plusIndex)
        guard let num1 = Int(num1Str), let num2 = Int(num2Str) else{
            displayTextArray = Array("Error")
            updateDisplayText()
            return
        }
        let ret = num1 + num2
        let retStr = Array(String(ret))
        
        displayTextArray.replaceSubrange(start...end, with: retStr)
        updateDisplayText()
    }
    private func minus(_ minusIndex: Int) -> Void{
        var num1Str : String, num2Str : String, start : Int, end : Int
        (start, end, num1Str, num2Str) = findNumbers(minusIndex)
        guard let num1 = Int(num1Str), let num2 = Int(num2Str) else{
            displayTextArray = Array("Error")
            updateDisplayText()
            return
        }
        let ret = num1 - num2
        let retStr = Array(String(ret))
        
        displayTextArray.replaceSubrange(start...end, with: retStr)
        updateDisplayText()
    }
    //  calculate func
    private func calculateFirst() {
        for (i, char) in displayTextArray.enumerated() {
            if i == 0{continue}
            if char == "%" {
                if displayTextArray[i-1].isNumber && displayTextArray[i+1].isNumber{// check if modulo
                    modulo(i)
                }else{
                    percent(i)
                }
            }
            if char == "÷" {
                divide(i)
            }
            if char == "x" {
                multiply(i)
            }
            if char == "+" {
                plus(i)
            }
            if char == "-" {
                minus(i)
            }
        }
    }

}

struct CalculatorButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title)
                .frame(width: 70, height: 70)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
