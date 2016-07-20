//
//  CTSignupViewController.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/20/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import UIKit

class CTSignupViewController: UIViewController, UITextFieldDelegate
{
   
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.phoneTextfield.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CTSignupViewController.dismiss as (CTSignupViewController) -> () -> ())))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        phoneTextfield.resignFirstResponder()
        return false
    }
    
    func dismiss()
    {
        nameTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
    }
    
    
}
