//
//  LoginViewController.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 18/04/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    var authController: Auth?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let newColor = UIColor.black
        emailField.layer.borderColor = newColor.cgColor
        passwordField.layer.borderColor = newColor.cgColor
        
        emailField.layer.cornerRadius = 4
        emailField.layer.borderWidth = 0.3
        
        passwordField.layer.cornerRadius = 4
        passwordField.layer.borderWidth = 0.3
        
        authController = Auth.auth()
    }
    
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func signInBtnClicked(_ sender: Any) {
        Task {
            do {
                let authResult = try await authController?.signIn(withEmail: emailField.text!, password: passwordField.text!)
                
                DispatchQueue.main.async {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeVC")
                    newViewController.modalPresentationStyle = .fullScreen
                    
                    let navViewController = MainNavigationController(rootViewController: newViewController)
                    
                    navViewController.modalPresentationStyle = .fullScreen

                            self.present(navViewController, animated: true, completion: nil)
                }
                
                print("User logged in")
            }
            catch {
                self.displayMessage(title: "Error", message: "Login failed! Try Again")
                print("User Signup failed")
            }
        }
    }
    
    
    @IBAction func signInGoogleBtn(_ sender: Any) {
        userGoogleLogin()
    }
    
    
    @IBAction func signInFacebookBtn(_ sender: Any) {
        userFacebookLogin()
        
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
