//
//  MainViewController.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/14/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import UIKit
import MapKit

struct Adress
{
    var coordinate : CLLocationCoordinate2D?
    var thoroughfare : String?
    var subThoroughfare : String?
    var subLocality : String?
    var locality : String?
    var administrativeArea : String?
    var country : String?
}

class MainViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    let locationManager = CLLocationManager()
    @IBOutlet weak var gradientView: UIView!
    
    //var adress: [String] = [""]
    var adress = Adress()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var movementImage: UIImageView!
    @IBOutlet weak var movementLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var monitorImage: UIImageView!
    @IBOutlet weak var monitorLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        userLocation()
        
        map.delegate = self
        map.showsUserLocation = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        locationManager.startUpdatingLocation()
    }
    
    func userLocation()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
        let center = CLLocationCoordinate2D(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.026, longitudeDelta: 0.026))
        self.map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center

        
        CLGeocoder().reverseGeocodeLocation(locationManager.location!, completionHandler: {(placemarks, error)-> Void in
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error while updating location " + error.localizedDescription)
    }
    
}
