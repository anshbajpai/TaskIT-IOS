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
            priorityLabel.backgroundColor = UIColor(red: 220.0/255.0, green: 48.0/255.0, blue: 35.0/255.0, alpha: 1.0)
        }
        else if priorityLabelColor == 1 {
            priorityLabel.backgroundColor = UIColor(red: 255.0/255.0, green: 182.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        }
        else {
            priorityLabel.backgroundColor = UIColor(red: 38.0/255.0, green: 166.0/255.0, blue: 91.0/255.0, alpha: 1.0)
        }
        
        taskDescriptionField.frame = CGRect(x: 20,y: 20,width: 200,height: 800)
        taskDescriptionField.sizeToFit()
        
        priorityLabel.layer.cornerRadius = priorityLabel.layer.bounds.width / 2
        priorityLabel.clipsToBounds = true
        
        
    }
}
