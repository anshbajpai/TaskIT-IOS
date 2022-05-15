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
    
    func populate(taskTitle: String, taskDescription: String){
        taskTitleField.text = taskTitle
        taskDescriptionField.text = taskDescription
        
        priorityLabel.layer.cornerRadius = priorityLabel.layer.bounds.width / 2
        priorityLabel.clipsToBounds = true
    }
}
