//
//  CreateTaskViewController.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 05/05/22.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class CreateTaskViewController: UIViewController, UITextViewDelegate{

    @IBOutlet weak var taskTitleField: UITextView!
    
    @IBOutlet weak var taskDescField: UITextView!
    
    weak var databaseController: DatabaseProtocol?
    
    weak var authController: Auth?
    weak var database: Firestore?
    weak var checklistsRef: CollectionReference?
    weak var currentUser: FirebaseAuth.User?
    
    var priorityLabel: PriorityLabel = .low
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        authController = Auth.auth()
        database = Firestore.firestore()

        taskTitleField.delegate = self
        taskDescField.delegate = self
        let date = Date()
        let format = date.getFormattedDate(format: "MMM d, yyyy")
        self.navigationController?.navigationBar.topItem?.title = format
        // Do any additional setup after loading the view.
        
       
    }
    
    
    
    @IBAction func testBtnClicked(_ sender: Any) {
        print(taskTitleField.text)
        let myTask = databaseController?.addTask(taskTitle: taskTitleField.text!, taskDescription: taskDescField.text!, isChecklist: false, checklistItems: NSSet(), priorityLabel: self.priorityLabel)
        let firebaseTask = addTaskToFirebase(taskTitle: taskTitleField.text!, taskDescription: taskDescField.text!, isChecklist: false, checklistItems: [])
        print(myTask)
        // TODO: Jump Back to main view controller
        self.dismiss(animated: true)
        print("Completed !")
    }
    
    
    func addTaskToFirebase(taskTitle: String, taskDescription: String, isChecklist: Bool, checklistItems: [ChecklistItem]) -> TaskItem{
        let task = TaskItem()
        task.taskTitle = taskTitle
        task.taskDescription = taskDescription
        task.isChecklist = isChecklist
        task.checklistItems = checklistItems
        
        do {
//         if let taskRef = try tasksRef?.addDocument(from: task) {
//         task.id = taskRef.documentID
//         }
            let taskRef =  try database!.collection("users").document((authController?.currentUser!.uid)!).collection("task").addDocument(from: task)
        } catch {
         print("Failed to serialize hero")
        }
        
        return task
    }
    
    
    func barButtonItemClicked() {
       // TODO: Add Checks for field, to verify they are not empty
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        databaseController = appDelegate?.databaseController
//        print(taskTitleField.text)
//        let myTask = databaseController?.addTask(taskTitle: taskTitleField.text!, taskDescription: taskDescField.text!, isChecklist: false, checklistItems: NSSet())
//        print(myTask)
//        // TODO: Jump Back to main view controller
//        self.dismiss(animated: true)
//        print("Completed !")
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray4 {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        if textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
        if textView.restorationIdentifier == "textDescription" {
            textView.text = "Task Description"
            textView.textColor = UIColor.systemGray
        }
        else {
            textView.text = "Task Title"
            textView.textColor = UIColor.systemGray4
        }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension Date {
    func getFormattedDate(format: String) -> String {
         let dateformat = DateFormatter()
         dateformat.dateFormat = format
         return dateformat.string(from: self)
     }
}
