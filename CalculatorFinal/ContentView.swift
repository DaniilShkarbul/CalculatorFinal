//
//  ContentView.swift
//  CalculatorFinal
//
//  Created by Shkarbul, Daniil on 5/16/22.
//

import SwiftUI

struct ContentView: View {
    
    let grid = [
        ["AC", "_", "%", "/"],
        ["7", "8", "9", "X"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        [".", "0", "", "="]
    ]
    
    let operators = ["/", "+", "X", "%"]
    

  @State var Workings = ""
  @State var Results = ""
    @State var alertSystem = false
    
    var body: some View
    {
        VStack{
            
            HStack{
                Spacer()
             Text(Workings)
        
            .padding()
            .accentColor(Color.white)
            .font(.system(size: 30, weight: .heavy))
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack{
                Spacer()
        Text(Results)
        
            .padding()
            .accentColor(Color.white)
            .font(.system(size: 50, weight: .heavy))
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ForEach(grid, id: \.self)
            {
                row in
                HStack{
                ForEach(row, id: \.self)
                {
                    cell in
                    
                    Button(action: { buttonPressed(cell: cell)}, label: {
                     Text(cell)
                            .foregroundColor(buttonColor(cell))
                            .font(.system(size: 40, weight: .heavy))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    })
                }
                }
            }
            
        }
        .alert(isPresented: $alertSystem){
            Alert(title: Text("INVALID"), message: Text(Workings), dismissButton: .default(Text("Okay")))
        }
    }
    
    func buttonColor(_ cell: String) -> Color
    {
        if(cell == "AC" || cell == "_")
        {
            return .orange
        }
        
        if(cell == "-" || cell == "=" || operators.contains(cell))
        {
            return .red
        }
        
        return .black
        
    }
    
    func buttonPressed(cell: String)
    {
        
        switch cell {
        case "AC":
            Workings = ""
            Results = ""
        case "_":
            Workings = String(Workings.dropLast())
        case "=":
            Results = calcResults()
        case "-":
            minus()
        case "X", "/", "%", "+":
            AdditionNumbers(cell)
        default:
            Workings += cell
            
        }
        
    }
    func AdditionNumbers(_ cell : String)
    {
        if !Workings.isEmpty
        {
            let last = String(Workings.last!)
            if operators.contains(last) || last == "-"
            {
                Workings.removeLast()
            }
            Workings += cell
        }
    }
    
    func minus(){
        if Workings.isEmpty || Workings.last! != "-"
        {
            Workings += "-"
        }
    }
    func calcResults() -> String
    {
        if(validInput())
        {
        var workin = Workings.replacingOccurrences(of: "%", with: "*0.01")
        workin = Workings.replacingOccurrences(of: "X", with: "*")
        let expression = NSExpression(format: workin)
        let resulting = expression.expressionValue(with: nil, context: nil) as! Double
        
 return formating(val: resulting)
            
            
        }
        alertSystem = true
        return ""
    }
    func validInput() -> Bool
    {
        if(Workings.isEmpty){
            return false
        }
        let last = String(Workings.last!)
        
        if(operators.contains(last) || last == "-")
        {
            if(last != "%" || Workings.count == 1){
                return false
            }
        }
        return true
    }
    
    func formating(val: Double) -> String {
        if(val.truncatingRemainder(dividingBy: 1) == 0)
        {
            return String (format: "%.0f", val)
        }
        
        return String(format: "%.2f", val)
    }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
