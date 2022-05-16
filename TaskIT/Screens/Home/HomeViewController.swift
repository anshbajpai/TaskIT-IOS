//
//  HomeViewController.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 01/05/22.
//

import UIKit
import Hover
import Floaty

class HomeViewController: UIViewController {

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let tasks: [TaskTest] = [
        TaskTest(taskTitle: "Title 1 Here"),
        TaskTest(taskTitle: "Title 2 Here", isChecked: true),
        TaskTest(taskTitle: "Title 3 Here", isChecked: true),
        TaskTest(taskTitle: "Title 4 Here"),
        TaskTest(taskTitle: "Title 5 Here",isChecked: true) ,
        TaskTest(taskTitle: "Title 6 Here"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        let floatingButton = UIButton()
        floatingButton.setTitle("+", for: .normal)
        floatingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        //floatingButton.setImage(UIImage(named: "add-logo"), for: .normal)
        floatingButton.contentMode = .center
        floatingButton.backgroundColor = UIColor(red: 0.208, green: 0.424, blue: 0.976, alpha: 1.0)
        

        floatingButton.layer.cornerRadius = 25

        floatingButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        floatingButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        floatingButton.layer.shadowOpacity = 1.0
        floatingButton.layer.shadowRadius = 5.0
        floatingButton.layer.masksToBounds = false
        floatingButton.layer.cornerRadius = 25.0
        view.addSubview(floatingButton)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        floatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true

        floatingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        floatingButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)


    }
    
    @objc func pressed() {
        self.performSegue(withIdentifier: "createTaskSegue", sender: nil)
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


extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let thisTask = tasks[indexPath.row]
        
        if thisTask.isChecked {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChecklistTaskCollectionViewCell", for: indexPath) as! ChecklistTaskCollectionViewCell
            
            cell.populate(taskTitle: thisTask.taskTitle)
            
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 0.6
            cell.layer.borderColor = UIColor.systemGray4.cgColor
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCollectionViewCell", for: indexPath) as! TaskCollectionViewCell
            
            cell.populate(taskTitle: thisTask.taskTitle, taskDescription: thisTask.taskDescription)
            
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 0.6
            cell.layer.borderColor = UIColor.systemGray4.cgColor
            
            return cell
        }
        
    }
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 10)/2
        return CGSize(width: size, height: size)
    }
}


struct TaskTest {
    
    var taskTitle = "Something - 1"
    var isChecked = false
    var taskDescription = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo"
    
    var checklistDesc = "Trying ..."
    
}
