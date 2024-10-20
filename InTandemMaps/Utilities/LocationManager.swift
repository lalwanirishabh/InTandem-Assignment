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
    @Published var location : [String: String] = [:]
    @Published var geolocation : [String: Double] = [:]
    func requestAuthorization() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus, completion: @escaping (String) -> Void)  {
        var address = ""
        authorizationStatus = status
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            let lat = locationManager.location?.coordinate.latitude ?? 25.9875
            let long = locationManager.location?.coordinate.longitude ?? 79.4489
            getAddressFromCoordinates(latitude: lat, longitude: long) { add in
                completion(add)
            }
        case .denied, .restricted:
            address = "Location Access Denied"
            completion(address)
        case .notDetermined:
            address = "location access not determined"
            completion(address)
            break
        @unknown default:
            break
        }
    }
    
    
    func getAddressFromCoordinates(latitude: Double, longitude: Double, completion: @escaping (String) -> Void) {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            let geocoder = CLGeocoder()
            var address = ""

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Handle the error
            if let error = error {
                address = error.localizedDescription
                completion(address)
            }
            
            // Safely unwrap the first placemark
            guard let placemark = placemarks?.first else {
                address = "No placemark found"
                completion(address)
                return
            }
            
            // Extract address components with optional binding
            let city = placemark.locality ?? "Unknown City"
            let country = placemark.country ?? "Unknown Country"
            let stateAbbreviation = placemark.administrativeArea ?? "Unknown State"
            let street = placemark.thoroughfare ?? "Unknown Street"
            let zipCode = placemark.postalCode ?? "Unknown Zip"
            
            // Build the address string
            address = "\(street), \(city), \(stateAbbreviation), \(country), \(zipCode)"
            completion(address)
        }
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
}
