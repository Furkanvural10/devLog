//
//  PopoverTaskView.swift
//  DevLog
//
//  Created by furkan vural on 13.01.2024.
//

import SwiftUI

struct PopoverTaskView: View {
    
    @State var isSelected = false
    @State private var selectedItem: Int?
    @State var addText = ""
    @State var itemList = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5","Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    
    
    var body: some View {
        VStack(spacing: 5) {
            Text("14 Ocak Pazartesi")
                .font(.headline)
                .padding()
            
            HStack(spacing: 10) {
                ZStack {
                    Rectangle()
                        .fill(selectedItem == 0 ? .white.opacity(0.1) : Color.clear)
                    
                        .frame(width: 100, height: 35)
                        .cornerRadius(10)
                    HStack {
                        Text("Features")
                        Image(systemName: "list.star")
                            .foregroundStyle(.green)
                    }
                    .onTapGesture {
                        self.selectedItem = 0
                        
                    }
                }
                ZStack {
                    Rectangle()
                        .fill(selectedItem == 1 ? .white.opacity(0.1) : Color.clear)
                        .frame(width: 100, height: 35)
                        .cornerRadius(10)
                    HStack {
                        Text("Bugs")
                        Image(systemName: "exclamationmark.octagon.fill")
                            .foregroundStyle(.red)
                        
                    }
                }
                .onTapGesture {
                    print("Tıklandı")
                    self.selectedItem = 1
                }
                
                ZStack {
                    Rectangle()
                        .fill(selectedItem == 2 ? .white.opacity(0.1) : Color.clear)
                        .frame(width: 100, height: 35)
                        .cornerRadius(10)
                    HStack {
                        Text("Daily")
                        Image(systemName: "circle.hexagongrid")
                            .foregroundStyle(.orange)
                        
                    }
                }
                .onTapGesture {
                    print("Bugs Tıklandı")
                    self.selectedItem = 2
                }
            }
            
            HStack {
                TextField("New Task", text: .constant("")) { text in
                    print(addText)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 10)
                
                
                
                Button {
                    print("Clicked")
                    self.itemList.insert("New elemen", at: 0)
                } label: {
                    Text("Add")
                }
                .padding(.trailing, 10)
                .foregroundStyle(.red)
                .buttonStyle(.bordered)
                
            }
            .padding(8)
            List {
                ForEach(itemList, id: \.self) { item in
                    HStack {
                        Toggle("", isOn: $isSelected)
                            .toggleStyle(.automatic)
                        ZStack {
                            Rectangle()
                                .frame(height: 40)
                                .foregroundStyle(.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            Image(systemName: "multiply.circle")
                                .foregroundColor(.white.opacity(0.3))
                                .padding(4)
                                .clipShape(Circle())
                                .offset(x: 125, y: -17)
                            Text(item)
                        }
                        Rectangle()
                            .frame(width: 10, height: 10)
                            .hidden()
                    }
                }
            }
            .scrollIndicators(.never)
            
        }
        
    }
}

#Preview {
    PopoverTaskView()
}
