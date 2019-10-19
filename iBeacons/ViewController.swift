//
//  ViewController.swift
//  iBeacons
//
//  Created by Hasan Qasim on 19/10/19.
//  Copyright © 2019 Hasan Qasim. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    @IBOutlet weak var distanceReading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                // ranging is the ability to tell roughly how far something is away from device
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let constraint = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: "MyBeacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(satisfying: constraint)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
                case .far:
                    self.view.backgroundColor = UIColor.blue
                    self.distanceReading.text = "FAR"

                case .near:
                    self.view.backgroundColor = UIColor.orange
                    self.distanceReading.text = "NEAR"

                case .immediate:
                    self.view.backgroundColor = UIColor.red
                    self.distanceReading.text = "RIGHT HERE"
                
                default:
                    self.view.backgroundColor = UIColor.gray
                    self.distanceReading.text = "UNKNOWS"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon]) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }

}

