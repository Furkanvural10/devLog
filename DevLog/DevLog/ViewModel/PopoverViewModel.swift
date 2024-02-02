import Foundation
import FirebaseFirestore

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
    
    func getFeatureTask() {
        // TODO: Fetch data from db. ViewModel -> Layer -> Manager ->
        
        
        print("GetFeature Called")
        database.collection("FeatureTask").getDocuments { snapshot, error in
            guard error == nil else { return }
            
            guard let snapshot = snapshot else { return }
            
            
            
            
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
}

extension PopoverViewModel: PopoverViewModelProtocol {
    
}
