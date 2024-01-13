//
//  PopoverTaskView.swift
//  DevLog
//
//  Created by furkan vural on 13.01.2024.
//

import SwiftUI

struct PopoverTaskView: View {
    var body: some View {
        VStack(spacing: 16) {
            VStack {
                Text("25 Ocak Pazartesi").font(.largeTitle)
                Divider()
                Button("Quit") {
                    NSApp.terminate(self)
                }
            }
        }
    }
}

#Preview {
    PopoverTaskView()
}
