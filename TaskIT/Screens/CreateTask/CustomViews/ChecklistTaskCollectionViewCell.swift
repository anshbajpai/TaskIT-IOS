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
    
    
    func populate(taskTitle: String){
        taskTitleField.text = taskTitle
        
        priorityLabel.layer.cornerRadius = priorityLabel.layer.bounds.width / 2
        priorityLabel.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Configure your cell here
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkboxHomeCell", for: indexPath) as! ChecklistHomeTableViewCell
    
        cell.delegate = self
        let task = "Something"
        cell.set(description: task, checked: false)
        return cell
    }
    
    
}
