
//
//  AppDelegate.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/12/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import UIKit
import WatchConnectivity
import HealthKit
import CloudKit
import WatchConnectivity

var notificationAvaiable = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    let healthStore = HKHealthStore()
    var id = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        application.statusBarStyle = UIStatusBarStyle.lightContent
        
        if WCSession.isSupported() {
            let wcSession = WCSession.default()
            wcSession.delegate = self
            wcSession.activate()
        }
        
        // PEGA ID DO CLOUDKIT
        let container = CKContainer.default()
        container.fetchUserRecordID { (userID, error) in
            if error != nil {
                print("** ERRO AO PEGAR ID DO USUARIO **\n")
                print(error?.localizedDescription)
                
                // ***************** CRIAR ALERT NOTIFICANDO PARA ENTRAR COM O iCLOUD *****************
            } else {
                print("O ID DO USUÁRIO É:\n")
                print(userID!)
                print("BIIIIIIRL \(userID!.recordName)  BIIIIIIIRL\n")
                print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
                
                self.id = String(userID!.recordName)
                
                CloudKitDAO().pegaCuidador(id: self.id)
                NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.mandaPraMonitorVC), name: "cuidadorChegando" as NSNotification.Name, object: nil)
            }
        }
        
        return true
    }
    
    func mandaPraMonitorVC(notification: Notification) {
        let dict = notification.object as! NSDictionary
        
        if dict["name"]! as? String != nil {
            print("PRINTAAAANDO DA APP DELEGATE O NOME DO CUIDADOR: \(dict["name"] as? String)")
            
//            self.window = UIWindow(frame: UIScreen.main().bounds)
//            
//            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "Cuidador") as UIViewController
//            self.window = UIWindow(frame: UIScreen.main().bounds)
//            self.window?.rootViewController = initialViewControlleripad
//            self.window?.makeKeyAndVisible()
            
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // authorization from watch
    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        
        
        let typesToRead = Set([
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
            
            ])
        
        self.healthStore.requestAuthorization(toShare: Set([HKObjectType.workoutType()]), read: typesToRead) { (sucess, error) in
            if error != nil {
                print("MERDA NA REQUEST\n")
                print(error?.localizedDescription)
            } else {
                print(sucess)
            }
        }
        
        self.healthStore.handleAuthorizationForExtension { (sucess, error) in
            
            
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: NSError?) {
        if error != nil {
            print(error?.localizedDescription)
        } else {
            print(activationState)
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print("\n\n*************************       AGORA TO RECEBENDO A MESSAGEM        ***************************\n\n")
        
        if message["fall"] as? String == "Detected" {
            
            // Manda pro cloud avisando que caiu
            // Vem como dicionario ["fall":"Detected"]
            let teste = CKRecord(recordType: "Teste")
            teste["teste"] = 1
            let publicData = CKContainer.default().publicCloudDatabase
            publicData.save(teste, completionHandler: { (record, error) in
                if error != nil {
                    print("NOVINHA SAFADINHA HOJE EU VOU FALAR PRA TU, EU TO DANDO ERRO")
                    print(error?.localizedDescription)
                } else {
                    print("NOVINHA SAFADINHA HOJE EU VOU FALAR PRA TU, EU MANDEI O TESTE COM SUCESSO")
                }
            })
            
            
            print("Recebi \(message["fall"])")
            
        } else {
            print("\n\n\n\n\n*************************       TA BUGADO A QUEDA       ***************************\n\n\n\n\n")
        }
        
        // Mensagem do batimento
        
        if message["heartRate"] != nil {
            
            // Manda batimento pra cloud
            // Vem como dicionario ["heartRate":Int]
            // Fazer tratamento do batimento na própria cloud pra mandar a notificação ou com aquele bagulho de predicate que tu falou
            
            if message["heartRate"] as? Int > 120 && notificationAvaiable {
                
                // Manda notificação de batimento alto
                
                let notificationManager = NotificationManager()
                
                notificationManager.setupAndGenerateLocalHighHeartRateNotification()
                
                let elderVC: MainViewController = MainViewController()
                elderVC.heartRateLabel.text = String(message["heartRate"])
                elderVC.heartRateLabel.textColor = UIColor.orange()
                
                
                let caretakerVC: MonitorViewController = MonitorViewController()
                caretakerVC.heartRateLabel.text = String(message["heartRate"])
                caretakerVC.heartRateLabel.textColor = UIColor.orange()
                caretakerVC.heartViewBackground.backgroundColor = UIColor.orange()
                
            } else {
                
                if (message["heartRate"] as? Int) < 50 && notificationAvaiable {
                    
                    let notificationManager = NotificationManager()
                    
                    notificationManager.setupAndGenerateLocalLowHeartRateNotification()
                    
                    let elderVC: MainViewController = MainViewController()
                    elderVC.heartRateLabel.text = String(message["heartRate"])
                    elderVC.heartRateLabel.textColor = UIColor.orange()
                    
                    
                    let caretakerVC: MonitorViewController = MonitorViewController()
                    caretakerVC.heartRateLabel.text = String(message["heartRate"])
                    caretakerVC.heartRateLabel.textColor = UIColor.orange()
                    caretakerVC.heartViewBackground.backgroundColor = UIColor.orange()
                    
                } else {
                    
                    let elderVC: MainViewController = MainViewController()
                    elderVC.heartRateLabel.text = String(message["heartRate"])
                    
                    let caretakerVC: MonitorViewController = MonitorViewController()
                    caretakerVC.heartRateLabel.text = String(message["heartRate"])
                    
                    notificationAvaiable = true
                    
                }
            }
            
        }
        
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject] = [:]) {
        print("\n\n*************************       AGORA TO RECEBENDO A INFO       ***************************\n\n")
        
        if userInfo["fall"] as? String == "Detected"{
            
            // Manda pro cloud avisando que caiu
            // Vem como dicionario ["fall":"Detected"]
            // Fazer tratamento do batimento
            let teste = CKRecord(recordType: "Teste2")
            teste["teste"] = 1
            let publicData = CKContainer.default().publicCloudDatabase
            publicData.save(teste, completionHandler: { (record, error) in
                if error != nil {
                    print("NOVINHA SAFADINHA HOJE EU VOU FALAR PRA TU, EU TO DANDO ERRO")
                    print(error?.localizedDescription)
                } else {
                    print("NOVINHA SAFADINHA HOJE EU VOU FALAR PRA TU, EU MANDEI O TESTE COM SUCESSO")
                }
            })
            
            print("Recebi \(userInfo["fall"])\n\n")
            
        } else {
            print("NAO FOI A QUEDA!!!\n\n")
        }
        
        // Informação de batimento:
        
        if userInfo["heartRate"] != nil {
            
            // Manda batimento pra cloud
            // Vem como dicionario ["heartRate":Int]
            // Fazer tratamento do batimenro na própria cloud pra mandar a notificação ou com aquele bagulho de predicate que tu falou
            
            if userInfo["heartRate"] as? Int > 120 && notificationAvaiable {
                
                // Manda notificação de batimento alto
                
                let notificationManager = NotificationManager()
                
                notificationManager.setupAndGenerateLocalHighHeartRateNotification()
                
                let elderVC: MainViewController = MainViewController()
                elderVC.heartRateLabel.text = String(userInfo["heartRate"])
                elderVC.heartRateLabel.textColor = UIColor.orange()
                
                
                let caretakerVC: MonitorViewController = MonitorViewController()
                caretakerVC.heartRateLabel.text = String(userInfo["heartRate"])
                caretakerVC.heartRateLabel.textColor = UIColor.orange()
                caretakerVC.heartViewBackground.backgroundColor = UIColor.orange()
                
            } else {
                
                if (userInfo["heartRate"] as? Int) < 50 && notificationAvaiable {
                    
                    let notificationManager = NotificationManager()
                    
                    notificationManager.setupAndGenerateLocalLowHeartRateNotification()
                    
                    let elderVC: MainViewController = MainViewController()
                    elderVC.heartRateLabel.text = String(userInfo["heartRate"])
                    elderVC.heartRateLabel.textColor = UIColor.orange()
                    
                    
                    let caretakerVC: MonitorViewController = MonitorViewController()
                    caretakerVC.heartRateLabel.text = String(userInfo["heartRate"])
                    caretakerVC.heartRateLabel.textColor = UIColor.orange()
                    caretakerVC.heartViewBackground.backgroundColor = UIColor.orange()
                    
                } else {
                    
                    let elderVC: MainViewController = MainViewController()
                    elderVC.heartRateLabel.text = String(userInfo["heartRate"])
                    
                    let caretakerVC: MonitorViewController = MonitorViewController()
                    caretakerVC.heartRateLabel.text = String(userInfo["heartRate"])

                    notificationAvaiable = true
                    
                }
            }
            
        }
    }
    
}

