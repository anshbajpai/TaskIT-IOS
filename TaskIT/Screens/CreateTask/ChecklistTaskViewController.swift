//
//  ChecklistTaskViewController.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 10/05/22.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ChecklistTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, CheckListTableViewCellDelegate, UITableViewDelegate {
    

    @IBOutlet weak var checklistDescField: CustomTextField!
    
    @IBOutlet weak var taskTitleField: UITextView!
    
    @IBOutlet weak var checklistTableView: UITableView!
    
    weak var databaseController: DatabaseProtocol?

    var allTasks: [String] = [
      "Buy milk from coles - 1L",
      "Buy vegetables for dinner",
      "Complete science homework"
    ]
    
    weak var authController: Auth?
    weak var database: Firestore?
    weak var checklistsRef: CollectionReference?
    weak var currentUser: FirebaseAuth.User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        authController = Auth.auth()
        database = Firestore.firestore()
        checklistDescField.delegate = self
        taskTitleField.delegate = self
        // Do any additinal setup after loading the view.
    }
    
    @IBAction func addChecklistBtnClicked(_ sender: Any) {
        if checklistDescField.hasText {
            allTasks.append(checklistDescField.text!)
            checklistDescField.text = ""
            checklistTableView.reloadData()
        }
    }
    
    
    @IBAction func testBtnClicked(_ sender: Any) {
        
        

        // TODO: Implement some valid checks here
        var allChecklistItems: Set<ChecklistUnit> = []
        var allFirebaseChecklistItems: [ChecklistItem] = []
        
        for task in allTasks {
            guard let newChecklistItem = databaseController?.addChecklist(checklistDesc: task, isChecklist: false) else { return }
            allChecklistItems.insert(newChecklistItem)
            var newFirebaseChecklistItem = ChecklistItem()
            newFirebaseChecklistItem.checklistDescription = task
            newFirebaseChecklistItem.isChecked = false
            allFirebaseChecklistItems.append(newFirebaseChecklistItem)
        }
        
        let _ = databaseController?.addTask(taskTitle: taskTitleField.text!, taskDescription: "None", isChecklist: true, checklistItems: allChecklistItems as NSSet)
        
        let firebaseTask = addTaskToFirebase(taskTitle: taskTitleField.text!, taskDescription: "None", isChecklist: true, checklistItems: allFirebaseChecklistItems)
        
        self.dismiss(animated: true)
//        let _ = databaseController?.addTask(taskTitle: taskTitleField.text!, taskDescription: "None", isChecklist: true, checklistItems: allChecklistItems as NSSet)
        
        
        
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
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        checklistDescField.change = true
        if textField.textColor == UIColor.systemGray4  {
            textField.text = nil
            textField.textColor = UIColor.black
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        checklistDescField.change = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Task Title" && textView.restorationIdentifier == "taskTitleIdentifier" {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView.restorationIdentifier == "taskTitleIdentifier" {
                textView.text = "Task Title"
                textView.textColor = UIColor.systemGray3
            }
        }
    }
    
    func checkListTableViewCell(_ cell: ChecklistTableViewCell, didChangeCheckedState checked: Bool) {
        
        guard let indexPath = checklistTableView.indexPath(for: cell) else {
            return
        }
//        let task = allTasks[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "TaskIT"){ action, view, complete in
            
            let task = self.allTasks[indexPath.row]
            let cell = tableView.cellForRow(at: indexPath) as! ChecklistTableViewCell
            cell.set(checked: true)
            
            complete(true)
            print("TaskedIT")
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            allTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
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

extension ChecklistTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkboxCell", for: indexPath) as! ChecklistTableViewCell
    
        cell.delegate = self
        let task = allTasks[indexPath.row]
        cell.set(description: task, checked: false)
        return cell
    }
}

class CustomTextField: UITextField{

    var change: Bool = false {
        didSet {
            textColor = change ? .black : .black
            backgroundColor = change ? .systemGray6 : .white
        }
    }
    
}
