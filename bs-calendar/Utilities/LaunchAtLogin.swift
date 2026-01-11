//
//  LaunchAtLogin.swift
//  bs-calendar
//
//  Created by Ashik Chapagain on 11/01/2026.
//

import Foundation
import ServiceManagement

class LaunchAtLogin {
    static let shared = LaunchAtLogin()
    
    private init() {}
    
    var isEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "launchAtLogin")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "launchAtLogin")
            
            if #available(macOS 13.0, *) {
                if newValue {
                    try? SMAppService.mainApp.register()
                } else {
                    try? SMAppService.mainApp.unregister()
                }
            }
        }
    }
}
