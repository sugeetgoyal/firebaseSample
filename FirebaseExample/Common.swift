//
//  Common.swift
//  FirebaseExample
//
//  Created by Sugeet Goyal on 10/04/17.
//  Copyright © 2017 Sugeet Goyal. All rights reserved.
//

import UIKit

class Common: NSObject {
  
    class func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func showAlert(with message:String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        let delegate = UIApplication.shared.delegate
        delegate?.window??.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
