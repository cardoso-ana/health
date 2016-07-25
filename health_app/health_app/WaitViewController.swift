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
    var flag = 0
    
    
    var timer: Timer!
    var timer2: Timer!
    
    @IBOutlet weak var gradientView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("PRINTANDO DA WaitViewController O TELEFONE: \(phone)")
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(WaitViewController.verificaPareamento), userInfo: nil, repeats: true)
        
        
        timer2 = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(WaitViewController.passa), userInfo: nil, repeats: true)
    }
    
    
    
    func verificaPareamento() {
        
        ctUsers = [CKRecord]()
        

        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "phone == %@ && careTakerId != ''", self.phone)
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
                
                print("TEM IDOSO PAREADO!!\n")
                
                self.timer.invalidate()
                
                self.flag = 1
            }
        }
    }
    
    func passa() {
        if flag == 1 {
            self.performSegue(withIdentifier: "pareado", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pareado" {
            
            let vc = segue.destinationViewController as! MainViewController
            vc.telefoneIdoso = self.phone
            
        }
    }
    
    
}
