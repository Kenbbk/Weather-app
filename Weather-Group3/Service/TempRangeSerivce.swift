//
//  TempRangeSerivce.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 2023/09/30.
//

import Foundation

struct TempRangeService {
    
    func getTempRange(min: Double, max: Double, currentMin: Double, currentMax: Double) -> (Double, Double) {
        
        let diff = max - min
        var maxPoint: Double!
        var minPoint: Double!
        minPoint = (currentMin - min) / diff
        if minPoint <= 0 {
           minPoint = 0
        }
        
        maxPoint = (max - currentMax) / diff
        if maxPoint <= 0 {
           maxPoint = 0
        }
        return (minPoint, maxPoint)

    }
}



