//
//  MainViewController.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/14/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController, CLLocationManagerDelegate
{
    let locationManager = CLLocationManager()
    @IBOutlet weak var gradientView: UIView!
    
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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userLocation()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error while updating location " + error.localizedDescription)
    }
    
}
