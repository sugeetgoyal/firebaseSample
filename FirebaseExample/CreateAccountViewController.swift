
//
//  CreateAccountViewController.swift
//  FirebaseExample
//
//  Created by Sugeet Goyal on 10/04/17.
//  Copyright © 2017 Sugeet Goyal. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var ref: FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Account"
        ref = FIRDatabase.database().reference()

    }
    
    //MARK - UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            self.userNameTextField.becomeFirstResponder()
        } else if textField == self.userNameTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            textField.resignFirstResponder()
            self.createButtonHandler(UIButton())
        }
        return true
    }
    
    //MARK - Action method

    @IBAction func createButtonHandler(_ sender: Any) {
        let (isValidFields, message) = self.isValidFields()
        
        if isValidFields {
            self.createAccount()
        } else {
            Common.showAlert(with: message)
        }
    }

    //MARK - Convenience method
    
    func createAccount() {
        FIRAuth.auth()?.createUser(withEmail: self.userNameTextField.text!, password: self.passwordTextField.text!, completion: { (user: FIRUser?, error: Error?) in
            print(user?.displayName ?? "not found")
            print(user ?? "not found")
            print(error ?? "not found")
            print(error?.localizedDescription ?? "not found")
            self.ref?.child("users").child((user?.uid)!).setValue(["username": self.nameTextField.text!], withCompletionBlock: { (error: Error?, ref: FIRDatabaseReference) in
                if error == nil {
//                    Common.showAlert(with: "Account Created")
                    self.performSegue(withIdentifier: "pushHome", sender: nil)
                } else {
                    Common.showAlert(with: (error?.localizedDescription)!)
                }
            })
        })
    }
    
    func isValidFields() -> (Bool, String) {
        var isValid = false
        var message = ""
        
        if self.nameTextField.text != nil && self.nameTextField.text!.characters.count > 3 {
            isValid = true
        } else {
            isValid = false
            message = "Please enter all the fields properly"
            return (isValid, message)
        }

        
        if self.userNameTextField.text != nil && Common.isValidEmail(testStr: self.userNameTextField.text!) {
            isValid = true
        } else {
            isValid = false
            message = "Please enter valid email id"
            return (isValid, message)
        }
        
        if self.passwordTextField.text != nil && (self.passwordTextField.text?.characters.count)! > 5 {
            isValid = true
        } else {
            isValid = false
            message = "Please enter atleast 6 characters in password"
            return (isValid, message)
        }
        
        return (isValid, message)
    }
}
