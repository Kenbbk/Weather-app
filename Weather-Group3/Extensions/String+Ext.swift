//
//  String+Ext.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 10/5/23.
//

import Foundation

extension String {
    
    func convertDateIntoDay() -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let convertDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "EEE"
        
        let outputDate = dateFormatter.string(from: convertDate!)
        return outputDate
    }
    
    func convertToTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let convertDate = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        
        let outputDate = dateFormatter.string(from: convertDate!)
        
        let parts = outputDate.split(separator: " ")
        
        let timeParts = String(parts[1]).split(separator: ":00")
        let time = "\(timeParts[0]) 시"
        return time
    }
    
    func convertInputDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let convertDate = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        
        let outputDate = dateFormatter.string(from: convertDate!)
        return outputDate
    }
}
