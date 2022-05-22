//
//  DatabaseProtocol.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 10/05/22.
//

import Foundation


enum DatabaseChange {
 case add
 case remove
 case update
}

enum ListenerType {
 case task
 case all
}

protocol DatabaseListener: AnyObject {
 var listenerType: ListenerType {get set}
 func onTaskChange(change: DatabaseChange, taskNote: TaskUnit)
 func onAllTasksChange(change: DatabaseChange, allTaskNote: [TaskUnit])
}

protocol DatabaseProtocol: AnyObject {
 func cleanup()

 func addListener(listener: DatabaseListener)
 func removeListener(listener: DatabaseListener)

    func addTask(taskTitle: String, taskDescription: String, isChecklist: Bool, checklistItems: NSSet, priorityLabel: PriorityLabel) -> TaskUnit
 func deleteTask(taskNote: TaskUnit)
    
func addChecklist(checklistDesc: String, isChecklist: Bool) -> ChecklistUnit 
 
func addChecklistToTeam(checklistItem: ChecklistUnit, taskItem: TaskUnit)
    
func removeChecklistToTeam(checklistItem: ChecklistUnit, taskItem: TaskUnit)
    
}
