//
//  LocationManager.swift
//  InTandemMaps
//
//  Created by Rishabh Lalwani on 20/10/24.
//

import Foundation
import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let instance = LocationManager()
    private var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var lat : Double?
    var long: Double?

    func requestAuthorization() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)  {
        print("Location Manager is called")
        authorizationStatus = status
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location Access Denied")
        case .notDetermined:
            print("Location Access Not Determined")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            self.lat = lat
            self.long = long
            locationManager.stopUpdatingLocation()
        }
    }
    
    func getAddressFromCoordinates(latitude: Double, longitude: Double, completion: @escaping (String) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion("No placemark found")
                return
            }
            var address = ""
            if placemark.thoroughfare != nil {
                address += placemark.thoroughfare! + ", "
            }
            if placemark.locality != nil {
                address += placemark.locality! + ", "
            }
            if placemark.administrativeArea != nil {
                address += placemark.administrativeArea! + ", "
            }
            if placemark.country != nil {
                address += placemark.country! + ", "
            }
            if placemark.postalCode != nil {
                address += placemark.postalCode!
            }
            completion(address)
        }
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
}
