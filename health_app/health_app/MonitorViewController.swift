//
//  MonitorViewController.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/14/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import UIKit
import MapKit
import WatchConnectivity

class MonitorViewController: UIViewController, WCSessionDelegate {
    
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var movementImage: UIImageView!
    @IBOutlet weak var movementLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var monitorImage: UIImageView!
    @IBOutlet weak var monitorLabel: UILabel!
    
    
    var idCt = ""
    let progressHUD = ProgressHUD(text: "Carregando")
    
    var latIodoso = ""
    var longIdoso = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        CloudKitDAO().pegaIdoso(id: self.idCt)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MonitorViewController.malandramente), name: "véioChegando" as NSNotification.Name, object: nil)
        
        
    }
    
    
    func malandramente(notification: NSNotification) {
        let dict = notification.object as! NSDictionary
        
        print("PRINTAAANDO OIEEEE")
        print("PRINTAAANDO O NOME: \(dict["name"]!)")
        
        nameLabel.text = dict["name"]! as? String
        ageLabel.text = "\(dict["age"]! as! String) anos"
        latIodoso = (dict["lat"] as? String)!
        longIdoso = (dict["long"] as? String)!
        
        print("PRINTAAANDO LAT E LONG: \(latIodoso) e \(longIdoso)")
        
        progressHUD.hide()
    }
    
    
    
    
    
    // ************************* COISAS DO BENDIA *************************
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: NSError?) {
        print("Ativou a conexão")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        if message["fall"] as! String == "Detected" {
            
            // manda pro cloud
            
            print("Recebi \(message["fall"])")
            
        } else {
            print("\n\n\n\n\nTA BUGADO\n\n\n\n\n")
        }
        movementLabel.text = "RECEBI PORRA!!!!"
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("DidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("DidDeactivate")
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject] = [:]) {
        if userInfo["fall"] as! String == "Detected"{
         
            // manda pro cloud
            
            print("Recebi \(userInfo["fall"])")
            
        } else {
            
            print("\n\n\n\n\nTA BUGADO PRA KCT LALALALLALA\n\n\n\n\n")

        }
    }
    
    // ************************* FIM DAS COISAS DO BENDIA *************************
    
}
