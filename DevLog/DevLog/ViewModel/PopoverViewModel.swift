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
    
    let database = Firestore.firestore()
    
    init() {}
    
    func getAllProject() {
        
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
        
        let uuid = Auth.auth().currentUser?.uid
        guard let id = uuid else { return }
        let database = Firestore.firestore()
        
        // Tasktex
        
        
        switch taskItem {
        case .feature:
            
            let taskReference = database.collection("user").document(id).collection("FeatureTask")
            let taskID = UUID()
            let newTask = [
                "id": "\(id)",
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
        let uuid = Auth.auth().currentUser?.uid
        guard let id = uuid else { return }
        let taskReference = database.collection("user").document(id).collection(projectName).addDocument(data: [:]) { error in
            if let error = error {
                print("Hata olustu")
            } else {
                print("Başarılı şekilde oluştu")
            }
            
        }
    }
}

extension PopoverViewModel: PopoverViewModelProtocol {
    
}
