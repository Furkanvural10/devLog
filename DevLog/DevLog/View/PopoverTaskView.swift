

import SwiftUI
import FirebaseFirestore

enum TaskType: String {
    case feature = "Feature"
    case bug = "Bug"
    case daily = "Daily"
}

struct PopoverTaskView: View {
    
    @State private var lastProject: String = UserDefaults.standard.string(forKey: "lastSelectedProject") ?? ""

    @State var isSelected = false
    @State private var isCompleted = false
    @State private var isRequestNewProject = false
    @State private var isSelectedProject = false
    
    @State private var selectedTask: TaskType = .feature
    @State private var addNewTaskText: String = ""
    @State private var addNewProjectText: String = ""
    
    @State var featureItemList: [FeatureTask] = []
    @State var bugItemList: [BugTask] = []
    @State var dailyItemList: [DailyTask] = []
    @State var projects: [String] = []
    
    @State var showingList: [String] = []
    @State private var hoveredItem: TaskType = .feature
    @State private var plusHoveredItem: Bool = false
    @State private var isProjectExist: Bool = false
    @State var title: String = ""
    @State var selectedProject: String = "Welcome"
    @State var menuTitle1: String = "Choose Project"
    @State var menuTitle2: String = "Add Project"
    @State var taskTextFieldPlaceholder: String = "Add Task +"
    
    
    @StateObject var viewModel = PopoverViewModel()
    
    @FocusState private var focused: Bool
    @FocusState private var focusedProject: Bool
    
    @State var shortString = true
    
    
    var body: some View {
        
        
        VStack(spacing: 5) {
            HStack {
                Text(shortString ? "Welcome" : selectedProject)
                    .animation(.easeInOut(duration: 0.6))
                    .font(.title2)
                    .padding()
                    .onAppear {
                        print("Selected project: \(selectedProject)")
                        selectedProject = lastProject
                        viewModel.getAllProject()
                        viewModel.getFeatureTask(taskType: .feature, projectName: selectedProject)
//                        viewModel.getFeatureTask(taskType: .feature, projectName: lastProject)
                        showingList = viewModel.featureTaskList.map({ $0.task })
                        // TODO: - ViewModel
                        viewModel.allProjectList.count > 0 ? isProjectExist.toggle() : nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            shortString.toggle()
                        }
                    }
                Spacer()
                isRequestNewProject ? AnyView(
                    HStack {
                        TextField("New Project", text: $addNewProjectText) { text in
                            
                        }
                        .frame(width: 150)
                        .focused($focusedProject)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .onSubmit {
                            viewModel.addProject(addNewProjectText)
                            selectedProject = addNewProjectText
                            addNewProjectText = ""
                            viewModel.getAllProject()
                            
                            isRequestNewProject.toggle()
                        }
                        Image(systemName: addNewProjectText.count > 0 ? "plus" : "multiply")
                            .padding(.trailing, 9)
                            .onTapGesture {
                                addNewProjectText.count > 0 ? viewModel.addProject(addNewProjectText) :  isRequestNewProject.toggle()
                            }
                    }
                )
                : AnyView (
                    Menu("Select Project") {
                        ForEach(viewModel.allProjectList, id: \.self) { project in
                            Button(project) {
                                self.selectedProject = project
                                print("\(project) Tab")
                                // TODO: - Son seçilen uygulamayı userdefaults'a kaydet
                                viewModel.saveLastSelectedProject(projectName: self.selectedProject)
                            }
                            .keyboardShortcut(.init(project.first!))
                            
                        }
                        Divider()
                        Button("Add New Project") {
                            isRequestNewProject.toggle()
                            focusedProject.toggle()
                        }
                        .keyboardShortcut("N", modifiers: [.command])
                    }
                        .frame(width: 135, height: 20)
                        .padding()
                        .cornerRadius(5)
                        .opacity(!shortString ? 0.9 : 0)
                    
                )
            }
            
            HStack(spacing: 10) {
                ZStack {
                    Rectangle()
                        .fill(selectedTask == .feature ? .white.opacity(0.1) : Color.clear)
                        .background(hoveredItem == .feature ? .white.opacity(0.05): Color.clear)
                        .frame(width: 100, height: 35)
                        .cornerRadius(10)
                    HStack {
                        
                        Image(systemName: "circle.fill")
                            .foregroundStyle(.green)
                        Text("Features")
                            .foregroundStyle(selectedTask == .feature ? .white : .white.opacity(0.5))
                    }
                }
                
                .onHover(perform: { hovering in
                    switch hovering {
                    case true:
                        self.hoveredItem = .feature
                    case false:
                        self.hoveredItem = selectedTask
                    }
                })
                .onTapGesture {
                    print("Feature tıklandı")
                    self.selectedTask = .feature
                    self.hoveredItem = .feature
                    viewModel.getFeatureTask(taskType: .feature, projectName: selectedProject)
                    //                    showingList = featureItemList
                    //                    featureItemList = viewModel.featureTaskList
                    showingList = viewModel.featureTaskList.map({ $0.task })
                    //                    print("showingList: \(showingList)")
                }
                
                
                ZStack {
                    Rectangle()
                        .fill(selectedTask == .bug ? .white.opacity(0.1) : Color.clear)
                        .background(hoveredItem == .bug ? .white.opacity(0.05): Color.clear)
                        .frame(width: 100, height: 35)
                        .cornerRadius(10)
                    HStack {
                        
                        Image(systemName: "circle.fill")
                            .foregroundStyle(.red)
                        Text("Bugs")
                            .foregroundStyle(selectedTask == .bug ? .white : .white.opacity(0.5))
                    }
                }
                .onHover(perform: { hovering in
                    switch hovering {
                    case true:
                        hoveredItem = .bug
                    case false:
                        hoveredItem = selectedTask
                    }
                })
                .onTapGesture {
                    print("Bug tıklandı")
                    self.selectedTask = .bug
                    self.hoveredItem = .bug
                    
                    bugItemList = viewModel.bugTaskList
                    showingList = bugItemList.map({ $0.task })
                }
                
                ZStack {
                    Rectangle()
                        .fill(selectedTask == .daily ? .white.opacity(0.1) : Color.clear)
                        .background(hoveredItem == .daily ? .white.opacity(0.05): Color.clear)
                        .frame(width: 100, height: 35)
                        .cornerRadius(10)
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundStyle(.orange)
                        Text("Daily")
                            .foregroundStyle(selectedTask == .daily ? .white : .white.opacity(0.5))
                        
                    }
                }
                .keyboardShortcut("B", modifiers: [.command, .shift, .control])
                .onHover(perform: { hovering in
                    switch hovering {
                    case true:
                        hoveredItem = .daily
                    case false:
                        hoveredItem = selectedTask
                    }
                })
                .onTapGesture {
                    print("Daily Tıklandı")
                    //                    self.viewModel.getTask(taskType: .bug, projectName: selectedProject)
                    self.selectedTask = .daily
                    self.hoveredItem = .daily
                    //                    dailyItemList = viewModel.dailyTaskList
                    //                    showingList = dailyItemList.map({ $0.task })
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
                    .frame(width: 30, height: 30)
                    .foregroundStyle(plusHoveredItem ? .white.opacity(0.1) : .clear)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(.trailing, 8)
                
                
                Image(systemName: "plus")
                    .padding(.trailing, 8)
                    .onTapGesture {
                        // Item added
                        projects.count > 0 ? viewModel.saveTask(selectedTask, addNewTaskText) : nil
                        addNewTaskText = ""
                    }
                
            }
            .onHover { hovering in
                switch hovering {
                case true:
                    plusHoveredItem.toggle()
                case false:
                    plusHoveredItem.toggle()
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
            }.padding(.vertical, 119.5)
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
