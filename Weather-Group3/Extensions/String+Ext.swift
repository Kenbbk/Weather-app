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
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let convertDate = dateFormatter.date(from: self)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = .current
        let a = dateFormatter.string(from: convertDate!)
        
        let parts = a.split(separator: " ")
       

        let timeParts = String(parts[1]).split(separator: ":00")
        let time = "\(timeParts[0]) 시"
        return time
    }
}



