//
//  NepaliFormatter.swift
//  bs-calendar
//
//  Created by Ashik Chapagain on 11/01/2026.
//

import Foundation

class NepaliFormatter {
    static let shared = NepaliFormatter()
    
    private let nepaliDigits = ["०", "१", "२", "३", "४", "५", "६", "७", "८", "९"]
    
    private init() {}
    
    func toNepaliNumerals(_ number: Int) -> String {
        let numberString = String(number)
        var result = ""
        
        for char in numberString {
            if let digit = Int(String(char)) {
                result += nepaliDigits[digit]
            } else {
                result += String(char)
            }
        }
        
        return result
    }
    
    func formatDate(_ date: NepaliDate, useNepaliNumerals: Bool = true) -> String {
        if useNepaliNumerals {
            return "\(toNepaliNumerals(date.year))/\(toNepaliNumerals(date.month))/\(toNepaliNumerals(date.day))"
        } else {
            return "\(date.year)/\(date.month)/\(date.day)"
        }
    }
    
    func formatShortDate(_ date: NepaliDate, useNepaliNumerals: Bool = true) -> String {
        if useNepaliNumerals {
            return "\(toNepaliNumerals(date.month))/\(toNepaliNumerals(date.day))"
        } else {
            return "\(date.month)/\(date.day)"
        }
    }
    
    func formatDateWithMonth(_ date: NepaliDate, useNepaliNumerals: Bool = true) -> String {
        let monthName = CalendarDataManager.shared.getMonthName(month: date.month, nepali: useNepaliNumerals)
        let day = useNepaliNumerals ? toNepaliNumerals(date.day) : String(date.day)
        
        return "\(monthName) \(day)"
    }
}
