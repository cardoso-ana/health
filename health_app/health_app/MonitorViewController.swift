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


struct AdressMonitor
{
    var coordinate : CLLocationCoordinate2D?
    var thoroughfare : String?
    var subThoroughfare : String?
    var subLocality : String?
    var locality : String?
    var administrativeArea : String?
    var country : String?
}

class MonitorViewController: UIViewController/*, WCSessionDelegate*/, MKMapViewDelegate {

    
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var movementImage: UIImageView!
    @IBOutlet weak var movementLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var monitorImage: UIImageView!
    @IBOutlet weak var monitorLabel: UILabel!
    
    @IBOutlet weak var bpmLabel: UILabel!
    
    var adress = AdressMonitor()

    @IBOutlet weak var heartViewBackground: UIView!
    @IBOutlet weak var movementViewBackground: UIView!

    
    var idCt = ""
    let progressHUD = ProgressHUD(text: "Carregando")
    
    var latIodoso = ""
    var longIdoso = ""
    var telIdoso = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        map.delegate = self
        map.showsUserLocation = false
        
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        CloudKitDAO().pegaIdoso(id: self.idCt)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MonitorViewController.setMapToUserLocation), name: "véioChegando" as NSNotification.Name, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MonitorViewController.atualizaLabelHB), name: "heartRate" as NSNotification.Name, object: nil)
        
        // Notificação da queda:
        NotificationCenter.default.addObserver(self, selector: #selector(MonitorViewController.glaucioRei), name: "quedinha" as NSNotification.Name, object: nil)
        
    }
    
    func glaucioRei() {
        
        print("GLAUCIOREIGLAUCIOREIGLAUCIOREIGLAUCIOREIGLAUCIOREIGLAUCIOREI")
        
        print("champsonrei")
        
        self.movementImage.image = UIImage(named: "alert")
        
        self.movementViewBackground.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 169/255, blue: 105/255, alpha: 1)
        
        self.movementLabel.text = "Queda detectada!"
        
    }
    
    func atualizaLabelHB(notification: Notification) {
        
        let dict = notification.object as! NSDictionary
        
        print("JOJOJOJ")
        
        print(dict["heartRate"])
        
        self.heartRateLabel.text = String(dict["heartRate"] as? Int).replacingOccurrences(of: "Optional(", with: "")
        self.heartRateLabel.text = self.heartRateLabel.text?.replacingOccurrences(of: ")", with: "")
        
        if (dict["heartRate"] as? Int) > 120 || (dict["heartRate"] as? Int) < 50 {
            
            self.heartViewBackground.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 169/255, blue: 105/255, alpha: 1)
            self.heartRateLabel.textColor = UIColor(colorLiteralRed: 255/255, green: 169/255, blue: 105/255, alpha: 1)
            self.bpmLabel.textColor = UIColor(colorLiteralRed: 255/255, green: 169/255, blue: 105/255, alpha: 1)

        } else {
            self.heartRateLabel.textColor = UIColor(colorLiteralRed: 63/255, green: 144/255, blue: 159/255, alpha: 1)
            self.bpmLabel.textColor = UIColor(colorLiteralRed: 63/255, green: 144/255, blue: 159/255, alpha: 1)
            self.heartViewBackground.backgroundColor = UIColor.clear()
        }
        
        
        
//        self.heartViewBackground.backgroundColor = UIColor.orange()
        
    }
    
    func setMapToUserLocation(notification: NSNotification) {
        let dict = notification.object as! NSDictionary
        
        print("PRINTAAANDO OIEEEE")
        print("PRINTAAANDO O NOME: \(dict["name"]!)")
        
        nameLabel.text = dict["name"]! as? String
        ageLabel.text = "\(dict["age"]! as! String) anos"
        latIodoso = (dict["lat"] as? String)!
        longIdoso = (dict["long"] as? String)!
        telIdoso = (dict["phone"] as? String)!
        
        print("PRINTAAANDO LAT E LONG: \(latIodoso) e \(longIdoso)")
        
        let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(latIodoso)!, longitude: CLLocationDegrees(longIdoso)!)
        let location = CLLocation(latitude: CLLocationDegrees(latIodoso)!, longitude: CLLocationDegrees(longIdoso)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.026, longitudeDelta: 0.026))
        self.map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)-> Void in
            if (error != nil)
            {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if placemarks!.count > 0
            {
                let pm = (placemarks?[0])! as CLPlacemark
                print("\n\n\n************aqui******************\n\n\n")
                print([String(pm.location?.coordinate), String(pm.thoroughfare), String(pm.subThoroughfare), String(pm.subLocality), String(pm.locality), String(pm.administrativeArea)])
                
                self.adress.coordinate = pm.location?.coordinate
                self.adress.thoroughfare = String((pm.thoroughfare)) ?? ""
                self.adress.subThoroughfare = String((pm.subThoroughfare)) ?? ""
                self.adress.subLocality = String((pm.subLocality)) ?? ""
                self.adress.locality = String((pm.locality)) ?? ""
                self.adress.administrativeArea = String((pm.administrativeArea)) ?? ""
                self.adress.country = String((pm.country)) ?? ""
                
                
                
                print(self.adress)
                
                if self.adress.thoroughfare != nil && self.adress.subThoroughfare != nil && self.adress.administrativeArea != nil && self.adress.locality != nil && self.adress.country != nil
                {
                    annotation.title = (self.adress.thoroughfare!) /*+ ", " + (self.adress.subThoroughfare!)*/
                    annotation.subtitle = ((self.adress.locality!) + ", " + (self.adress.administrativeArea!) + " - " + (self.adress.country)!)
                    
                    annotation.title = annotation.title?.replacingOccurrences(of: "Optional", with: "")
                    annotation.title = annotation.title?.replacingOccurrences(of: "(\"", with: "")
                    annotation.title = annotation.title?.replacingOccurrences(of: "\")", with: "")
                    
                    annotation.subtitle = annotation.subtitle?.replacingOccurrences(of: "Optional", with: "")
                    annotation.subtitle = annotation.subtitle?.replacingOccurrences(of: "(\"", with: "")
                    annotation.subtitle = annotation.subtitle?.replacingOccurrences(of: "\")", with: "")
                }
                
            }
            else
            {
                print("Problem with the data received from geocoder")
            }
        })
        
        self.map.removeAnnotations(self.map.annotations)
        self.map.addAnnotation(annotation)


        progressHUD.hide()
        
        let notificationManager = NotificationManager()
        notificationManager.registerForNotifications()

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let userIdentifier = "UserLocation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: userIdentifier)
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: userIdentifier)
            annotationView!.canShowCallout = true
            annotationView!.image = UIImage(named: "location")
        }
        else
        {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    

    // ************************* COISAS DO BENDIA *************************
    
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: NSError?) {
//        print("Ativou a conexão")
//    }
//    
//    func session(_ session: WCSession, didReceiveMessage message: [String : AnyObject]) {
//        if message["fall"] as! String == "Detected" {
//            
//            // manda pro cloud
//            
//            movementViewBackground.backgroundColor = UIColor.orange()
//            
//            print("Recebi \(message["fall"])")
//            
//        } else {
//            print("\n\n\n\n\nTA BUGADO\n\n\n\n\n")
//        }
//    }
//    
//    func sessionDidBecomeInactive(_ session: WCSession) {
//        print("DidBecomeInactive")
//    }
//    
//    func sessionDidDeactivate(_ session: WCSession) {
//        print("DidDeactivate")
//    }
//    
//    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject] = [:]) {
//        if userInfo["fall"] as! String == "Detected"{
//         
//            // manda pro cloud
//            
//            movementViewBackground.backgroundColor = UIColor.orange()
//            
//            print("Recebi \(userInfo["fall"])")
//            
//        } else {
//            
//            print("\n\n\n\n\nTA BUGADO PRA KCT LALALALLALA\n\n\n\n\n")
//
//        }
//    }
    
    @IBAction func callElder(_ sender: AnyObject) {
        
        if let url = NSURL(string: "tel://\(telIdoso)") {
            UIApplication.shared().open(url as URL)
        }
        
    }
    
    // ************************* FIM DAS COISAS DO BENDIA *************************
    
}
