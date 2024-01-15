//
//  PopoverTaskView.swift
//  DevLog
//
//  Created by furkan vural on 13.01.2024.
//

import SwiftUI

struct PopoverTaskView: View {
    @State var selectedItem = false
    @State var addText = ""
    let itemList = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5","Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]

    
    var body: some View {
        VStack(spacing: 5) {
            Text("14 Ocak Pazartesi")
                .font(.headline)
                .padding()
                
            HStack(spacing: 10) {
                ZStack {
                    Rectangle()
                        .fill(selectedItem == true ? .black.opacity(0.15) : .black.opacity(0))
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
                        .fill(selectedItem == true ? .black.opacity(0.15) : .black.opacity(0))
                        .frame(width: 100, height: 35)
                        .cornerRadius(10)
                    HStack {
                        Image(systemName: "exclamationmark.octagon.fill")
                            .foregroundStyle(.red)
                        Text("Bugs")
                    }
                }
                .onTapGesture {
                    print("Tıklandı")
                    self.selectedItem = !selectedItem
                }
                
                ZStack {
                    Rectangle()
                        .fill(selectedItem == true ? .black.opacity(0.15) : .black.opacity(0))
                        .frame(width: 100, height: 35)
                        .cornerRadius(10)
                    HStack {
                        Image(systemName: "circle.hexagongrid")
                            .foregroundStyle(.orange)
                        Text("Daily")
                    }
                }
            }
//            .padding()
            
            Divider()
            HStack {
                TextField("Add", text: $addText) { text in
                    print(addText)
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding(5)
                Button("Add") {
                    
                }
            }
            List {
                ForEach(itemList, id: \.self) { item in
                    ZStack {
                        Rectangle()
                            .frame(width: .infinity, height: 40)
                            .foregroundStyle(.black.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        Text(item)
                    }
                }
            }
            .scrollIndicators(.hidden)
            
        }
        
    }
}

#Preview {
    PopoverTaskView()
}
