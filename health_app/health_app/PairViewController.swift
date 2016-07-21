//
//  PairViewController.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/14/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import UIKit

class PairViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var gradientView: UIView!
    
    var idCT = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("PRINTANDO O IDCT: \(self.idCT)")
        
        self.phoneTextfield.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PairViewController.dismiss as (PairViewController) -> () -> ())))
        
        
        
    }
    
    @IBAction func pairAction(_ sender: AnyObject) {
        CloudKitDAO().pareamento(phone: phoneTextfield.text!, ctid: idCT)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "monitorar" {
            
            let vc = segue.destinationViewController as! MonitorViewController
            vc.idCt = self.idCT
            
        }
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
