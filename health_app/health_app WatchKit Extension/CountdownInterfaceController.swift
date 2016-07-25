//
//  CountdownInterfaceController.swift
//  health_app
//
//  Created by Gabriel Bendia on 7/19/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

class CountdownInterfaceController: WKInterfaceController {
    
    @IBOutlet var timerLabel: WKInterfaceLabel!
    
    var remainingTime = 30
    var timer: Timer!
    
    let motionManager = CMMotionManager()
    var accelerometerValue = 3.0
    
    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CountdownInterfaceController.countdown), userInfo: nil, repeats: true)
        timer.fire()
        
    }
    
    override func didAppear() {
        
        timer.fire()
        
    }
    
    override func willActivate() {
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
    }
    
    func countdown() {
        
        if remainingTime == 0 {
            
            // Manda notificações pro cuidador
            
            timerLabel.setText("\(remainingTime)")
            timer.invalidate()
            
        } else {
            
//            WKInterfaceDevice.current().play(.click)
            timerLabel.setText("\(remainingTime)")
            remainingTime -= 1
            
        }
        
    }
    
    @IBAction func okButtonAction() {
        
        if timer.isValid {
            
            timer.invalidate()
            
//            motionManager.accelerometerUpdateInterval = 0.2
//            
//            if self.motionManager.isAccelerometerAvailable {
//                
//                let accelerometerHandler: CMAccelerometerHandler = { (accelerometerData: CMAccelerometerData?, error: NSError?) -> Void in
//                    
//                    // Se passar do piso manda as notificações
//                    
//                    if (fabs(accelerometerData!.acceleration.x) >= self.accelerometerValue || fabs(accelerometerData!.acceleration.y) >= self.accelerometerValue || fabs(accelerometerData!.acceleration.z) >= self.accelerometerValue) {
//                        
//                        print("\n\nCaiu!!\n\n")
//                        print("\(accelerometerData?.acceleration.x)\n\(accelerometerData?.acceleration.y)\n\(accelerometerData?.acceleration.z)\n")
//                        
//                        
//                        // NOTIFICAÇÃO PRO CUIDADOR E BOTÃO DE EMERGENCIA PRO IDOSO
//                        
//                        self.presentController(withName: "CountdownInterfaceController", context: self)
//
//                        self.motionManager.stopAccelerometerUpdates()
//
//                        //self.dismiss()
//                        
//                    } else {
//                        print("Ta de boa")
//                    }
//                }
//                
//                self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: accelerometerHandler)
//                
//            } else {
//                print("\nAccelerometer not avaiable\n")
//            }
            dismiss()
            
        }
    }
    
}
