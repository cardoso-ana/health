//
//  InitialViewController.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/14/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import UIKit
import WatchConnectivity

class InitialViewController: UIViewController, WCSessionDelegate {
    
    @IBOutlet weak var gradientView: GradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if WCSession.isSupported() {
            let wcSession = WCSession.default()
            wcSession.delegate = self
            wcSession.activate()
            print("TA FUNFANDO")
        }
        
    }
    
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
    
}


