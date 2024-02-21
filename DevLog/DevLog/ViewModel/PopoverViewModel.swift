import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol PopoverViewModelProtocol {
//    func getFeatureTask(projectName: String)
//    func getBugTask()
//    func getDailyTask()
    func getTask<T: Codable>(taskType: TaskType, projectName: String, completion: @escaping (Result<T, Error>?) -> Void)
    
}

final class PopoverViewModel: ObservableObject {
    
    @Published var featureTaskList = [FeatureTask]()
    @Published var bugTaskList = [BugTask]()
    @Published var dailyTaskList = [DailyTask]()
    @Published var allProjectList = [String]()
    @Published var errorMessage = ""
    @Published var lastSelectedProject = ""
    
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
                print("\(document.documentID)")
                self.allProjectList.append(document.documentID)
            }
        }
    }
    
    
    func getFeatureTask(taskType: TaskType, projectName: String) {
        
        GetTask.shared.getFeatureTask(taskType: taskType, projectName: projectName) { result in
            
            switch result {
            case .success(let success):
//                self.featureTaskList = success
                print(success)
                self.featureTaskList.append(success)
                
            case .failure(let failure):
                self.errorMessage = failure.localizedDescription
                
            }
        }
    }
    
    func getBugTask(taskType: TaskType, projectName: String) {
        GetTask.shared.getBugTask(taskType: taskType, projectName: projectName) { result in
            switch result {
            case .success(let success):
                self.bugTaskList = success
                print("BUG TASK: \(success)")
            case .failure(let failure):
                self.errorMessage = failure.localizedDescription
                print("HATA MESAJI : \(failure.localizedDescription)")
            }
        }
    }
    
    func getDailyTask(taskType: TaskType, projectName: String) {
        GetTask.shared.getDailyTask(taskType: taskType, projectName: projectName) { result in
            switch result {
            case .success(let success):
                self.dailyTaskList = success
            case .failure(let failure):
                self.errorMessage = failure.localizedDescription
            }
        }
    }
    
    func saveTask(_ taskItem: TaskType, _ taskText: String) {
        guard let userID else { return }

        switch taskItem {
        case .feature: 
            let taskReference = database.collection("user").document(userID).collection("FeatureTask")
            let taskID = UUID()
            let newTask = [
                "id": "\(userID)",
                "task": taskText
            ]
            taskReference.addDocument(data: newTask) { error in
                if let error = error {
                    print("Görev eklenirken hata oluştu: \(error)")
                } else {
                    print("Yeni görev başarıyla eklendi.")
                }
            }
        case .bug:
            print("Bug taskına kaydet")
        case .daily:
            print("Daily taskına kaydet")
        }
        
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
}

extension PopoverViewModel: PopoverViewModelProtocol {
    func getTask<T>(taskType: TaskType, projectName: String, completion: @escaping (Result<T, Error>?) -> Void) where T : Decodable, T : Encodable {
        
    }
    
    
}
