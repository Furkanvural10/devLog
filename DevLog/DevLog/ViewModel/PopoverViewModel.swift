import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase


protocol PopoverViewModelProtocol {
    func getTask<T: Codable>(taskType: TaskType, projectName: String, completion: @escaping (Result<T, Error>?) -> Void)
}

final class PopoverViewModel: ObservableObject {
    
    @Published var featureTaskList = [FeatureTask]()
    @Published var bugTaskList = [BugTask]()
    @Published var dailyTaskList = [DailyTask]()
    @Published var allProjectList = [String]()
    @Published var errorMessage = ""
    @Published var lastSelectedProject = ""
    @Published var showingList = [String]()
    
    private let database = Firestore.firestore()
    private let userID = Auth.auth().currentUser?.uid
    
    
    init() {}
    
    func getAllProject() {
        
        allProjectList.removeAll(keepingCapacity: false)
        guard let userID else { return }
        let projectsRef = database.collection("users").document(userID).collection("Project")
        
        projectsRef.getDocuments { (querySnapshot, error) in
            guard error == nil else { return }
            for document in querySnapshot!.documents {
                self.allProjectList.append(document.documentID)
            }
        }
    }
    
    
    func getFeatureTask(taskType: TaskType, projectName: String) {

        self.featureTaskList.removeAll(keepingCapacity: false)
        GetTask.shared.getFeatureTask(taskType: taskType, projectName: projectName) { result in
            
            switch result {
            case .success(let success):
                self.featureTaskList.append(success)
                self.showingList = self.featureTaskList.map({ $0.task })
            case .failure(let failure):
                self.errorMessage = "\(failure)"
                print(self.errorMessage)
//                if failure.localizedDescription == "The data couldn’t be read because it is missing." {
//                    self.showingList.removeAll(keepingCapacity: false)
//                }
            }
        }
    }
    
    func getBugTask(taskType: TaskType, projectName: String) {

        self.bugTaskList.removeAll(keepingCapacity: false)
        GetTask.shared.getBugTask(taskType: taskType, projectName: projectName) { result in
            
            switch result {
            case .success(let success):
                self.bugTaskList.append(success)
                self.showingList = self.bugTaskList.map({ $0.task })
            case .failure(let failure):
                self.errorMessage = failure.localizedDescription
                print(self.errorMessage)
//                if failure.localizedDescription == "The data couldn’t be read because it is missing." {
//                    self.showingList.removeAll(keepingCapacity: false)
//                }
            }
        }
    }
    
    func getDailyTask(taskType: TaskType) {
        
        self.dailyTaskList.removeAll(keepingCapacity: false)
        
        GetTask.shared.getDailyTask(taskType: taskType) { result in
            self.showingList.removeAll(keepingCapacity: false)
            switch result {
            case .success(let success):
                self.dailyTaskList.append(success)
                self.showingList = self.dailyTaskList.map({ $0.task })
            case .failure(let failure):
                self.errorMessage = failure.localizedDescription
            }
        }
    }
    
    func saveTask(_ taskItem: TaskType, _ projectName: String, _ taskText: String) {
        
        saveAndUpdateTask(taskItem, projectName, taskText)
        
//        switch taskItem {
//        case .feature: 
//            saveAndUpdateTask(taskItem, projectName, taskText)
//        case .bug:
//            saveAndUpdateTask(taskItem, projectName, taskText)
//        case .daily:
//            saveAndUpdateTask(taskItem, projectName, taskText)
//        }
        
    }
    
    func addProject(_ projectName: String) {
        
        guard let userID else { return }
        let userRef = database.collection("users").document(userID)
        let projectRef = userRef.collection("Project").document(projectName)
        
        projectRef.setData(["name": projectName]) { error in
            guard error == nil else { return }
            
            let collections = ["Feature","Bug"]
            for collectionName in collections {
                projectRef.collection(collectionName).addDocument(data: [:]) { error in
                    guard error == nil else { return }
                }
                
            }
        }
    }
    
    func saveLastSelectedProject(projectName: String) {
        UserDefaults.standard.set(projectName, forKey: "lastSelectedProject")
    }
    
    func getLastSelectedProject() {
        
    }
    
    private func saveAndUpdateTask(_ taskItem: TaskType, _ projectName: String, _ taskText: String) {
        
        guard let userID else { return }
        let taskReference = database.collection("users").document(userID).collection("Project").document(projectName).collection(taskItem.rawValue)
        
        let taskID = UUID()
        
        let newTask: [String: Any] = [
            "id": "\(taskID)",
            "task": taskText
//            "time": FieldValue.serverTimestamp()
        ]
        
        taskReference.addDocument(data: newTask) { error in
            if let error = error {
                print("Görev eklenirken hata oluştu: \(error)")
            } else {
                print("Yeni görev başarıyla eklendi.")
                switch taskItem {
                case .feature:
                    self.getFeatureTask(taskType: .feature, projectName: projectName)
                case .bug:
                    self.getBugTask(taskType: .bug, projectName: projectName)
                case .daily:
                    print("Daily")
                }
            }
        }
    }
}

extension PopoverViewModel: PopoverViewModelProtocol {
    
    func getTask<T>(taskType: TaskType, projectName: String, completion: @escaping (Result<T, Error>?) -> Void) where T : Decodable, T : Encodable {
        
    }
    
    
}
