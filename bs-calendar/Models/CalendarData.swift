//
//  CalendarData.swift
//  bs-calendar
//
//  Created by Ashik Chapagain on 11/01/2026.
//

import Foundation

struct CalendarDataModel: Codable {
    let description: String
    let years: [String: [Int]]
    let referenceDate: ReferenceDate
    let monthNames: MonthNames
    let weekDays: WeekDays
    
    struct ReferenceDate: Codable {
        let bs: DateComponents
        let ad: DateComponents
        
        struct DateComponents: Codable {
            let year: Int
            let month: Int
            let day: Int
        }
    }
    
    struct MonthNames: Codable {
        let nepali: [String]
        let english: [String]
    }
    
    struct WeekDays: Codable {
        let nepali: [String]
        let english: [String]
    }
}

class CalendarDataManager {
    static let shared = CalendarDataManager()
    private var calendarData: CalendarDataModel?
    
    private init() {
        loadCalendarData()
    }
    
    private func loadCalendarData() {
        guard let url = Bundle.main.url(forResource: "CalendarData", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(CalendarDataModel.self, from: data) else {
            return
        }
        calendarData = decoded
    }
    
    func getDaysInMonth(year: Int, month: Int) -> Int? {
        guard let days = calendarData?.years[String(year)],
              month >= 1 && month <= 12 else {
            return nil
        }
        return days[month - 1]
    }
    
    func getMonthName(month: Int, nepali: Bool = true) -> String {
        guard let data = calendarData,
              month >= 1 && month <= 12 else {
            return ""
        }
        return nepali ? data.monthNames.nepali[month - 1] : data.monthNames.english[month - 1]
    }
    
    func getWeekDayName(index: Int, nepali: Bool = true) -> String {
        guard let data = calendarData,
              index >= 0 && index < 7 else {
            return ""
        }
        return nepali ? data.weekDays.nepali[index] : data.weekDays.english[index]
    }
    
    func getReferenceDate() -> (bs: NepaliDate, ad: Date)? {
        guard let data = calendarData else { return nil }
        
        let bsDate = NepaliDate(
            year: data.referenceDate.bs.year,
            month: data.referenceDate.bs.month,
            day: data.referenceDate.bs.day
        )
        
        var components = DateComponents()
        components.year = data.referenceDate.ad.year
        components.month = data.referenceDate.ad.month
        components.day = data.referenceDate.ad.day
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        guard let adDate = Calendar.current.date(from: components) else {
            return nil
        }
        
        return (bsDate, adDate)
    }
}
