import SwiftUI
import FirebaseFirestore

struct PopoverTaskView: View {
    
    @State var isSelected = false
    @State private var isCompleted = false
    
    @State private var selectedItem: Int = 0
    @State private var text: String = ""
    
// MARK: - Mock List Data
    @State var featureItemList = ["Feature Item 1", "Feature Item 2", "Feature Item 3", "Feature Item 4", "Feature Item 5"]
    @State var bugItemList = ["Bug Item 1", "Bug Item 2", "Bug Item 3", "Bug Item 4", "Bug Item 5"]
    @State var dailyItemList = ["Daily Item 1", "Daily Item 2", "Daily Item 3", "Daily Item 4", "Daily Item 5"]
    
    @State var showingList: [String] = []
    @State private var hoveredItem: Int = 0
    @State var title: String = ""
    
    @FocusState private var focused: Bool
    
    
    
    var body: some View {
        
        VStack(spacing: 5) {
            Text(title)
                .font(.headline)
                .padding()
                .onAppear {
                    // Move VM ***
                    let today = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEEE, MMM d"
                    formatter.locale = Locale(identifier: "tr_TR")
                    let dateString = formatter.string(from: today)
                    title = dateString
                    
                    let database = Firestore.firestore()
                    database.collection("daily").getDocuments { snapshot, error in
                        guard error == nil else {
                            print("Error getting documents: \(error!)")
                            return
                        }

                        dailyItemList = snapshot?.documents.compactMap { document in
                            do {
                                let item = try document.data(as: DailyTask.self)
                                return item
                            } catch {
                                print("Error decoding document: \(error)")
                                return nil
                            }
                        } as? [String] ?? []
                    }
                    
                    
                }
            
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
            TextField("New Task", text: $text) { text in
                print($text)
            }
            .focused($focused)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 10)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.focused = false
                }
            }

            
            ZStack {
                Rectangle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle( hoveredItem == 3 ? .white.opacity(0.1) : .clear)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(.trailing, 8)
                
                Image(systemName: "plus")
                    .padding(.trailing, 8)
                    .onTapGesture {
                        // TODO: (Add item to relevant list
//                        DispatchQueue.main.async {
//                            showingList.insert("New value", at: 0)
//                        }
                        print(text)
                    }
            }
            .onHover { hovering in
                switch hovering {
                case true:
                    self.hoveredItem = 3
                case false:
                    self.hoveredItem = selectedItem
                }
                
            }
            
            
        }
        .padding(8)
        
        showingList.isEmpty ?
        AnyView(
            
            
            HStack(spacing: 5) {
                Text("Task Eklenmedi")
                    .foregroundStyle(.white.opacity(0.5))
                    .font(.system(size: 18))
                
                Image(systemName: "exclamationmark.circle")
                    .foregroundStyle(.white.opacity(0.5))
                    .font(.system(size: 15))
            }.padding(.vertical, 118)
        )
        
        : AnyView(
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
        )
        
    }
}

//#Preview {
//    PopoverTaskView()
//}
