//
//  MovementInterfaceController.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/14/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import WatchKit
import Foundation
import CloudKit
import CoreMotion

class MovementInterfaceController: WKInterfaceController {
    
    @IBOutlet var movementLabel: WKInterfaceLabel!
    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func didAppear() {
        
        if !motionManager.isAccelerometerActive {
            
            motionManager.accelerometerUpdateInterval = 0.2
            
            if motionManager.isAccelerometerAvailable {
                
                let accelerometerHandler: CMAccelerometerHandler = { (accelerometerData: CMAccelerometerData?, error: NSError?) -> Void in
                    if (fabs(accelerometerData!.acceleration.x) >= 3.0 || fabs(accelerometerData!.acceleration.y) >= 3.0 || fabs(accelerometerData!.acceleration.z) >= 3.0) {
                        
                        print("\n\nCaiu!!\n\n")
                        print("\(accelerometerData?.acceleration.x)\n\(accelerometerData?.acceleration.y)\n\(accelerometerData?.acceleration.z)\n")
                        
                        // NOTIFICAÇÃO PRO CUIDADOR E BOTÃO DE EMERGENCIA PRO IDOSO
                        
                        motionManager.stopAccelerometerUpdates()
                        self.presentController(withName: "CountdownInterfaceController", context: self)
                        
                    } else {
                        print("Ta de boa")
                    }
                }
                
                motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: accelerometerHandler)
                
            }
            
        }

    }
    
    override func willActivate() {
        super.willActivate()
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
