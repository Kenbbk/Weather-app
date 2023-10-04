//
//  SlopeCalculatorService.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 10/3/23.
//

import Foundation

struct SlopeCalculatorService {
    
    func calculateY(x: Double, point1: (Double, Double), point2: (Double, Double)) -> Double? {
        let (x1, y1) = point1
        let (x2, y2) = point2
        
        // Calculate the slope (m) and intercept (b)
        let m = (y2 - y1) / (x2 - x1)
        let b = y1 - m * x1
        
        // Calculate the y value for the given x
        let y = m * x + b
        
        
        return y.isNaN ? nil : y
    }
}
