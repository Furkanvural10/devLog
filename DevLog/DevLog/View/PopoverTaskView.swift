#warning("Fix hard coded")

import SwiftUI
import FirebaseFirestore

struct PopoverTaskView: View {
    
    @State var isSelected = false
    @State private var isCompleted = false
    @State private var isRequestNewProject = false
    @State private var isSelectedProject = false
    
    @State private var selectedItem: Int = 0
    @State private var addNewTaskText: String = ""
    @State private var addNewProjectText: String = ""
    
    @State var featureItemList: [FeatureTask] = []
    @State var bugItemList: [BugTask] = []
    @State var dailyItemList: [DailyTask] = []
    
    @State var showingList: [String] = []
    @State private var hoveredItem: Int = 0
    @State var title: String = ""
    @State var selectedProject: String = "DevLog"
    
    @StateObject var viewModel = PopoverViewModel()
    
    @FocusState private var focused: Bool
    
    @State var shortString = true
    
    
    var body: some View {
        
        VStack(spacing: 5) {
            
            
            HStack {
                Text(shortString ? "Welcome" : selectedProject)
                    .animation(.easeInOut(duration: 0.6))
                    .font(.title2)
                    .padding()
                    .onAppear {
                        viewModel.getFeatureTask()
                        viewModel.getBugTask()
                        viewModel.getDailyTask()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            shortString.toggle()
                        }
                        
                    }
                
                Spacer()
                
                
                isRequestNewProject ? AnyView(
                    HStack {
                        TextField("New Project", text: $addNewProjectText) { text in
                            
                        }
                        .frame(width: 150)
                        .focused($focused)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal, 2)
                        
                        
                        Image(systemName: "multiply")
                            .padding(.trailing, 9)
                            .onTapGesture {
                                isRequestNewProject = false
                            }
                        
                        
                    }
                )
                : AnyView (
                    Menu("Choose Project") {
                        Button("Psytudents") {
                            self.selectedProject = "Psytundets"
                        }
                        .keyboardShortcut("1", modifiers: [.command])
                        Button("Stat-ion") {
                            print("Stat-ion Tab")
                            self.selectedProject = "Stat-ion"
                        }
                        .keyboardShortcut("2", modifiers: [.command])
                        Button("DevLog") {
                            print("DevLog Tab")
                            self.selectedProject = "DevLog"
                        }
                        .keyboardShortcut("3", modifiers: [.command])
                        Divider()
                        Button("Add New Project") {
                            isRequestNewProject = true
                        }
                        .keyboardShortcut("N", modifiers: [.command])
                    }
                        .frame(width: 135, height: 20)
                        .padding()
                        .cornerRadius(5)
                        .opacity(!shortString ? 0.5 : 0)
                        .animation(.easeInOut(duration: 1))
                    
                    
                )
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
                    //                    showingList = featureItemList
                    featureItemList = viewModel.featureTaskList
                    showingList = viewModel.featureTaskList.map({ $0.task })
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
                    bugItemList = viewModel.bugTaskList
                    showingList = bugItemList.map({ $0.task })
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
                .keyboardShortcut("B", modifiers: [.command, .shift, .control])
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
                    dailyItemList = viewModel.dailyTaskList
                    showingList = dailyItemList.map({ $0.task })
                }
            }
        }
        
        
        HStack {
            TextField("New Task", text: $addNewTaskText) { text in
                
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
                                    
                                }
                            Text(item)
                                .strikethrough(isCompleted, color: .gray)
                                .contextMenu {
                                    Button("Delete") {
                                        if let index = showingList.firstIndex(of: item) {
                                            showingList.remove(at: index)
                                        }
                                    }
                                }
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
