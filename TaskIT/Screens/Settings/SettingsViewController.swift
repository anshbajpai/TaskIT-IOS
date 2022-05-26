//
//  SettingsViewController.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 25/05/22.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController, UITableViewDelegate {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    var indicator = UIActivityIndicatorView()


    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        
        // Add a loading indicator view
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
         indicator.centerXAnchor.constraint(equalTo:
         view.safeAreaLayoutGuide.centerXAnchor),
         indicator.centerYAnchor.constraint(equalTo:
         view.safeAreaLayoutGuide.centerYAnchor)
        ])

    }
    
    
    
    func getQuoteFromApi() {
        
        var request = URLRequest(url: URL(string: "https://api.quotable.io/random")!,timeoutInterval: Double.infinity)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            
            
            print(String(data: data, encoding: .utf8)!)
            
            do{
            let decoder = JSONDecoder()
            let quoteData = try decoder.decode(QuoteData.self, from: data)

            
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                let alert = UIAlertController(title: "TaskIT-Quote", message: quoteData.content , preferredStyle: .alert)

                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                }


                alert.addAction(action1)

                self.present(alert, animated: true, completion: nil)
            }
                
            }
            catch let error {
                print(error)
            }
            
        }
        
        task.resume()
        
    
        


            
            
            
            
    }
    
    
    func logOutFromApp(){
        
        let alert = UIAlertController(title: "Log Out", message: "Are you sure, you want to logout from TaskIT ?", preferredStyle: .alert)
        
        
        let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            
            
            let firebaseAuth = Auth.auth()
            
            do {
              try firebaseAuth.signOut()
                
                self.databaseController?.deleteAllTasks()
//                self.databaseController?.deleteAllChecklistItems()
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignupVC") as! SignupViewController
                newViewController.modalPresentationStyle = .fullScreen
                
                let navViewController = UINavigationController(rootViewController: newViewController)
                
                navViewController.modalPresentationStyle = .fullScreen

                self.present(navViewController, animated: true, completion: nil)
            } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
            }
        }
        
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) {
            (action:UIAlertAction) in
            
            
        }
        
        
        alert.addAction(action1)
        alert.addAction(action2)

        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            indicator.startAnimating()
            self.getQuoteFromApi()
        }
        
        if indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            self.logOutFromApp()
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


extension SettingsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if(indexPath.row == 0){
            cell.textLabel!.text = "Log out"
            cell.textLabel?.textColor = .red
        }
        else {
            cell.textLabel!.text = "See a Quote"
        }
    

        return cell
        
    }
    
    
    
    
    
    
}
