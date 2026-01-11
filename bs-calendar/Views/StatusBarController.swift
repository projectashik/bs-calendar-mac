//
//  StatusBarController.swift
//  bs-calendar
//
//  Created by Ashik Chapagain on 11/01/2026.
//

import AppKit
import SwiftUI
import Combine

class StatusBarController: ObservableObject {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    @Published var isPopoverShown = false
    
    init() {
        setupStatusItem()
        setupPopover()
        updateMenuBarTitle()
        startTimer()
        observePreferences()
    }
    
    private func observePreferences() {
        NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateMenuBarTitle()
        }
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.action = #selector(handleClick(_:))
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }
    
    @objc func handleClick(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        
        if event.type == .rightMouseUp {
            showMenu()
        } else {
            togglePopover()
        }
    }
    
    private func showMenu() {
        let menu = NSMenu()
        
        let preferencesItem = NSMenuItem(title: "Preferences...", action: #selector(openPreferences), keyEquivalent: ",")
        preferencesItem.target = self
        menu.addItem(preferencesItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit BS Calendar", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }
    
    @objc func openPreferences() {
        let preferencesView = PreferencesView()
        let hostingController = NSHostingController(rootView: preferencesView)
        
        let window = NSWindow(contentViewController: hostingController)
        window.title = "Preferences"
        window.styleMask = [.titled, .closable]
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    private func setupPopover() {
        popover = NSPopover()
        popover.contentSize = NSSize(width: 280, height: 340)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: CalendarView())
    }
    
    func updateMenuBarTitle() {
        guard let todayBS = DateConverter.shared.getTodayBS() else { return }
        
        let useNepaliNumerals = UserDefaults.standard.bool(forKey: "useNepaliNumerals")
        let showMonthName = UserDefaults.standard.bool(forKey: "showMonthInMenuBar")
        
        var title = ""
        if showMonthName {
            title = NepaliFormatter.shared.formatDateWithMonth(todayBS, useNepaliNumerals: useNepaliNumerals)
        } else {
            title = NepaliFormatter.shared.formatShortDate(todayBS, useNepaliNumerals: useNepaliNumerals)
        }
        
        if let button = statusItem.button {
            button.title = title
        }
    }
    
    @objc func togglePopover() {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(nil)
                isPopoverShown = false
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                isPopoverShown = true
                popover.contentViewController?.view.window?.makeKey()
            }
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.checkDateChange()
        }
    }
    
    private func checkDateChange() {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.hour, .minute], from: now)
        
        if components.hour == 0 && components.minute == 0 {
            updateMenuBarTitle()
        }
    }
}
