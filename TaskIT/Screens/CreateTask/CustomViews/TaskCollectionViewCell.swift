//
//  TaskCollectionViewCell.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 15/05/22.
//

import UIKit

class TaskCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var taskTitleField: UILabel!
    
    
    @IBOutlet weak var taskDescriptionField: UILabel!
    
    @IBOutlet weak var priorityLabel: UIView!
    
    func populate(taskTitle: String, taskDescription: String, priorityLabelColor: Int32){
        taskTitleField.text = taskTitle
        taskDescriptionField.text = taskDescription
        
        if priorityLabelColor == 0 {
            priorityLabel.backgroundColor = .red
        }
        else if priorityLabelColor == 1 {
            priorityLabel.backgroundColor = .yellow
        }
        else {
            priorityLabel.backgroundColor = .green
        }
        
        priorityLabel.layer.cornerRadius = priorityLabel.layer.bounds.width / 2
        priorityLabel.clipsToBounds = true
        
        
    }
}
