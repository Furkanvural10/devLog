//
//  AppDelegate.swift
//  DevLog
//
//  Created by furkan vural on 13.01.2024.
//

import Foundation
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem!
    var popover = NSPopover()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        setupPopover()
    }
}

// MARK: - Menu Bar

extension AppDelegate {
    
    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength) // 64
        guard let menuButton = statusItem.button else { return }
        menuButton.image = NSImage(named: "DevLog")
        
        menuButton.action = #selector(menuButtonClicked)
        
    }
    
    @objc func menuButtonClicked() {
        if popover.isShown {
            popover.performClose(nil)
            return
        }
        
        guard let menuButton = statusItem.button else { return }
        
        popover.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .maxY)
        popover.contentViewController?.view.window?.makeKey()
        
        
    }
}

// MARK: - POPOVER
extension AppDelegate {
    
    func setupPopover() {
        popover.behavior = .transient
        popover.animates = true
        popover.contentSize = .init(width: 240, height: 200)
//        popover.contentViewController = NSViewController()
        
    }
    
}
