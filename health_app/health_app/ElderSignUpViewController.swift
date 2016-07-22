//
//  SignUpViewController.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/12/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate
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
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismiss as (SignUpViewController) -> () -> ())))
    
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func next(_ sender: AnyObject) {
        
        Elder.singleton.setElderName(name: self.nameTextfield.text!)
        Elder.singleton.setElderAge(age: self.ageTextfield.text!)
        Elder.singleton.setElderStreet(street: self.adressTextfield.text!)
        Elder.singleton.setElderCity(city: self.cityTextfield.text!)
        Elder.singleton.setElderState(state: self.UFTextfield.text!)
        Elder.singleton.setElderPhone(phone: self.phoneTextfield.text!)
        
        if nameTextfield.text != nil || ageTextfield.text != nil || adressTextfield.text != nil || cityTextfield.text != nil || UFTextfield.text != nil || phoneTextfield.text != nil {
            
            CloudKitDAO().loadElderUser(phone: Elder.singleton.getElderPhone()) { (success) in
                if success {
                    CloudKitDAO().send2CloudElder(usuario: Elder.singleton)
                } else {
                    print("\nELDER ALREADY IN CLOUD\n")
                }
            }
            performSegue(withIdentifier: "wait", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "wait" {
            
            let vc = segue.destinationViewController as! WaitViewController
            vc.phone = phoneTextfield.text!
        }
    }
    
    // MARK: - TextField Dismiss Stuff
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        nameTextfield.resignFirstResponder()
        ageTextfield.resignFirstResponder()
        adressTextfield.resignFirstResponder()
        cityTextfield.resignFirstResponder()
        UFTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
        return false
    }
    
    func dismiss() {
        nameTextfield.resignFirstResponder()
        ageTextfield.resignFirstResponder()
        adressTextfield.resignFirstResponder()
        cityTextfield.resignFirstResponder()
        UFTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
    }
}

