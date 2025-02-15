//
//  ContentView.swift
//  Calculator
//
//  Created by Łukasz Bilski on 03/11/2024.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var displayText: String = "0"
    @State private var expression: String = ""
    @State private var lastWasOperator = false
    @State private var lastWasNumber = false
    @State private var decimalAdded = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(displayText)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.system(size: 48, weight: .light))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding()
                .background(Color.gray.opacity(0.2))
            
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    CalculatorButton(title: "AC", action: clear)
                    CalculatorButton(title: "±", action: changeSign)
                    CalculatorButton(title: "%", action: percentage)
                    CalculatorButton(title: "÷", action: { appendOperator("÷") })
                }
                HStack(spacing: 10) {
                    CalculatorButton(title: "7", action: { appendNumber("7") })
                    CalculatorButton(title: "8", action: { appendNumber("8") })
                    CalculatorButton(title: "9", action: { appendNumber("9") })
                    CalculatorButton(title: "×", action: { appendOperator("×") })
                }
                HStack(spacing: 10) {
                    CalculatorButton(title: "4", action: { appendNumber("4") })
                    CalculatorButton(title: "5", action: { appendNumber("5") })
                    CalculatorButton(title: "6", action: { appendNumber("6") })
                    CalculatorButton(title: "-", action: { appendOperator("-") })
                }
                HStack(spacing: 10) {
                    CalculatorButton(title: "1", action: { appendNumber("1") })
                    CalculatorButton(title: "2", action: { appendNumber("2") })
                    CalculatorButton(title: "3", action: { appendNumber("3") })
                    CalculatorButton(title: "+", action: { appendOperator("+") })
                }
                HStack(spacing: 10) {
                    CalculatorButton(title: "0", action: { appendNumber("0") })
                    CalculatorButton(title: ".", action: addDecimal)
                    CalculatorButton(title: "=", action: calculate)
                }
            }
        }
        .padding()
    }
    
    // MARK: - Funkcje operacyjne
       
    private func clear() {
        displayText = "0"
        expression = ""
        lastWasOperator = false
        lastWasNumber = false
        decimalAdded = false
    }
       
    private func changeSign() {
        guard displayText != "0" else { return }
        displayText = displayText.hasPrefix("-") ? String(displayText.dropFirst()) : "-" + displayText
    }
       
    private func percentage() {
        guard let value = Double(displayText) else { return }
        displayText = formatResult(value / 100)
        expression = displayText
    }
       
    private func appendNumber(_ number: String) {
        if displayText == "0" || lastWasOperator {
            displayText = number
        } else {
            displayText += number
        }
        lastWasNumber = true
        lastWasOperator = false
    }
       
    private func addDecimal() {
        guard !decimalAdded else { return }
        displayText += "."
        decimalAdded = true
        lastWasNumber = true
        lastWasOperator = false
    }
       
    private func appendOperator(_ op: String) {
        guard lastWasNumber else { return }
        expression += displayText + op
        displayText = "0"
        decimalAdded = false
        lastWasOperator = true
        lastWasNumber = false
    }
       
    private func calculate() {
        guard lastWasNumber else { return }
        expression += displayText
        
        let sanitizedExpression = expression
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
        
        let expr = NSExpression(format: sanitizedExpression)
        guard let result = expr.expressionValue(with: nil, context: nil) as? Double else {
            displayText = "Błąd"
            expression = ""
            return
        }
           
        displayText = formatResult(result)
        expression = ""
        lastWasNumber = true
        decimalAdded = displayText.contains(".")
        lastWasOperator = false
    }
       
    private func formatResult(_ result: Double) -> String {
        // Jeśli wynik jest całkowity, wyświetlamy jako liczbę całkowitą
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(result))
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.locale = Locale(identifier: "en_US")
        // Ustawiamy stałą liczbę miejsc po przecinku
        formatter.maximumFractionDigits = 7
        // Ustawiamy tryb obcinania – bez zaokrąglania
        formatter.roundingMode = .down
        
        return formatter.string(from: NSNumber(value: result)) ?? "\(result)"
    }
}

struct CalculatorButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title)
                .frame(width: title == "0" ? 150 : 70, height: 70)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 35))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
