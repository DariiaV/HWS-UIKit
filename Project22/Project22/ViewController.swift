//
//  ViewController.swift
//  Project22
//
//  Created by Дария Григорьева on 04.01.2023.
//

import CoreLocation
import UIKit

class ViewController: UIViewController {
    
    private let distanceReading: UILabel = {
        let label = UILabel()
        label.text = "UNKNOWN"
        label.font = UIFont(name: "Noteworthy", size: 40)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.tintColor = .black
        return label
    }()
    
    private lazy var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        setupView()
        
    }
    
    private func setupView() {
        view.addSubview(distanceReading)
        distanceReading.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            distanceReading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            distanceReading.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
    
    private func startScanning() {
        guard let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5") else {
            return
        }
        
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        let beaconRegionConstraint = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
     
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(satisfying: beaconRegionConstraint)
        
    }
    
    private func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
}
