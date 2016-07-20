//
//  PairViewController.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/14/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import UIKit

class PairViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var gradientView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.phoneTextfield.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PairViewController.dismiss as (PairViewController) -> () -> ())))
    }
    
    @IBAction func pairAction(_ sender: AnyObject)
    {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        phoneTextfield.resignFirstResponder()
        return false
    }
    
    func dismiss() {
        phoneTextfield.resignFirstResponder()
    }
    
    
}
