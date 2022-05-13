//
//  ChecklistTaskViewController.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 10/05/22.
//

import UIKit

class ChecklistTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, CheckListTableViewCellDelegate, UITableViewDelegate {
    

    @IBOutlet weak var checklistDescField: CustomTextField!
    
    @IBOutlet weak var taskTitleField: UITextView!
    
    @IBOutlet weak var checklistTableView: UITableView!

    var allTasks: [String] = [
      "Buy milk from coles - 1L",
      "Buy vegetables for dinner",
      "Complete science homework"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
