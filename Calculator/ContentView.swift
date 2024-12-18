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
    @State private var signCount: Int = 0
    
    let charExample = "x÷+-"
    
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
                    CalculatorButton(title:"%", action: {appendToDisplaySign("%")})
                }
                HStack(spacing: 10){
                    CalculatorButton(title:"1", action: {appendToDisplayNumber("1")})
                    CalculatorButton(title:"2", action: {appendToDisplayNumber("2")})
                    CalculatorButton(title:"3", action: {appendToDisplayNumber("3")})
                    CalculatorButton(title:"÷", action: {appendToDisplaySign("÷")})
                }
                HStack(spacing: 10){
                    CalculatorButton(title:"4", action: {appendToDisplayNumber("4")})
                    CalculatorButton(title:"5", action: {appendToDisplayNumber("5")})
                    CalculatorButton(title:"6", action: {appendToDisplayNumber("6")})
                    CalculatorButton(title:"x", action: {appendToDisplaySign("x")})
                }
                HStack(spacing: 10){
                    CalculatorButton(title:"7", action: {appendToDisplayNumber("7")})
                    CalculatorButton(title:"8", action: {appendToDisplayNumber("8")})
                    CalculatorButton(title:"9", action: {appendToDisplayNumber("9")})
                    CalculatorButton(title:"+", action: {appendToDisplaySign("+")})
                }
                HStack(spacing: 10){
                    CalculatorButton(title:"=", action: {calculate()})
                    CalculatorButton(title:"0", action: {appendToDisplayNumber("0")})
                    CalculatorButton(title:".", action: {appendToDisplaySign(".")})
                    CalculatorButton(title:"-", action: {appendToDisplaySign("-")})
                }
            }
        }
        .padding()
    }
    private func updateDisplayText() -> Void {
        shortage()
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
    
    //  APPEND TO DISPAY SIGN & NUMBER
    private func appendToDisplaySign(_ digit: String) -> Void{
        if charExample.contains(digit){
            if signCount == 0{
                signCount = 1
            }else{
                calculate()
                appendToDisplaySign(digit)
                return
            }
        }
        if displayTextArray[0] == "E"{
            return
        }else if digit == "%"{
            displayTextArray.append("%")
        }else if digit == "."{ // point case
            if displayTextArray.last == "."{
                return
            }else{
                displayTextArray.append(contentsOf: digit)
            }
        }else if charExample.contains(digit){
            if digit == "-" && (displayTextArray.last == "÷" || displayTextArray.last == "x"){
                displayTextArray.append(contentsOf: digit)
                updateDisplayText()
            }else{
                displayTextArray.append(contentsOf: digit)
            }
        }
        updateDisplayText()
    }
    
    private func appendToDisplayNumber(_ number: Character) -> Void{
        if displayTextArray[0] == "E"{
            displayTextArray = [number]
        }else if displayTextArray == ["0"]{
            displayTextArray = [number]
        }else {
            displayTextArray.append(number)
        }
        updateDisplayText()
    }
    
    // FIND 2 NUMBERS BETWEEN OPERATOR
    
    private func findNumbers(_ index: Int) -> (Int, Int, String, String){
        var num1Str : String = "", num2Str : String = "", start : Int = 0, end : Int = 0
        for i in stride(from: index - 1, to: -1, by: -1){
            if i == 0{start = 0}
            if displayTextArray[i].isNumber || displayTextArray[i] == "." || displayTextArray[i] == "%"{
                num1Str = String(displayTextArray[i]) + num1Str
            }else{
                start = i
            }
        }
        
        for i in index + 1..<displayTextArray.count{
            if displayTextArray[i].isNumber || displayTextArray[i] == "." || displayTextArray[i] == "%"{
                num2Str = num2Str + String(displayTextArray[i])
                end = i
            }
        }
        return (start, end, num1Str, num2Str)
    }
    
    //  MATH ACTIONS
    
    private func percent(_ percentIndex: Int) -> Void {
        var num1Str: String, num2Str: String, start: Int, end: Int
        (start, end, num1Str, num2Str) = findNumbers(percentIndex)
        
        if num1Str.contains("%"){
            num1Str.removeLast()
        }else if num2Str.contains("%"){
            num2Str.removeLast()
        }
        
        guard let num1 = Double(num1Str) else {
            displayTextArray = Array("Error : Failed to convert to Double")
            updateDisplayText()
            return
        }
        
        if let num2 = Double(num2Str), percentIndex > 0, displayTextArray[percentIndex - 1].isNumber {
            // 10x20%
            let result = num1 * (num2 / 100)
            let resultStr = Array(String(result))
            displayTextArray.replaceSubrange(start...end, with: resultStr)
        } else {
            // 20%
            let result = num1 / 100
            let resultStr = Array(String(result))
            displayTextArray.replaceSubrange(start...(percentIndex), with: resultStr)
        }
        updateDisplayText()
    }

    private func modulo(_ moduloIndex: Int) -> Void{
        var num1Str : String, num2Str : String, start : Int, end : Int
        
        (start, end, num1Str, num2Str) = findNumbers(moduloIndex)
        
        guard let num1 = Int(num1Str), let num2 = Int(num2Str), num2 != 0 else{
            displayTextArray = Array("Error : Division by zero") // zero divide handling
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
        guard let num1 = Double(num1Str), let num2 = Double(num2Str) else{
            displayTextArray = Array("Error : Wrong Sign")
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
        guard let num1 = Double(num1Str), let num2 = Double(num2Str) else{
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
        
        guard let num1 = Double(num1Str), let num2 = Double(num2Str) else{
            displayTextArray = Array("Error")
            updateDisplayText()
            return
        }
        let ret = num1 - num2
        let retStr = Array(String(ret))
        
        displayTextArray.replaceSubrange(start...end, with: retStr)
        updateDisplayText()
    }
    // func shortage
    
    private func shortage() -> Void{
        if displayTextArray.last == "0" && displayTextArray.firstIndex(of: ".") == displayTextArray.count-2{
            displayTextArray.replaceSubrange(displayTextArray.count-2...displayTextArray.count-1, with: Array(""))
        }
    }
    
    //  calculate func
    private func calculate() -> Void{
        for (i, char) in displayTextArray.enumerated() {
            if i == 0{continue}
            if char == "%" {
                if displayTextArray[i-1].isNumber && displayTextArray[i+1].isNumber{// check if modulo, if not then percent
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
        signCount = 0
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
