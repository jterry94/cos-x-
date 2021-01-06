//
//  ContentView.swift
//  Shared
//
//  Created by Jeff Terry on 12/29/20.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    @ObservedObject var plotDataModel = PlotDataClass(fromLine: true)
    @ObservedObject private var cosCalculator = Cos_X_Calculator()
    @State var xInput: String = "\(Double.pi/2.0)"
    @State var cosOutput: String = "0.0"
    @State var computerCos: String = "\(cos(Double.pi/2.0))"
    @State var error: String = "0.0"
    @State var isChecked:Bool = false
  
    

    var body: some View {
        
        VStack{
      
            CorePlot(dataForPlot: $plotDataModel.plotData, changingPlotParameters: $plotDataModel.changingPlotParameters)
                .setPlotPadding(left: 10)
                .setPlotPadding(right: 10)
                .setPlotPadding(top: 10)
                .setPlotPadding(bottom: 10)
                .padding()
            
            Divider()
            
            HStack{
                
                HStack(alignment: .center) {
                    Text("x:")
                        .font(.callout)
                        .bold()
                    TextField("xValue", text: $xInput)
                        .padding()
                }.padding()
                
                HStack(alignment: .center) {
                    Text("cos(x):")
                        .font(.callout)
                        .bold()
                    TextField("cos(x)", text: $cosOutput)
                        .padding()
                }.padding()
                
                Toggle(isOn: $isChecked) {
                            Text("Display Error")
                        }
                .padding()
                
                
            }
            
            HStack{
                
                HStack(alignment: .center) {
                    Text("Expected:")
                        .font(.callout)
                        .bold()
                    TextField("Expected:", text: $computerCos)
                        .padding()
                }.padding()
                
                HStack(alignment: .center) {
                    Text("Error:")
                        .font(.callout)
                        .bold()
                    TextField("Error", text: $error)
                        .padding()
                }.padding()
            
                
            }
            
            
            HStack{
                Button("Calculate cos(x)", action: {self.calculateCos_X()} )
                .padding()
                
            }
            
        }
        
    }
    
    
    
    
    /// calculateCos_X
    /// Function accepts the command to start the calculation from the GUI
    func calculateCos_X(){
        
        let x = Double(xInput)
        xInput = "\(x!)"
        
        var cos_x = 0.0
        let actualcos_x = cos(x!)
        var errorCalc = 0.0
        
        //pass the plotDataModel to the cosCalculator
        cosCalculator.plotDataModel = self.plotDataModel
        
        //tell the cosCalculator to plot Data or Error
        cosCalculator.plotError = self.isChecked
        
        
        //Calculate the new plotting data and place in the plotDataModel
        cos_x = cosCalculator.calculate_cos_x(x: x!)
        

        print("The cos(\(x!)) = \(cos_x)")
        print("computer calcuates \(actualcos_x)")
        
        cosOutput = "\(cos_x)"
        
        computerCos = "\(actualcos_x)"
        
        if(actualcos_x != 0.0){
            
            var numerator = cos_x - actualcos_x
            
            if(numerator == 0.0) {numerator = 1.0E-16}
            
            errorCalc = log10(abs((numerator)/actualcos_x))
            
        }
        else {
            errorCalc = 0.0
        }
        
        error = "\(errorCalc)"
        
    }
    

   
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
