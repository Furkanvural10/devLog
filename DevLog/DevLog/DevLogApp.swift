//
//  DevLogApp.swift
//  DevLog
//
//  Created by furkan vural on 10.01.2024.
//

import SwiftUI

@main
struct DevLogApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        Settings {
            EmptyView().frame(width: 0, height: 0)
        }
    }
}


