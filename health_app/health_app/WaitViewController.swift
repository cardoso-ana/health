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
    
    var timer: Timer!
    
    @IBOutlet weak var gradientView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("PRINTANDO DA WaitViewController O TELEFONE: \(phone)")
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(WaitViewController.verificaPareamento), userInfo: nil, repeats: true)
        

        
        //verificaPareamento(tel: phone)
//        DispatchQueue.main.after(when: .now() + 10) {
//            self.verificaPareamento(tel: self.phone)
//        }
        
        
    }
    
    
    
    func verificaPareamento() {
        
        ctUsers = [CKRecord]()
        

        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "phone == %@ && careTakerId != ''", self.phone) //.length > 0
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        publicData.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            print("PRINTAAANDO O NOME: \(results?.first?.object(forKey: "name"))")
            
            if results?.first?.object(forKey: "name") == nil {
                print("\n NÃO TEM IDOSO PAREADO\n")
            } else {
                print("PRINTAAANDO: \n\(results)")
                //print("NOOOOME DO CARA É: \((users[0].value(forKey: "name") as? String)!)")
                print("TEM IDOSO PAREADO!!")
                //self.performSegue(withIdentifier: "pareado", sender: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
