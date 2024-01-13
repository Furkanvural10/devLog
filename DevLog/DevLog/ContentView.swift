////
////  ContentView.swift
////  DevLog
////
////  Created by furkan vural on 10.01.2024.
////
//
//import SwiftUI
//
//struct MainPageView: View {
//    @State private var selectedSize: SideOfTheForce = .features
//    @State private var searchText = ""
//    let fakeData = ["Verilerin değişimini tamamla", "Item 2", "Item 3", "Item 4", "Item 5","Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
//    
//    var body: some View {
//        VStack {
//            
//            Picker("", selection: $selectedSize) {
//                ForEach(SideOfTheForce.allCases, id: \.self) {
//                    Text($0.rawValue)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 1)
//            
//            List(fakeData, id: \.self) { item in
//                HStack {
//                    Text(item)
//                        .padding(8)
//                        .background(Color.gray.opacity(0.1)) //
//                        .cornerRadius(5)
//                    Image(systemName: "checkmark.circle")
//                        .foregroundStyle(.blue)
//                }
//            }
//            .foregroundStyle(.white.opacity(0.8))
//            .clipShape(RoundedRectangle(cornerRadius: 5))
//            .listStyle(PlainListStyle())
//            
//
//            HStack {
//                
//                TextField("Search", text: $searchText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                Spacer()
//                Spacer()
//                Button("Add") {
////                    TODO: Save db
//                }
//            }
//
//        }
//        .padding()
//    }
//}
//
//enum SideOfTheForce: String, CaseIterable {
//    case features = "Feature"
//    case bugs = "Bugs"
//    case call = "Call"
//}
//
//#Preview {
//    MainPageView()
//        .frame(width: 300, height: 100)
//}
