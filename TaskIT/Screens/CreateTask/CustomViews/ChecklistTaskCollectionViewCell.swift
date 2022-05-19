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
    
    func populate(taskTitle: String, checklistItems: Set<ChecklistUnit>){
        taskTitleField.text = taskTitle
        
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
