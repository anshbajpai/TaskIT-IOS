//
//  TaskItem.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 12/05/22.
//

import UIKit
import FirebaseFirestoreSwift

class TaskItem: NSObject, Codable {
    
    @DocumentID var id: String?
    var taskTitle: String?
    var taskDescription: String?
    var isChecklist: Bool?
    var checklistItems: [ChecklistItem] = []
    var priorityLabel: Int?
    
}


extension TaskItem {
    var taskPriorityLabel: Priority {
        get {
            return Priority(rawValue: self.priorityLabel!)!
        }
        
        set {
            self.priorityLabel = newValue.rawValue
        }
    }
}


enum Priority: Int {
    case high = 0
    case medium = 1
    case low = 2
}


enum CodingKeys: String, CodingKey {
    case id
    case taskTitle
    case taskDescription
    case isChecklist
    case checklistItems
    case priorityLabel
}
