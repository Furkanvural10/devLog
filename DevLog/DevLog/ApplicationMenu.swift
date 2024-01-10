//
//  ApplicationMenu.swift
//  DevLog
//
//  Created by furkan vural on 10.01.2024.
//

import Foundation
import SwiftUI

class ApplicationMenu: NSObject, NSApplicationDelegate {

    let menu = NSMenu()
    
    func createMenu() -> NSMenu {
        let mainView = MainPageView()
        let topView = NSHostingController(rootView: mainView)
        topView.view.frame.size = CGSize(width: 400, height: 300)
        
        let customMenuItem = NSMenuItem()
        customMenuItem.view = topView.view
        menu.addItem(customMenuItem)
        menu.addItem(NSMenuItem.separator())
        
        let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)
        

        return menu
    }
    
    @objc func quit() {
        NSApp.terminate(self)
    }
}
