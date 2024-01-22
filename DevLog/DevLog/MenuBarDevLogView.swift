//
//  MenuBarDevLogView.swift
//  DevLog
//
//  Created by furkan vural on 13.01.2024.
//

import SwiftUI

struct MenuBarDevLogView: View {
    var body: some View {
            Image("DevLog")
            .onAppear {
                print("Bir kere gözüktü")
            }
    }
}

#Preview {
    MenuBarDevLogView()
}
