//
//  FirebaseController.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 12/05/22.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class FirebaseController: NSObject, DatabaseProtocol {

    var listeners = MulticastDelegate<DatabaseListener>()
    
    var authController: Auth
    var database: Firestore
    var tasksRef: CollectionReference?
    var checklistsRef: CollectionReference?
    var currentUser: FirebaseAuth.User?
    
    var checklistsItems: [ChecklistUnit]
    var taskItem: TaskItem
    
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        
        super.init()
    }
    
    
    func addListener(listener: DatabaseListener){
        listeners.addDelegate(listener)
//        if listener.listenerType == .task || listener.listenerType == .all {
//            listener.onTaskChange(change: .update, teamHeroes: taskItem.checklistItems)
//        }
//        if  listener.listenerType == .all {
//            listener.onAllTasksChange(change: .update, heroes: taskItem)
//        }
    }
    func removeListener(listener: DatabaseListener){
        listeners.removeDelegate(listener)
    }
    
    func addTask(taskTitle: String, taskDescription: String, isChecklist: Bool, checklistItems: NSSet) -> TaskUnit{
        let task = TaskItem()
        task.taskTitle = taskTitle
        task.taskDescription = taskDescription
        task.isChecklist = isChecklist
        
        do {
         if let taskRef = try tasksRef?.addDocument(from: task) {
         task.id = taskRef.documentID
         }
        } catch {
         print("Failed to serialize hero")
        }
        
        return hero
    }
}
