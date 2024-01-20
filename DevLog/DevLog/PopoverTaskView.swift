//
//  PopoverTaskView.swift
//  DevLog
//
//  Created by furkan vural on 13.01.2024.
//

import SwiftUI

struct PopoverTaskView: View {
    
    @State var isSelected = false
    @State private var isCompleted = false

    @State private var selectedItem: Int = 0
    @State var addText = ""
    @State var featureItemList = ["Feature Item 1", "Feature Item 2", "Feature Item 3", "Feature Item 4", "Feature Item 5"]
    @State var bugItemList = ["Bug Item 1", "Bug Item 2", "Bug Item 3", "Bug Item 4", "Bug Item 5"]
    @State var dailyItemList = ["Daily Item 1", "Daily Item 2", "Daily Item 3", "Daily Item 4", "Daily Item 5"]
    
    @State var showingList: [String] = []
    @State private var hoveredItem: Int = 0

    
    var body: some View {
        VStack(spacing: 5) {
            Text("14 Ocak Pazartesi")
                .font(.headline)
                .padding()
            
            HStack(spacing: 10) {
                ZStack {
                    Rectangle()
                        .fill(selectedItem == 0 ? .white.opacity(0.1) : Color.clear)
                        .background(hoveredItem == 0 ? .white.opacity(0.05): Color.clear)
                        .frame(width: 100, height: 35)
                        .cornerRadius(10)
                    HStack {
                        
                        Image(systemName: "circle.fill")
                            .foregroundStyle(.green)
                        Text("Features")
                            .foregroundStyle(selectedItem == 0 ? .white : .white.opacity(0.5))
                    }
                }
                .onHover(perform: { hovering in
                    switch hovering {
                    case true:
                        self.hoveredItem = 0
                    case false:
                        self.hoveredItem = selectedItem
                    }
                })
                .onTapGesture {
                    self.selectedItem = 0
                    self.hoveredItem = 0
                    showingList = featureItemList
                }
                ZStack {
                    Rectangle()
                        .fill(selectedItem == 1 ? .white.opacity(0.1) : Color.clear)
                        .background(hoveredItem == 1 ? .white.opacity(0.05): Color.clear)
                        .frame(width: 100, height: 35)
                        .cornerRadius(10)
                    HStack {
                        
                        Image(systemName: "circle.fill")
                            .foregroundStyle(.red)
                        Text("Bugs")
                            .foregroundStyle(selectedItem == 1 ? .white : .white.opacity(0.5))
                        
                    }
                }
                .onHover(perform: { hovering in
                    switch hovering {
                    case true:
                        hoveredItem = 1
                    case false:
                        hoveredItem = selectedItem
                    }
                })
                .onTapGesture {
                    print("Tıklandı")
                    self.selectedItem = 1
                    self.hoveredItem = 1
                    showingList = bugItemList
                }
                
                ZStack {
                    Rectangle()
                        .fill(selectedItem == 2 ? .white.opacity(0.1) : Color.clear)
                        .background(hoveredItem == 2 ? .white.opacity(0.05): Color.clear)
                        .frame(width: 100, height: 35)
                        .cornerRadius(10)
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundStyle(.orange)
                        Text("Daily")
                            .foregroundStyle(selectedItem == 2 ? .white : .white.opacity(0.5))
                        
                    }
                }
                .onHover(perform: { hovering in
                    switch hovering {
                    case true:
                        hoveredItem = 2
                    case false:
                        hoveredItem = selectedItem
                    }
                })
                .onTapGesture {
                    print("Bugs Tıklandı")
                    self.selectedItem = 2
                    self.hoveredItem = 2
                    showingList = dailyItemList
                }
            }
        }
        
        
        HStack {
            TextField("New Task", text: $addText) { text in
                print(addText)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 10)
            
            Image(systemName: "plus")
                .padding(.trailing, 8)
                .onTapGesture {
                    // TODO: (Add item to relevant list
                }
            
            
            
            
//            Button {
//                print("Clicked")
//                self.itemList.insert("New elemen", at: 0)
//            } label: {
//                Text("Add")
//            }
//            .padding(.trailing, 10)
//            .foregroundStyle(.red)
//            .buttonStyle(.bordered)
            
        }
        .padding(8)
        
        
        List {
            ForEach(showingList, id: \.self) { item in
                HStack {
                    Toggle("", isOn: $isCompleted)
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
                            .onTapGesture {
                                print("Clicked text delete")
                            }
                        Text(item)
                            .strikethrough(isCompleted, color: .gray)
                    }
                    Rectangle()
                        .frame(width: 5, height: 5)
                        .hidden()
                }
            }
        }
        .scrollIndicators(.never)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    PopoverTaskView()
}
