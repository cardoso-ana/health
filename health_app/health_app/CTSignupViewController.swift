//
//  CTSignupViewController.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/20/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import UIKit
import CloudKit

class CTSignupViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    
    var idCT = ""
    var users = [CKRecord]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.phoneTextfield.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CTSignupViewController.dismiss as (CTSignupViewController) -> () -> ())))
        
        
        
        let container = CKContainer.default()
        container.fetchUserRecordID { (userID, error) in
            if error != nil {
                print("** ERRO AO PEGAR ID DO USUARIO **\n")
                print(error?.localizedDescription)
            } else {
                print("O ID DO USUÁRIO É:\n")
                print(userID!)
                print("BIIIIIIRL \(userID!.recordName)  BIIIIIIIRL\n")
                print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
                
                self.idCT = String(userID!.recordName)
            }
        }
    }
    
    @IBAction func continueAction(_ sender: AnyObject)
    {
        if nameTextfield.text != nil || phoneTextfield.text != nil {
            
            loadUser(idfb: self.idCT, completionHandler: { (success) in
                if success {
                    self.send2Cloud()
                    
                } else {
                    print("\n")
                    print("\nCUIDADOR JÁ ESTÁ NA NUVEM\n")
                    print("\n")
                }
            })
        }
    }
    
    func send2Cloud() {
        let user = CKRecord(recordType: "Caretaker")
        
        user["name"] = self.nameTextfield.text!
        user["phone"] = self.phoneTextfield.text!
        user["id"] = self.idCT
        
        let publicData = CKContainer.default().publicCloudDatabase
        
        publicData.save(user) { (record, error) in
            if error == nil {
                DispatchQueue.main.asynchronously(execute: { () -> Void in
                    print("CARETAKER salvo com sucesso!\n")
                    self.performSegue(withIdentifier: "pareamento", sender: self)
                })
            }
            else {
                print("Erro ao salvar CARETAKER\n")
                print(error?.localizedDescription)
            }
        }
    }
    
    typealias CompletionHandler = (success:Bool) -> Void
    func loadUser(idfb: String, completionHandler: CompletionHandler) {
        
        users = [CKRecord]()
        print("\nO ID É:\(idCT)")
        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "id == %@", idCT)
        let query = CKQuery(recordType: "Caretaker", predicate: predicate)
        
        publicData.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let users = results {
                self.users = users
                print("\nHow many users in cloud: \(self.users.count)\n")
                if self.users.count != 0 {
                    //self.aux = false
                    completionHandler(success: false)
                }
                else {
                    //self.aux = true
                    completionHandler(success: true)
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pareamento" {
            
            let vc = segue.destinationViewController as! PairViewController
            vc.idCT = self.idCT
        }
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
