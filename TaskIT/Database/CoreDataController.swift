//
//  CoreDataController.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 10/05/22.
//

import UIKit
import CoreData


class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "TaskIT-Model")
        persistentContainer.loadPersistentStores() { (description, error ) in
         if let error = error {
         fatalError("Failed to load Core Data Stack with error: \(error)")
         }
        }
     super.init()
    }
    
    func cleanup() {
     if persistentContainer.viewContext.hasChanges {
     do {
     try persistentContainer.viewContext.save()
     } catch {
     fatalError("Failed to save changes to Core Data with error: \(error)")
     }
     }
    }
    
    func addTask(taskTitle: String, taskDescription: String, isChecklist: Bool, checklistItems: NSSet) -> TaskUnit {
        let taskItem = NSEntityDescription.insertNewObject(forEntityName: "TaskUnit", into: persistentContainer.viewContext) as! TaskUnit
        taskItem.taskTitle = taskTitle
        taskItem.taskDescription = taskDescription
        taskItem.isChecklist = isChecklist
        if isChecklist {
            taskItem.addToChecklistItems(checklistItems)
        }
        
        return taskItem
     }
    
    func addChecklistToTeam(checklistItem: ChecklistUnit, taskItem: TaskUnit) {
        taskItem.addToChecklistItems(checklistItem)
    }
    
    func removeChecklistToTeam(checklistItem: ChecklistUnit, taskItem: TaskUnit) {
        taskItem.removeFromChecklistItems(checklistItem)
    }
    
    func deleteTask(taskNote: TaskUnit) {
        persistentContainer.viewContext.delete(taskNote)
    }
    
    func fetchAllTasks() -> [TaskUnit] {
        var tasks = [TaskUnit]()
        
        let request: NSFetchRequest<TaskUnit> = TaskUnit.fetchRequest()
        
        do {
            try tasks = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request failed with error: \(error)")
        }
        
        return tasks
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .all {
            listener.onAllTasksChange(change: .update, allTaskNote: fetchAllTasks())
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    
}
