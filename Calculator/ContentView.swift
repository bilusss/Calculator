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
    private var digitsArray : [String] = []
    private var operatorsArray : [String] = []
    
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
                    CalculatorButton(title:"=", action: {appendToDisplay("=")})
                    CalculatorButton(title:"0", action: {appendToDisplay("0")})
                    CalculatorButton(title:",", action: {appendToDisplay(",")})
                    CalculatorButton(title:"-", action: {appendToDisplay("-")})
                }
            }
        }
        .padding()
        .background(Color.purple.opacity(0.5))
        .edgesIgnoringSafeArea(.all)
    }
    private func clearDisplay() -> Void{
        displayText = "0"
    }
    private func clearOnedigit() -> Void{//displayText[displayText.index(displayText.startIndex, offsetBy: 1)] != "0"
        if displayText.first == "-" && displayText.count < 3{
            clearDisplay()
        }else if displayText != "0" && displayText.count > 1{
            displayText.remove(at: displayText.index(before: displayText.endIndex))
        }else if displayText != "0"{
            displayText = "0"
        }
    }
    private func changeSign() -> Void{
        if displayText.first == "-"{
            displayText.remove(at: displayText.startIndex)
        }else if displayText == "0" && displayText.count == 1{
            
        }else{
            displayText.insert("-", at: displayText.startIndex)
        }
    }
    private func appendToDisplay(_ digit: String){
        if displayText == "0" {
            displayText = digit
        } else {
            displayText += digit
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
