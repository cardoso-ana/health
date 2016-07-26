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

class MonitorViewController: UIViewController, WCSessionDelegate, MKMapViewDelegate
{
    
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var movementImage: UIImageView!
    @IBOutlet weak var movementLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var monitorImage: UIImageView!
    @IBOutlet weak var monitorLabel: UILabel!
    
    var adress = AdressMonitor()
    
    var idCt = ""
    let progressHUD = ProgressHUD(text: "Carregando")
    
    var latIodoso = ""
    var longIdoso = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        map.delegate = self
        map.showsUserLocation = true
        
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        CloudKitDAO().pegaIdoso(id: self.idCt)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MonitorViewController.setMapToUserLocation), name: "véioChegando" as NSNotification.Name, object: nil)
        
        
    }
    
    
    func setMapToUserLocation(notification: NSNotification) {
        let dict = notification.object as! NSDictionary
        
        print("PRINTAAANDO OIEEEE")
        print("PRINTAAANDO O NOME: \(dict["name"]!)")
        
        nameLabel.text = dict["name"]! as? String
        ageLabel.text = "\(dict["age"]! as! String) anos"
        latIodoso = (dict["lat"] as? String)!
        longIdoso = (dict["long"] as? String)!
        
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
                    annotation.title = ((self.adress.thoroughfare!) + ", " + (self.adress.subThoroughfare!))
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
