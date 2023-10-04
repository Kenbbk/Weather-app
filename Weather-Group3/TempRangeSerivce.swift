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
        let maxPoint: Double!
        let minPoint: Double!
        
        
        minPoint = (currentMin - min) / diff
        maxPoint = (max - currentMax) / diff
        
        return (minPoint, maxPoint)

    }
}



