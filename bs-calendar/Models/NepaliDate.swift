//
//  NepaliDate.swift
//  bs-calendar
//
//  Created by Ashik Chapagain on 11/01/2026.
//

import Foundation

struct NepaliDate: Equatable, Hashable {
    let year: Int
    let month: Int
    let day: Int
    
    var description: String {
        "\(year)/\(String(format: "%02d", month))/\(String(format: "%02d", day))"
    }
    
    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    func isSameDate(as other: NepaliDate) -> Bool {
        return year == other.year && month == other.month && day == other.day
    }
    
    func isSameMonth(as other: NepaliDate) -> Bool {
        return year == other.year && month == other.month
    }
}
