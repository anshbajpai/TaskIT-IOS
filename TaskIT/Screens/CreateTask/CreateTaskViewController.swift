//
//  CreateTaskViewController.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 05/05/22.
//

import UIKit

class CreateTaskViewController: UIViewController, UITextViewDelegate{

    @IBOutlet weak var taskTitleField: UITextView!
    
    @IBOutlet weak var taskDescField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        taskTitleField.delegate = self
        taskDescField.delegate = self
        let date = Date()
        let format = date.getFormattedDate(format: "MMM d, yyyy")
        self.tabBarController?.navigationItem.title = format
        // Do any additional setup after loading the view.
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
