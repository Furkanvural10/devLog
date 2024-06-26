//
//  AppDelegate.swift
//  DevLog
//
//  Created by furkan vural on 13.01.2024.
//

import Cocoa
import Foundation
import SwiftUI
import Firebase
import FirebaseAuth


class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    private lazy var contentView: NSView? = {
        let view = (statusItem.value(forKey: "window") as? NSWindow)?.contentView
        return view
    }()
    
    var popover = NSPopover()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        FirebaseApp.configure()
        setupMenuBar()
        setupPopover()
        createUser()
        
        let accessEnabled = AXIsProcessTrustedWithOptions(
                    [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary)
        
        if accessEnabled {
            NSEvent.addGlobalMonitorForEvents(matching: [.keyDown]) { event in
                if event.modifierFlags.contains([.shift, .command]) && event.keyCode == 17 {
                    self.menuButtonClicked()
                }
            }
        }
        
        
    }
    
    //    @objc func menuButtonClicked() {
    //            if popover.isShown {
    //                popover.performClose(nil)
    //            }
    //        }
}

// MARK: - Menu Bar

extension AppDelegate {
    
    
    private func createUser() {
        
        let currentUser = Auth.auth().currentUser
        guard currentUser == nil else {
            print("App has user \(currentUser!.uid)")
            return
        }
        
        Auth.auth().signInAnonymously { result, error in
            guard error == nil else {
                print("Crate error occurs \(error?.localizedDescription)")
                return
            }
            
            guard let result else {
                print("Result error occurs")
                return
            }
            
            let user = result.user.uid
            print("User created successfully : \(user) ")
            
            
        }
    }
    
    
    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength) // 64
        guard let contentView = self.contentView,
              let menuButton = statusItem.button else { return }
        
        let hostingView = NSHostingView(rootView: MenuBarDevLogView())
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostingView)
        
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
        ])
        
        menuButton.action = #selector(menuButtonClicked)
        
    }
    
    @objc func menuButtonClicked() {
        
        if popover.isShown {
            popover.performClose(nil)
            return
        } else {
            //            guard let menuButton = statusItem.button else { return }
            //            popover.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .maxY)
            
            guard let menuButton = statusItem.button else { return }
            let positionView = NSView(frame: menuButton.bounds)
            positionView.identifier = NSUserInterfaceItemIdentifier(rawValue: "positionView")
            menuButton.addSubview(positionView)
            
            popover.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .maxY)
            menuButton.bounds = menuButton.bounds.offsetBy(dx: 0, dy: menuButton.bounds.height)
            popover.contentViewController?.view.window?.makeKey()
        }
        
        // MARK: - Showing Popover view
        
        
        
    }
}

// MARK: - POPOVER
extension AppDelegate: NSPopoverDelegate {
    
    func setupPopover() {
        popover.behavior = .transient
        popover.animates = true
        popover.contentSize = .init(width: 330, height: 400)
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(
            rootView: PopoverTaskView().frame(maxWidth: .infinity, maxHeight: .infinity).padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
        )
        popover.delegate = self
    }
    
    func popoverDidClose(_ notification: Notification) {
        let positionView = statusItem.button?.subviews.first {
            $0.identifier == NSUserInterfaceItemIdentifier("positionView")
        }
        positionView?.removeFromSuperview()
    }
    
}
