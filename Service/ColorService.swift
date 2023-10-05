//
//  CustomColor.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 10/3/23.
//

import UIKit

struct ColorService {
    
    var colors: [UIColor] = [
        
        UIColor.init(red: 0/255, green: 102/255, blue: 204/255, alpha: 1),
        UIColor.init(red: 51/255, green: 153/255, blue: 255/255, alpha: 1),
        UIColor.init(red: 102/255, green: 178/255, blue: 255/255, alpha: 1),
        UIColor.init(red: 153/255, green: 204/255, blue: 255/255, alpha: 1),
        UIColor.init(red: 204/255, green: 229/255, blue: 255/255, alpha: 1),
        UIColor.init(red: 255/255, green: 255/255, blue: 0/255, alpha: 1),
        UIColor.init(red: 255/255, green: 178/255, blue: 102/255, alpha: 1),
        UIColor.init(red: 255/255, green: 153/255, blue: 51/255, alpha: 1),
        UIColor.blue
//        UIColor.init(red: 255/255, green: 128/255, blue: 0, alpha: 1)
        
    ]
    
    func getColors(min: Double, max: Double) -> [CGColor] {
        
        var result: [CGColor] = []
        
        let minColorNumber = getColorNumber(temp: min)
        let maxColorNumber = getColorNumber(temp: max)
    
        if minColorNumber == maxColorNumber {
            result.append(colors[maxColorNumber].cgColor)
            result.append(colors[minColorNumber].cgColor)
        } else {
            for number in minColorNumber...maxColorNumber {
                result.append(colors[number].cgColor)
            }
        }
        
        return result
        
    }
    
    private func getColorNumber(temp: Double) -> Int {
        switch temp {
        case 35...:
            return 8
        case 28...:
            return 7
        case 21...:
            return 6
        case 14...:
            return 5
        case 7...:
            return 4
        case 0...:
            return 3
        case (-7)...:
            return 2
        case (-14)...:
            return 1
        case (-21)...:
            return 0
        default:
            return 0
            
        }
        
    }
}
