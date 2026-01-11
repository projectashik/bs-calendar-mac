//
//  bs_calendarApp.swift
//  bs-calendar
//
//  Created by Ashik Chapagain on 11/01/2026.
//

import SwiftUI

@main
struct bs_calendarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarController = StatusBarController()
        
        NSApp.setActivationPolicy(.accessory)
    }
}
