//
//  HeartRateInterfaceController.swift
//  health_app WatchKit Extension
//
//  Created by Ana Carolina Nascimento on 7/12/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import WatchKit
import Foundation
import CloudKit
import HealthKit
import CoreMotion

let motionManager = CMMotionManager()

class HeartRateInterfaceController: WKInterfaceController, HKWorkoutSessionDelegate {
    
    @IBOutlet var heartBeatLabel: WKInterfaceLabel!
    @IBOutlet var heartGroup: WKInterfaceGroup!
    
    var accelerometerValue = 3.0
//    let motionManager = CMMotionManager()
    let activityManager = CMMotionActivityManager()
    
    let healthStore = HKHealthStore()
    
    //State of the app - is the workout activated
    var workoutActive = false
    
    // define the activity type and location
    var workoutSession : HKWorkoutSession?
    let heartRateUnit = HKUnit(from: "count/min")
    var anchor = HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor))
    
    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)
        
        //        // MARK: Activity Handler -
        //
        //        if CMMotionActivityManager.isActivityAvailable() {
        //
        //            let activityHandler: CMMotionActivityHandler = { (activityData: CMMotionActivity?) -> Void in
        //
        //                // Se estiver sentado ou deitado (parado) ou andando:
        //
        //                if activityData?.stationary == true || activityData?.walking == true {
        //
        //                    // Piso do acelerômetro 3.0
        //
        //                    self.accelerometerValue = 3.0
        //
        //                    print("FUNCIONA")
        //
        //                    if activityData?.stationary == true {
        //                        // Mudar estado para parado nas telas
        //                        // Mudar imagem e descrição
        //                    } else {
        //                        // Mudar estado para andando nas telas
        //                        // Mudar imagem e descrição
        //                    }
        //
        //                } else {
        //
        //                    if activityData?.running == true {
        //                        // Mudar estado para correndo nas telas
        //                        // Mudar imagem e descrição
        //
        //                        print("NAO FUNCIONA")
        //                    } else {
        //                        // Mudar estado para de carro
        //                        // Mudar imagem e descrição
        //                    }
        //                    // Piso do acelerômetro 5.0
        //
        //                    self.accelerometerValue = 5.0
        //                }
        //
        //            }
        //
        //            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: activityHandler)
        
//        motionManager.accelerometerUpdateInterval = 0.2
//        
//        if motionManager.isAccelerometerAvailable {
//            
//            let accelerometerHandler: CMAccelerometerHandler = { (accelerometerData: CMAccelerometerData?, error: NSError?) -> Void in
//                if (fabs(accelerometerData!.acceleration.x) >= 3.0 || fabs(accelerometerData!.acceleration.y) >= 3.0 || fabs(accelerometerData!.acceleration.z) >= 3.0) {
//                    
//                    print("\n\nCaiu!!\n\n")
//                    print("\(accelerometerData?.acceleration.x)\n\(accelerometerData?.acceleration.y)\n\(accelerometerData?.acceleration.z)\n")
//                    
//                    // NOTIFICAÇÃO PRO CUIDADOR E BOTÃO DE EMERGENCIA PRO IDOSO
//                    
//                    motionManager.stopAccelerometerUpdates()
//                    self.presentController(withName: "CountdownInterfaceController", context: self)
//                    
//                } else {
//                    print("Ta de boa")
//                }
//            }
//            
//            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: accelerometerHandler)
//            
//        }
        
        if (self.workoutActive) {
            //finish the current workout
            self.workoutActive = false
            if let workout = self.workoutSession {
                healthStore.end(workout)
            }
        } else {
            //start a new workout
            self.workoutActive = true
            startWorkout()
        }
    }
    
    
    //    override func didAppear() {
    //
    //        super.didAppear()
    //
    //        // MARK: Accelerometer -
    //
    //        if self.isTrackingMotion == false {
    //
    //            self.isTrackingMotion = true
    //
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
    //                        self.motionManager.stopAccelerometerUpdates()
    //
    //                        self.isTrackingMotion = false
    //
    //                        // NOTIFICAÇÃO PRO CUIDADOR E BOTÃO DE EMERGENCIA PRO IDOSO
    //
    //                        self.presentController(withName: "CountdownInterfaceController", context: self)
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
    //
    //        }
    //
    //    }
    
    override func didAppear() {

        if !motionManager.isAccelerometerActive {
            
            print(motionManager.isAccelerometerActive)
            
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
        
        
        
        guard HKHealthStore.isHealthDataAvailable() == true else {
            heartBeatLabel.setText("not available")
            return
        }
        
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
            displayNotAllowed()
            return
        }
        
        let dataTypes = Set(arrayLiteral: quantityType)
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) -> Void in
            if success == false {
                self.displayNotAllowed()
            }
        }
    }
    
    func displayNotAllowed() {
        heartBeatLabel.setText("not allowed")
    }
    
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running:
            workoutDidStart(date: date)
        default:
            print("Unexpected state \(toState)")
        }
    }
    
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: NSError) {
        // Do nothing for now
        NSLog("Workout error: \(error.userInfo)")
    }
    
    
    func workoutDidStart(date : NSDate) {
        if let query = createHeartRateStreamingQuery(workoutStartDate: date) {
            healthStore.execute(query)
        } else {
            heartBeatLabel.setText("cannot start")
        }
    }
    
    func startWorkout() {
        self.workoutSession = HKWorkoutSession(activityType: HKWorkoutActivityType.crossTraining, locationType: HKWorkoutSessionLocationType.indoor)
        self.workoutSession?.delegate = self
        healthStore.start(self.workoutSession!)
    }
    
    func createHeartRateStreamingQuery(workoutStartDate: NSDate) -> HKQuery? {
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return nil }
        
        let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: nil, anchor: anchor, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
            guard let newAnchor = newAnchor else {return}
            self.anchor = newAnchor
            self.updateHeartRate(samples: sampleObjects)
        }
        
        heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
            self.anchor = newAnchor!
            self.updateHeartRate(samples: samples)
        }
        return heartRateQuery
    }
    
    func updateHeartRate(samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else {return}
        
        DispatchQueue.main.asynchronously() {
            guard let sample = heartRateSamples.first else{return}
            let value = sample.quantity.doubleValue(for: self.heartRateUnit)
            self.heartBeatLabel.setText(String(UInt16(value)))
            
            
        }
    }
    
    
    override func didDeactivate() {
        super.didDeactivate()
    }
}
