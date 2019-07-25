//
//  ViewController.swift
//  Diary

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        
        isSignIn = !isSignIn
        
        if isSignIn {
            signInLabel.text = "Sign in to view your climbing data"
            signInButton.setTitle("Sign in", for: .normal)
        }
        else {
            signInLabel.text = "Register to visualise your climbing data"
            signInButton.setTitle("Register", for: .normal)
        }
        
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        if let email = emailTextField.text, let pass = passwordTextField.text
        {
        // Check sign in or register
        if isSignIn {
            // Sign in
            Auth.auth().signIn(withEmail: email, password: pass, completion: {(user, error) in
                
                // Check if there is no user
                if let u = user {
                    
                // Go to home screen
                self.performSegue(withIdentifier: "goHome", sender: self)
                }
                    else {
                        // error check
                    }
                
                })
            }
            else {
                // Register user in Firebase
                Auth.auth().createUser(withEmail: email, password: pass, completion: {(user, error) in
                    
                    // Check if there is no user
                    if let u = user {
                    
                    // Go to home screen
                    self.performSegue(withIdentifier: "goHome", sender: self)
            }
                    else {
                        
                    }
            
                })
    
                }

            }
        }
    
    
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
