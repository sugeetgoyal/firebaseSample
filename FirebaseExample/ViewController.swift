//
//  ViewController.swift
//  FirebaseExample
//
//  Created by Sugeet Goyal on 10/04/17.
//  Copyright © 2017 Sugeet Goyal. All rights reserved.
//

import UIKit
import Firebase

@objc(ViewController)
class ViewController: UIViewController, UITextFieldDelegate {

  var ref: FIRDatabaseReference?
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: "pushToHome", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushToHome" {
            
        }
    }
    
    //MARK - UITextFieldDelegate method

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.userNameTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            textField.resignFirstResponder()
            self.loginButtonHandler(UIButton())
        }
        return true
    }
    
    //MARK - Action method
    
    @IBAction func loginButtonHandler(_ sender: Any) {
        let (isValidFields, message) = self.isValidFields()
        
        if isValidFields {
            self.login()
        } else {
            Common.showAlert(with: message)
        }
    }
    
    //MARK - Convenience method
    
    fileprivate func login(){
        if FIRAuth.auth()?.currentUser == nil {
            FIRAuth.auth()?.signIn(withEmail: self.userNameTextField.text!, password: self.passwordTextField.text!
                , completion: { (user: FIRUser?, error: Error?) in
                    print(user?.displayName ?? "not found")
                    print(user ?? "not found")
                    print(error ?? "not found")
                    print(error?.localizedDescription ?? "not found")
                    
                    self.performSegue(withIdentifier: "pushToHome", sender: nil)
            })
        }
    }
    
    func isValidFields() -> (Bool, String) {
        var isValid = false
        var message = ""
        
        if self.userNameTextField.text != nil && Common.isValidEmail(testStr: self.userNameTextField.text!) {
            isValid = true
        } else {
            isValid = false
            message = "Please enter valid email ID"
            return (isValid, message)
        }
        
        if self.passwordTextField.text != nil && (self.passwordTextField.text?.characters.count)! > 5 {
            isValid = true
        } else {
            isValid = false
            message = "Please enter correct password"
            return (isValid, message)
        }
        
        return (isValid, message)
    }
}
