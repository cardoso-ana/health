//
//  WaitViewController.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/14/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import UIKit
import CloudKit

class WaitViewController: UIViewController
{
    
    var ctUsers = [CKRecord]()
    var phone = ""
    
    @IBOutlet weak var gradientView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("PRINTANDO DA WaitViewController O TELEFONE: \(phone)")
        
        verificaPareamento(tel: phone)
    }
    
    func verificaPareamento(tel: String) {
        
        ctUsers = [CKRecord]()
        let aux = ""
        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "phone == %@ AND careTakerId != %@", argumentArray: [phone, aux])
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        publicData.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print("TEM IDOSO PAREADO!!")
                self.performSegue(withIdentifier: "pareado", sender: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
