//
//  GetTask.swift
//  DevLog
//
//  Created by furkan vural on 16.02.2024.
//

import Foundation

final class GetTask {
    
    static let shared = GetTask()
    private init() {}
    
    
    
    func getFeatureTask(taskType: TaskType, projectName: String, completion: @escaping (Result<FeatureTask, Error>) -> Void) {
        
        FirebaseManager.shared.getTask(taskType: taskType, projectName: projectName, completion: completion)
    }
    
    func getBugTask(taskType: TaskType, projectName: String, completion: @escaping (Result<BugTask, Error>) -> Void) {
        FirebaseManager.shared.getTask(taskType: taskType, projectName: projectName, completion: completion)
    }
    
    func getDailyTask(taskType: TaskType, completion: @escaping (Result<DailyTask, NetworkError>) -> Void) {
        FirebaseManager.shared.getData(completion: completion)
    }
}
