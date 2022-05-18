//
//  FirebaseController.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 12/05/22.
//

//import UIKit
//import Firebase
//import FirebaseFirestoreSwift
//
//class FirebaseController: NSObject, DatabaseProtocol {
//    func cleanup() {
//        //
//    }
//
//    func addTask(taskTitle: String, taskDescription: String, isChecklist: Bool, checklistItems: NSSet) -> TaskUnit {
//        //
//
//        return TaskUnit()
//    }
//
//    func deleteTask(taskNote: TaskUnit) {
//        //
//    }
//
//    func addChecklist(checklistDesc: String, isChecklist: Bool) -> ChecklistUnit {
//        //
//
//        return ChecklistUnit()
//    }
//
//    func addChecklistToTeam(checklistItem: ChecklistUnit, taskItem: TaskUnit) {
//        //
//    }
//
//    func removeChecklistToTeam(checklistItem: ChecklistUnit, taskItem: TaskUnit) {
//        //
//    }
//
//
//    var listeners = MulticastDelegate<DatabaseListener>()
//
//    var authController: Auth
//    var database: Firestore
//    var tasksRef: CollectionReference?
//    var checklistsRef: CollectionReference?
//    var currentUser: FirebaseAuth.User?
//
//    var checklistsItems: [ChecklistItem]
//    var taskItem: TaskItem
//
//    override init() {
//        FirebaseApp.configure()
//        authController = Auth.auth()
//        database = Firestore.firestore()
//        checklistsItems = [ChecklistItem]()
//        taskItem = TaskItem()
//
//        super.init()
//    }
//
//
//    func addListener(listener: DatabaseListener){
//        listeners.addDelegate(listener)
////        if listener.listenerType == .task || listener.listenerType == .all {
////            listener.onTaskChange(change: .update, teamHeroes: taskItem.checklistItems)
////        }
////        if  listener.listenerType == .all {
////            listener.onAllTasksChange(change: .update, heroes: taskItem)
////        }
//    }
//    func removeListener(listener: DatabaseListener){
//        listeners.removeDelegate(listener)
//    }
//
//    func addTaskToFirebase(taskTitle: String, taskDescription: String, isChecklist: Bool, checklistItems: [ChecklistItem]) -> TaskItem{
//        let task = TaskItem()
//        task.taskTitle = taskTitle
//        task.taskDescription = taskDescription
//        task.isChecklist = isChecklist
//        task.checklistItems = checklistItems
//
//        do {
////         if let taskRef = try tasksRef?.addDocument(from: task) {
////         task.id = taskRef.documentID
////         }
//            let taskRef =  try database.collection("users").document(authController.currentUser!.uid).collection("task").addDocument(from: task)
//        } catch {
//         print("Failed to serialize hero")
//        }
//
//        return task
//    }
//}
