//
//  ChecklistTaskCollectionViewCell.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 15/05/22.
//

import UIKit

class ChecklistTaskCollectionViewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource, ChecklistHomeTableViewCellDelegate {
    
    
    func checkListTableViewCell(_ cell: ChecklistHomeTableViewCell, didChangeCheckedState checked: Bool) {
        //
    }
    
    
    
    @IBOutlet weak var taskTitleField: UILabel!
    
    @IBOutlet weak var priorityLabel: UIView!
    @IBOutlet weak var tableView: UITableView!
    var allChecklistItems: Array<ChecklistUnit> = []
    
    func populate(taskTitle: String, checklistItems: Set<ChecklistUnit>, priorityLabelColor: Int32){
        taskTitleField.text = taskTitle
        if priorityLabelColor == 0 {
            priorityLabel.backgroundColor = UIColor(red: 220.0/255.0, green: 48.0/255.0, blue: 35.0/255.0, alpha: 1.0)
        }
        else if priorityLabelColor == 1 {
            priorityLabel.backgroundColor = UIColor(red: 255.0/255.0, green: 182.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        }
        else {
            priorityLabel.backgroundColor = UIColor(red: 38.0/255.0, green: 166.0/255.0, blue: 91.0/255.0, alpha: 1.0)
        }
        priorityLabel.layer.cornerRadius = priorityLabel.layer.bounds.width / 2
        priorityLabel.clipsToBounds = true
        
        allChecklistItems = Array(checklistItems)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allChecklistItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Configure your cell here
        let currentTaskChecklist = allChecklistItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkboxHomeCell", for: indexPath) as! ChecklistHomeTableViewCell
    
        cell.delegate = self
        let task = currentTaskChecklist.checklistDescription
        cell.set(description: task!, checked: currentTaskChecklist.isChecklist)
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    
}
