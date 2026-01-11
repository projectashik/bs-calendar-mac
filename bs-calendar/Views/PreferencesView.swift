//
//  PreferencesView.swift
//  bs-calendar
//
//  Created by Ashik Chapagain on 11/01/2026.
//

import SwiftUI

struct PreferencesView: View {
    @AppStorage("useNepaliNumerals") private var useNepaliNumerals = true
    @AppStorage("showMonthInMenuBar") private var showMonthInMenuBar = false
    @AppStorage("weekStartDay") private var weekStartDay = 0
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    
    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section(header: Text("Display").font(.headline).padding(.top, 12)) {
                    Toggle("Use Nepali Numerals", isOn: $useNepaliNumerals)
                        .help("Display numbers in Devanagari script (०१२३)")
                    
                    Toggle("Show Month Name in Menu Bar", isOn: $showMonthInMenuBar)
                        .help("Display full month name instead of just the date")
                }
                .padding(.bottom, 8)
                
                Section(header: Text("Calendar").font(.headline)) {
                    Picker("Week Starts On:", selection: $weekStartDay) {
                        Text("Sunday").tag(0)
                        Text("Monday").tag(1)
                    }
                    .pickerStyle(.radioGroup)
                }
                .padding(.bottom, 8)
                
                Section(header: Text("General").font(.headline)) {
                    Toggle("Launch at Login", isOn: $launchAtLogin)
                        .help("Start BS Calendar automatically when you log in")
                }
            }
            .formStyle(.grouped)
            .padding()
            
            Divider()
            
            HStack {
                Text("BS Calendar v1.0")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .frame(width: 420, height: 340)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
