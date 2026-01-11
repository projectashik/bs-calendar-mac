//
//  CalendarViewModel.swift
//  bs-calendar
//
//  Created by Ashik Chapagain on 11/01/2026.
//

import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    @Published var currentMonth: NepaliDate
    @Published var todayDate: NepaliDate
    @Published var selectedDate: NepaliDate?
    @Published var calendarDays: [CalendarDay] = []
    
    private let dataManager = CalendarDataManager.shared
    private let converter = DateConverter.shared
    
    struct CalendarDay: Identifiable {
        let id = UUID()
        let bsDate: NepaliDate
        let adDate: Date
        let isCurrentMonth: Bool
        let isToday: Bool
        let isSelected: Bool
    }
    
    init() {
        let today = converter.getTodayBS() ?? NepaliDate(year: 2083, month: 9, day: 28)
        self.todayDate = today
        self.currentMonth = today
        generateCalendarDays()
    }
    
    func generateCalendarDays() {
        var days: [CalendarDay] = []
        
        guard let daysInMonth = dataManager.getDaysInMonth(year: currentMonth.year, month: currentMonth.month),
              let firstDayOfMonth = NepaliDate(year: currentMonth.year, month: currentMonth.month, day: 1) |> converter.bsToAD,
              let calendar = Calendar.current as Calendar? else {
            return
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let startOffset = (firstWeekday - 1 + 7) % 7
        
        // Previous month days
        if startOffset > 0 {
            let prevMonth = getPreviousMonth(currentMonth)
            if let prevMonthDays = dataManager.getDaysInMonth(year: prevMonth.year, month: prevMonth.month) {
                for day in (prevMonthDays - startOffset + 1)...prevMonthDays {
                    let bsDate = NepaliDate(year: prevMonth.year, month: prevMonth.month, day: day)
                    if let adDate = converter.bsToAD(bsDate) {
                        days.append(CalendarDay(
                            bsDate: bsDate,
                            adDate: adDate,
                            isCurrentMonth: false,
                            isToday: bsDate.isSameDate(as: todayDate),
                            isSelected: selectedDate?.isSameDate(as: bsDate) ?? false
                        ))
                    }
                }
            }
        }
        
        // Current month days
        for day in 1...daysInMonth {
            let bsDate = NepaliDate(year: currentMonth.year, month: currentMonth.month, day: day)
            if let adDate = converter.bsToAD(bsDate) {
                days.append(CalendarDay(
                    bsDate: bsDate,
                    adDate: adDate,
                    isCurrentMonth: true,
                    isToday: bsDate.isSameDate(as: todayDate),
                    isSelected: selectedDate?.isSameDate(as: bsDate) ?? false
                ))
            }
        }
        
        // Next month days
        let remainingDays = 42 - days.count
        if remainingDays > 0 {
            let nextMonth = getNextMonth(currentMonth)
            for day in 1...remainingDays {
                let bsDate = NepaliDate(year: nextMonth.year, month: nextMonth.month, day: day)
                if let adDate = converter.bsToAD(bsDate) {
                    days.append(CalendarDay(
                        bsDate: bsDate,
                        adDate: adDate,
                        isCurrentMonth: false,
                        isToday: bsDate.isSameDate(as: todayDate),
                        isSelected: selectedDate?.isSameDate(as: bsDate) ?? false
                    ))
                }
            }
        }
        
        calendarDays = days
    }
    
    func goToPreviousMonth() {
        currentMonth = getPreviousMonth(currentMonth)
        generateCalendarDays()
    }
    
    func goToNextMonth() {
        currentMonth = getNextMonth(currentMonth)
        generateCalendarDays()
    }
    
    func goToToday() {
        currentMonth = todayDate
        selectedDate = todayDate
        generateCalendarDays()
    }
    
    func selectDate(_ date: NepaliDate) {
        selectedDate = date
        generateCalendarDays()
    }
    
    private func getPreviousMonth(_ date: NepaliDate) -> NepaliDate {
        if date.month == 1 {
            return NepaliDate(year: date.year - 1, month: 12, day: 1)
        } else {
            return NepaliDate(year: date.year, month: date.month - 1, day: 1)
        }
    }
    
    private func getNextMonth(_ date: NepaliDate) -> NepaliDate {
        if date.month == 12 {
            return NepaliDate(year: date.year + 1, month: 1, day: 1)
        } else {
            return NepaliDate(year: date.year, month: date.month + 1, day: 1)
        }
    }
}

infix operator |> : MultiplicationPrecedence
func |><T, U>(value: T, transform: (T) -> U) -> U {
    return transform(value)
}
