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
    var allTasksFetchedResultsController: NSFetchedResultsController<TaskUnit>?


    
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
    
    func addChecklist(checklistDesc: String, isChecklist: Bool) -> ChecklistUnit {
        let checklistItem = NSEntityDescription.insertNewObject(forEntityName: "ChecklistUnit", into: persistentContainer.viewContext) as! ChecklistUnit
        
        checklistItem.checklistDescription = checklistDesc
        checklistItem.isChecklist = isChecklist
        
        return checklistItem
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

        if allTasksFetchedResultsController == nil {
            let request: NSFetchRequest<TaskUnit> = TaskUnit.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "taskTitle", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            
            // Initialise Fetched Results Controller
            allTasksFetchedResultsController =
             NSFetchedResultsController<TaskUnit>(fetchRequest: request,
             managedObjectContext: persistentContainer.viewContext,
             sectionNameKeyPath: nil, cacheName: nil)
            // Set this class to be the results delegate
            allTasksFetchedResultsController?.delegate = self
            
            do {
             try allTasksFetchedResultsController?.performFetch()
            } catch {
             print("Fetch Request Failed: \(error)")
            }
        }

        if let tasks = allTasksFetchedResultsController?.fetchedObjects {
        return tasks
        }
        return [TaskUnit]()

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
    
    
    func controllerDidChangeContent(_ controller:
      NSFetchedResultsController<NSFetchRequestResult>) {
      if controller == allTasksFetchedResultsController {
      listeners.invoke() { listener in
      if (listener.listenerType == .all) {
          listener.onAllTasksChange(change: .update,allTaskNote: fetchAllTasks())
      }
      }
      }

      
      
     }

    
    
}
