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
    @State private var launchAtLogin = LaunchAtLogin.shared.isEnabled
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            generalTab
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(0)
            
            aboutTab
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
                .tag(1)
        }
        .frame(width: 450, height: 380)
    }
    
    private var generalTab: some View {
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
                
                Section(header: Text("Startup").font(.headline)) {
                    Toggle("Launch at Login", isOn: $launchAtLogin)
                        .help("Start BS Calendar automatically when you log in")
                        .onChange(of: launchAtLogin) { newValue in
                            LaunchAtLogin.shared.isEnabled = newValue
                        }
                }
            }
            .formStyle(.grouped)
            .padding()
        }
    }
    
    private var aboutTab: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 64))
                .foregroundColor(.accentColor)
                .padding(.top, 40)
            
            Text("BS Calendar")
                .font(.system(size: 24, weight: .semibold))
            
            Text("Version 1.0")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("A lightweight menu bar app for")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                Text("displaying Bikram Sambat (Nepali) dates")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 4)
            
            Spacer()
            
            HStack(spacing: 20) {
                Link(destination: URL(string: "https://github.com")!) {
                    Label("GitHub", systemImage: "arrow.up.forward.square")
                        .font(.system(size: 12))
                }
                
                Button("Quit BS Calendar") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.bordered)
            }
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
