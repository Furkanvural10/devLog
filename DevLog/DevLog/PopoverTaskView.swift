//
//  PopoverTaskView.swift
//  DevLog
//
//  Created by furkan vural on 13.01.2024.
//

import SwiftUI

struct PopoverTaskView: View {
    var body: some View {
        VStack(spacing: 5) {
            Text("14 Ocak Pazartesi")
                
            HStack(spacing: 10) {
                ZStack {
                    Rectangle()
                        .fill(.background.opacity(0.5))
                        .frame(width: 100, height: 35)
                        .cornerRadius(10)
                    HStack {
                        Image(systemName: "list.star")
                            .foregroundStyle(.green)
                        Text("Features")
                    }
                }
                ZStack {
                    Rectangle()
                        .fill(.background.opacity(0.5))
                        .frame(width: 100, height: 35)
                        .cornerRadius(10)
                    HStack {
                        Image(systemName: "exclamationmark.octagon.fill")
                            .foregroundStyle(.red)
                        Text("Bugs")
                    }
                }
                
                ZStack {
                    Rectangle()
                        .fill(.background.opacity(0.5))
                        .frame(width: 100, height: 35)
                        .cornerRadius(10)
                    HStack {
                        Image(systemName: "circle.hexagongrid")
                            .foregroundStyle(.orange)
                        Text("Other")
                    }
                }
            }
            .padding()
            
            Divider()
            Text("Liste görünümü...")
        }
        
    }
}

#Preview {
    PopoverTaskView()
}
