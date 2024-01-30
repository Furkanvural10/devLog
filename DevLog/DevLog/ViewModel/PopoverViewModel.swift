//
//  PopoverViewModel.swift
//  DevLog
//
//  Created by furkan vural on 30.01.2024.
//

import Foundation

protocol PopoverViewModelProtocol {
    
    func getFeatureTask()
    func getBugTask()
    func getDailyTask()
    
    
}

final class PopoverViewModel: Observable {
    
    
    init() {}
    
    func getFeatureTask() {
        
    }
    
    func getBugTask() {
        
    }
    
    func getDailyTask() {
        
    }
}

extension PopoverViewModel: PopoverViewModelProtocol {
    
}
