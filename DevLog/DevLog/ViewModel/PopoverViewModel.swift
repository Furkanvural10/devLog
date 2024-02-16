import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol PopoverViewModelProtocol {
    func getFeatureTask()
    func getBugTask()
    func getDailyTask()
    
}

final class PopoverViewModel: ObservableObject {
    
    @Published var featureTaskList = [FeatureTask]()
    @Published var bugTaskList = [BugTask]()
    @Published var dailyTaskList = [DailyTask]()
    @Published var allProjectList = [String]()
    
    private let database = Firestore.firestore()
    private let userID = Auth.auth().currentUser?.uid
    
    init() {}
    
    func getAllProject() {
        allProjectList.removeAll(keepingCapacity: false)
        let db = Firestore.firestore()
        guard let userID else { return }
        
        let projectsRef = db.collection("users").document(userID).collection("Project")
        
        projectsRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID)")
                    self.allProjectList.append(document.documentID)
                }
            }
        }
    }
    
    func getFeatureTask() {
        // TODO: Fetch data from db. ViewModel -> Layer -> Manager ->
        
        database.collection("FeatureTask").getDocuments { snapshot, error in
            guard error == nil else { return }
            
            guard let snapshot = snapshot else { return }
            
            
            for document in snapshot.documents {
                do {
                    let product = try document.data(as: FeatureTask.self)
                    self.featureTaskList.append(product)
                }
                catch {
                    print("decode error")
                    return
                }
            }
        }
    }
    
    func getBugTask() {
        // TODO: Fetch data from db. ViewModel -> Layer -> Manager ->
#warning("Fixed here")
        
        print("GetBug Called")
        database.collection("BugTask").getDocuments { snapshot, error in
            guard error == nil else { return }
            
            guard let snapshot = snapshot else { return }
            
            
            
        }
    }
    
    func getDailyTask() {
        // TODO: Fetch data from db. ViewModel -> Layer -> Manager ->
        
        database.collection("DailyTask").getDocuments { snapshot, error in
            guard error == nil else { return }
            
            guard let snapshot = snapshot else { return }
            
        }
    }
    
    func saveTask(_ taskItem: TaskType, _ taskText: String) {
        
        guard let userID else { return }
        let database = Firestore.firestore()
        
        // Tasktex
        
        
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
            if let error = error {
                print("Error adding project: \(error)")
            } else {
                print("Project added successfully")
                
                let collections = ["Feature","Bug"]
                for collectionName in collections {
                    projectRef.collection(collectionName).addDocument(data: [:]) { error in
                        guard error == nil else { return }
                    }
                }
            }
        }
    }
}

extension PopoverViewModel: PopoverViewModelProtocol {
    
}
