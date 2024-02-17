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
    
    func getTask(taskType: TaskType, projectName: String, completion: @escaping (Result<FeatureTask, Error>?) -> Void) {
        FirebaseManager.shared.getTask(taskType: taskType, projectName: projectName, completion: completion)
    }
}
