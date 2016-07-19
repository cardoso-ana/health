//
//  EditViewController.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/14/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var ageTextfield: UITextField!
    @IBOutlet weak var adressTextfield: UITextField!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var UFTextfield: UITextField!
    @IBOutlet weak var phoneTextfield: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // TextField Stuff
        self.nameTextfield.delegate = self
        self.ageTextfield.delegate = self
        self.adressTextfield.delegate = self
        self.cityTextfield.delegate = self
        self.UFTextfield.delegate = self
        self.phoneTextfield.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EditViewController.dismissKeyboard as (EditViewController) -> () -> ())))
        
    }
    
    @IBAction func cancelAction(_ sender: AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: AnyObject)
    {
        
    }

    // MARK: - TextField Dismiss Stuff
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        nameTextfield.resignFirstResponder()
        ageTextfield.resignFirstResponder()
        adressTextfield.resignFirstResponder()
        cityTextfield.resignFirstResponder()
        UFTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
        return false
    }
    
    func dismissKeyboard()
    {
        nameTextfield.resignFirstResponder()
        ageTextfield.resignFirstResponder()
        adressTextfield.resignFirstResponder()
        cityTextfield.resignFirstResponder()
        UFTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
    }
    
}
