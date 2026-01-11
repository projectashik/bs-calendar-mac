//
//  CalendarView.swift
//  bs-calendar
//
//  Created by Ashik Chapagain on 11/01/2026.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @AppStorage("useNepaliNumerals") private var useNepaliNumerals = true
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    private let formatter = NepaliFormatter.shared
    private let dataManager = CalendarDataManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            weekDayLabels
            calendarGrid
            footerView
        }
        .padding(12)
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { viewModel.goToPreviousMonth() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            VStack(spacing: 2) {
                Text(dataManager.getMonthName(month: viewModel.currentMonth.month, nepali: useNepaliNumerals))
                    .font(.system(size: 16, weight: .semibold))
                
                Text(useNepaliNumerals ? formatter.toNepaliNumerals(viewModel.currentMonth.year) : String(viewModel.currentMonth.year))
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: { viewModel.goToNextMonth() }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.bottom, 12)
    }
    
    private var weekDayLabels: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(0..<7, id: \.self) { index in
                Text(dataManager.getWeekDayName(index: index, nepali: useNepaliNumerals))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 24)
            }
        }
        .padding(.bottom, 8)
    }
    
    private var calendarGrid: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(viewModel.calendarDays) { day in
                CalendarDayCell(
                    day: day,
                    useNepaliNumerals: useNepaliNumerals,
                    onTap: { viewModel.selectDate(day.bsDate) }
                )
            }
        }
    }
    
    private var footerView: some View {
        HStack {
            Button("Today") {
                viewModel.goToToday()
            }
            .buttonStyle(PlainButtonStyle())
            .font(.system(size: 11))
            .foregroundColor(.accentColor)
            .padding(.vertical, 8)
            
            Spacer()
            
            if let selected = viewModel.selectedDate {
                Text(formatter.formatDate(selected, useNepaliNumerals: useNepaliNumerals))
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.top, 8)
    }
}

struct CalendarDayCell: View {
    let day: CalendarViewModel.CalendarDay
    let useNepaliNumerals: Bool
    let onTap: () -> Void
    
    private let formatter = NepaliFormatter.shared
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text(useNepaliNumerals ? formatter.toNepaliNumerals(day.bsDate.day) : String(day.bsDate.day))
                    .font(.system(size: 13, weight: day.isToday ? .semibold : .regular))
                    .foregroundColor(textColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 32)
            .background(backgroundColor)
            .cornerRadius(6)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if !day.isCurrentMonth {
            return Color.secondary.opacity(0.4)
        } else if day.isToday {
            return .white
        } else if day.isSelected {
            return .primary
        } else {
            return .primary
        }
    }
    
    private var backgroundColor: Color {
        if day.isToday {
            return .accentColor
        } else if day.isSelected {
            return Color.accentColor.opacity(0.2)
        } else {
            return .clear
        }
    }
}
