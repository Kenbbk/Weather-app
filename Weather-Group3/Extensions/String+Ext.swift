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
        let parts = self.split(separator: " ")
        
        let timeParts = String(parts[1]).split(separator: ":00")
        let time = "\(timeParts[0]) 시"
        return time
    }
}
