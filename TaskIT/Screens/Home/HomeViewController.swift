//
//  HomeViewController.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 01/05/22.
//

import UIKit
import Hover
import Floaty
import Firebase
import FirebaseFirestoreSwift
import FirebaseFunctions
import FirebaseFunctionsSwift

class HomeViewController: UIViewController, DatabaseListener, UISearchBarDelegate, UISearchDisplayDelegate {
    
    
    

    

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var allTasks: [TaskUnit] = []
    var listenerType: ListenerType = .all
    weak var databaseController: DatabaseProtocol?
    
    var firstSignUp: Bool = false
    
    var shouldSync: Bool = true

    @IBOutlet weak var searchBar: UISearchBar!
    
    
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
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        

        hideKeyboardWhenTappedAround()

        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
//        let floatingButton = UIButton()
//        floatingButton.setTitle("+", for: .normal)
//        floatingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
//        //floatingButton.setImage(UIImage(named: "add-logo"), for: .normal)
//        floatingButton.contentMode = .center
//        floatingButton.backgroundColor = UIColor(red: 0.208, green: 0.424, blue: 0.976, alpha: 1.0)
//
//
//        floatingButton.layer.cornerRadius = 25
//
//        floatingButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        floatingButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        floatingButton.layer.shadowOpacity = 1.0
//        floatingButton.layer.shadowRadius = 5.0
//        floatingButton.layer.masksToBounds = false
//        floatingButton.layer.cornerRadius = 25.0
//        view.addSubview(floatingButton)
//        floatingButton.translatesAutoresizingMaskIntoConstraints = false
//
//        floatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
//
//        floatingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
//
//        floatingButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)


    }
    
    override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
     databaseController?.addListener(listener: self)
        if firstSignUp {
            syncWithFirebase()
        }
}
    
    override func viewWillDisappear(_ animated: Bool) {
     super.viewWillDisappear(animated)
     databaseController?.removeListener(listener: self)
    }

    
    @IBAction func settingsBtnClicked(_ sender: Any) {
        print("Clicked")
        performSegue(withIdentifier: "settingsSegue", sender: nil)
    }
    
    private func syncWithFirebase(){
      
            let firestoreDatabase = Firestore.firestore()
               
            let authController = Auth.auth()
        authController.addStateDidChangeListener { auth, user in
            print(auth)
        }
        firestoreDatabase.collection("users").document(authController.currentUser!.uid).collection("task").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for change in querySnapshot!.documentChanges {
                 //   print("\(document.documentID) => \(document.data())")
                    let task: TaskItem
                    do {
                        task = try change.document.data(as: TaskItem.self)
                        print(task)
                    }
                    catch{
                        print("Unable to decode task. Is the hero malformed?")
                        return
                    }
                    
                    if task.isChecklist! {
                        var allChecklistItems: Set<ChecklistUnit> = []
                        for checklist in task.checklistItems {
                            guard let newChecklistItem = self.databaseController?.addChecklist(checklistDesc: checklist.checklistDescription!, isChecklist: checklist.isChecked!) else { return }
                            
                            allChecklistItems.insert(newChecklistItem)
                        }
                        
                        if task.taskPriorityLabel == nil {
                            let _ = self.databaseController?.addTask(taskTitle: task.taskTitle!, taskDescription: "None", isChecklist: task.isChecklist!, checklistItems: allChecklistItems as NSSet, priorityLabel: .low)
                        }
                        else {
                            let _ = self.databaseController?.addTask(taskTitle: task.taskTitle!, taskDescription: "None", isChecklist: task.isChecklist!, checklistItems: allChecklistItems as NSSet, priorityLabel: task.taskPriorityLabel!)
                        }
                    }
                    else {
                        if task.taskPriorityLabel == nil {
                            let _ = self.databaseController?.addTask(taskTitle: task.taskTitle!, taskDescription: task.taskDescription!, isChecklist: task.isChecklist!, checklistItems: NSSet(), priorityLabel: .low)
                        }
                        else {
                            let _ = self.databaseController?.addTask(taskTitle: task.taskTitle!, taskDescription: task.taskDescription!, isChecklist: task.isChecklist!, checklistItems: NSSet(), priorityLabel: task.taskPriorityLabel!)
                        }
                    }
                }
                    
                }
            }
    }
    
    
    func onTaskChange(change: DatabaseChange, taskNote: TaskUnit) {
        //
        print("Triggered Single")
    }
    
    func onAllTasksChange(change: DatabaseChange, allTaskNote: [TaskUnit]) {
        print("Triggered")
        allTasks = allTaskNote
        if allTasks.count == 0 && self.shouldSync{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.syncWithFirebase()
            }
        }
        collectionView.reloadData()
    }
    
    @objc func pressed() {
        self.performSegue(withIdentifier: "createTaskSegue", sender: nil)
    }

    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Inside")
        if !searchText.isEmpty {
            allTasks = (databaseController?.searchAllTasks(searchQuery: searchText))!
        }
        else {
            allTasks = (databaseController?.getAllTasks())!
        }
        collectionView.reloadData()
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
        
        if allTasks.count == 0 {
//            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
//            noDataLabel.text          = "No Tasks"
//            noDataLabel.textColor     = UIColor.blue
//            noDataLabel.textAlignment = .center
//            let imageView : UIImageView = {
//                let iv = UIImageView()
//                iv.image = UIImage(named:"archivebox")
//                iv.contentMode = .scaleAspectFill
//                return iv
//            }()
//            collectionView.backgroundView  = imageView
            collectionView.setEmptyMessage("No Tasks", UIImage(systemName: "archivebox")!)

        }
        else {
            collectionView.backgroundView  = nil
        }
        return allTasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let thisTask = allTasks[indexPath.row]
        
        if thisTask.isChecklist {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChecklistTaskCollectionViewCell", for: indexPath) as! ChecklistTaskCollectionViewCell
            
            cell.populate(taskTitle: thisTask.taskTitle!, checklistItems: thisTask.checklistItems as! Set<ChecklistUnit>)
            
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 0.6
            cell.layer.borderColor = UIColor.systemGray4.cgColor
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCollectionViewCell", for: indexPath) as! TaskCollectionViewCell
            
            cell.populate(taskTitle: thisTask.taskTitle!, taskDescription: thisTask.taskDescription!, priorityLabelColor: thisTask.priorityLabel)
            
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

struct TaskTest {
    
    var taskTitle = "Something - 1"
    var isChecked = false
    var taskDescription = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo"
    
    var checklistDesc = "Trying ..."
    
}



extension UICollectionView {

        func setEmptyMessage(_ message: String,_ img:UIImage) {
            
            let image = UIImageView()
            image.contentMode = .scaleToFill
            let screenSize: CGRect = UIScreen.main.bounds
            image.frame = CGRect(x: 0, y: 0, width: 50, height: screenSize.height * 0.4)
            image.image = img
            
            
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.font = UIFont.boldSystemFont(ofSize: 20)
            messageLabel.textColor = .gray
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.sizeToFit()
            
            let mainView = UIView()
            mainView.addSubview(image)
            mainView.addSubview(messageLabel)
           
            //Auto Layout
            image.translatesAutoresizingMaskIntoConstraints = false
            image.heightAnchor.constraint(equalToConstant: 50).isActive = true
            image.widthAnchor.constraint(equalToConstant: 60).isActive = true
            image.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 10).isActive = true
            image.centerYAnchor.constraint(equalTo: mainView.centerYAnchor , constant: 0).isActive = true
            
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
            messageLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10).isActive = true
            messageLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 10).isActive = true
            
            self.backgroundView = mainView
        }
        
        func restoreBackgroundView() {
            self.backgroundView = nil
        }
    }
