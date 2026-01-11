//
//  DateConverter.swift
//  bs-calendar
//
//  Created by Ashik Chapagain on 11/01/2026.
//

import Foundation

class DateConverter {
    static let shared = DateConverter()
    private let dataManager = CalendarDataManager.shared
    
    private init() {}
    
    func adToBS(_ adDate: Date) -> NepaliDate? {
        guard let reference = dataManager.getReferenceDate() else { return nil }
        
        let calendar = Calendar.current
        let daysDifference = calendar.dateComponents([.day], from: reference.ad, to: adDate).day ?? 0
        
        if daysDifference >= 0 {
            return addDaysToBS(reference.bs, days: daysDifference)
        } else {
            return subtractDaysFromBS(reference.bs, days: abs(daysDifference))
        }
    }
    
    func bsToAD(_ bsDate: NepaliDate) -> Date? {
        guard let reference = dataManager.getReferenceDate() else { return nil }
        
        let daysDifference = daysBetweenBS(from: reference.bs, to: bsDate)
        
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: daysDifference, to: reference.ad)
    }
    
    func getTodayBS() -> NepaliDate? {
        return adToBS(Date())
    }
    
    private func addDaysToBS(_ startDate: NepaliDate, days: Int) -> NepaliDate? {
        var currentDate = startDate
        var remainingDays = days
        
        while remainingDays > 0 {
            guard let daysInMonth = dataManager.getDaysInMonth(year: currentDate.year, month: currentDate.month) else {
                return nil
            }
            
            let daysLeftInMonth = daysInMonth - currentDate.day
            
            if remainingDays <= daysLeftInMonth {
                currentDate = NepaliDate(
                    year: currentDate.year,
                    month: currentDate.month,
                    day: currentDate.day + remainingDays
                )
                remainingDays = 0
            } else {
                remainingDays -= (daysLeftInMonth + 1)
                
                if currentDate.month == 12 {
                    currentDate = NepaliDate(year: currentDate.year + 1, month: 1, day: 1)
                } else {
                    currentDate = NepaliDate(year: currentDate.year, month: currentDate.month + 1, day: 1)
                }
            }
        }
        
        return currentDate
    }
    
    private func subtractDaysFromBS(_ startDate: NepaliDate, days: Int) -> NepaliDate? {
        var currentDate = startDate
        var remainingDays = days
        
        while remainingDays > 0 {
            if remainingDays < currentDate.day {
                currentDate = NepaliDate(
                    year: currentDate.year,
                    month: currentDate.month,
                    day: currentDate.day - remainingDays
                )
                remainingDays = 0
            } else {
                remainingDays -= currentDate.day
                
                if currentDate.month == 1 {
                    currentDate = NepaliDate(year: currentDate.year - 1, month: 12, day: 1)
                } else {
                    currentDate = NepaliDate(year: currentDate.year, month: currentDate.month - 1, day: 1)
                }
                
                guard let daysInPrevMonth = dataManager.getDaysInMonth(year: currentDate.year, month: currentDate.month) else {
                    return nil
                }
                
                currentDate = NepaliDate(
                    year: currentDate.year,
                    month: currentDate.month,
                    day: daysInPrevMonth
                )
            }
        }
        
        return currentDate
    }
    
    private func daysBetweenBS(from startDate: NepaliDate, to endDate: NepaliDate) -> Int {
        if startDate.year == endDate.year && startDate.month == endDate.month {
            return endDate.day - startDate.day
        }
        
        var days = 0
        var currentDate = startDate
        
        if endDate.year > startDate.year || (endDate.year == startDate.year && endDate.month > startDate.month) || (endDate.year == startDate.year && endDate.month == startDate.month && endDate.day >= startDate.day) {
            // Forward calculation
            while !(currentDate.year == endDate.year && currentDate.month == endDate.month) {
                guard let daysInMonth = dataManager.getDaysInMonth(year: currentDate.year, month: currentDate.month) else {
                    break
                }
                
                days += daysInMonth - currentDate.day + 1
                
                if currentDate.month == 12 {
                    currentDate = NepaliDate(year: currentDate.year + 1, month: 1, day: 1)
                } else {
                    currentDate = NepaliDate(year: currentDate.year, month: currentDate.month + 1, day: 1)
                }
            }
            days += endDate.day - 1
        } else {
            // Backward calculation
            while !(currentDate.year == endDate.year && currentDate.month == endDate.month) {
                days -= currentDate.day
                
                if currentDate.month == 1 {
                    currentDate = NepaliDate(year: currentDate.year - 1, month: 12, day: 1)
                } else {
                    currentDate = NepaliDate(year: currentDate.year, month: currentDate.month - 1, day: 1)
                }
                
                guard let daysInPrevMonth = dataManager.getDaysInMonth(year: currentDate.year, month: currentDate.month) else {
                    break
                }
                
                days -= daysInPrevMonth - 1
                currentDate = NepaliDate(year: currentDate.year, month: currentDate.month, day: daysInPrevMonth)
            }
            days -= (currentDate.day - endDate.day)
        }
        
        return days
    }
}
