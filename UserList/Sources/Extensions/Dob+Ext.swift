//
//  Dob+Ext.swift
//  UserList
//
//  Created by Julien Cotte on 22/11/2024.
//

import Foundation

extension User.Dob {
    func getFrenchDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let dateFr = inputFormatter.date(from: date) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "fr_FR")
            outputFormatter.dateFormat = "d MMMM yyyy"
            
            return outputFormatter.string(from: dateFr)
        } else {
            return date
        }
    }
    
    func getUSDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let dateUs = inputFormatter.date(from: date) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "en_US")
            outputFormatter.dateFormat = "MMMM d yyyy"
            
            return outputFormatter.string(from: dateUs)
        } else {
            return date
        }
    }

}
