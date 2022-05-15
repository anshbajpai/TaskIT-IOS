//
//  ChecklistTaskCollectionViewCell.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 15/05/22.
//

import UIKit

class ChecklistTaskCollectionViewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource {
    
    
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
        let cell =  UITableViewCell()
        
        cell.textLabel?.text = "Test"
        
        return cell
    }
    
    
}
