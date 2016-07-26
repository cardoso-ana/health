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
import WatchConnectivity

let motionManager = CMMotionManager()

class HeartRateInterfaceController: WKInterfaceController, HKWorkoutSessionDelegate, WCSessionDelegate {
    
    @IBOutlet var heartBeatLabel: WKInterfaceLabel!
    @IBOutlet var heartGroup: WKInterfaceGroup!
    
    var accelerometerValue = 3.0
    //    let motionManager = CMMotionManager()
    let activityManager = CMMotionActivityManager()
    
    var notificationAvaiable = true
    var updateTimer: Timer!
    var fakeHeartRateArray = ["72", "78", "74", "81", "82", "90", "102", "107", "140", "129", "137", "92", "75", "64", "52", "32", "15", "33", "54", "68"]
    var arrayCount = 0
    
    let healthStore = HKHealthStore()
    
    //State of the app - is the workout activated
    var workoutActive = false
    
    // define the activity type and location
    var workoutSession : HKWorkoutSession?
    let heartRateUnit = HKUnit(from: "count/min")
    var anchor = HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor))
    
    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)
        
        if WCSession.isSupported() {
            let wcSession = WCSession.default()
            wcSession.delegate = self
            wcSession.activate()
            print("TA FUNFANDO")
        }
        
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
        
        //        if WCSession.default().isReachable {
        //            WCSession.default().sendMessage(["fall":"Detected"],
        //                                            replyHandler: { (handler) -> Void in print(handler)},
        //                                            errorHandler: { (error) -> Void in print(error) })
        //            print("ERA PRA TA MANDANDO, PQ EU CHEGUEI AQUI")
        //        } else {
        //
        //            _ = WCSession.default().transferUserInfo(["fall":"Detected"])
        //            print("DEVERIA TA MANDANDO ATE AQUI, MAS NAAAAAAO, O XCODE NAO GOSTA DE AJUDAR OS MIGOS")
        //
        //        }
        
    }
    
    override func didAppear() {
        
        updateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HeartRateInterfaceController.updateHeartBeat), userInfo: nil, repeats: true)
        updateTimer.fire()
        
        if !motionManager.isAccelerometerActive {
            
            motionManager.accelerometerUpdateInterval = 0.2
            
            if motionManager.isAccelerometerAvailable {
                
                let accelerometerHandler: CMAccelerometerHandler = { (accelerometerData: CMAccelerometerData?, error: NSError?) -> Void in
                    if (fabs(accelerometerData!.acceleration.x) >= 3.0 || fabs(accelerometerData!.acceleration.y) >= 3.0 || fabs(accelerometerData!.acceleration.z) >= 3.0) {
                        
                        print("\n\nCaiu!!\n\n")
                        print("\(accelerometerData?.acceleration.x)\n\(accelerometerData?.acceleration.y)\n\(accelerometerData?.acceleration.z)\n")
                        
                        // NOTIFICAÇÃO PRO CUIDADOR E BOTÃO DE EMERGENCIA PRO IDOSO
                        
                        if WCSession.default().isReachable {
                            WCSession.default().sendMessage(["fall":"Detected"],
                                                            replyHandler: { (handler) -> Void in print(handler)},
                                                            errorHandler: { (error) -> Void in print(error) })
                            print("\n\n*************************       AGORA TO ENVIANDO A MESSAGEM        ***************************\n\n")
                        } else {
                            _ = WCSession.default().transferUserInfo(["fall":"Detected"])
                            print("\n\n*************************       TRASNFER USER INFO        ***************************\n\n")
                        }
                        
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
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: NSError?) {
        if error != nil {
            print(error?.localizedDescription)
        } else {
            print("Ativou a conexão")
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func updateHeartBeat() {
        
        arrayCount += 1
        heartBeatLabel.setText(fakeHeartRateArray[arrayCount])
        
        if WCSession.default().isReachable {
            WCSession.default().sendMessage(["heartRate":Int(fakeHeartRateArray[arrayCount])!],
                                            replyHandler: { (handler) -> Void in print(handler)},
                                            errorHandler: { (error) -> Void in print(error) })
            print("\n\n*************************       AGORA TO ENVIANDO O BATIMENTO        ***************************\n\n")
        } else {
            _ = WCSession.default().transferUserInfo(["heartRate":"High"])
            print("\n\n*************************       TRASNFER USER INFO DO BATIMENTO        ***************************\n\n")
        }
        
        if arrayCount == fakeHeartRateArray.count {
            updateTimer.invalidate()
        }
        
    }
    
}
