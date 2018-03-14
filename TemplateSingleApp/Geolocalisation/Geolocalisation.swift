//
//  Geolocalisation.swift
//  Meteo Kids
//
//  Created by Laurent Favard on 12/01/2018.
//  Copyright © 2018 etudiant. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation


//  Extension class method
extension Double {
    
    func formatDecimal(format: String) -> Double {
        
        let formattedString = NSString(format: "%\(format)f" as NSString, self) as String
        return Double(formattedString)!
    }
}

public class Geolocalisation {
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    public var locManager: CLLocationManager!
    private var geocoder: CLGeocoder!
    private var observers = [NSObjectProtocol]()
    private var notificationHandler : ((_ cityName:String, _ cityUrl:String) -> Void)?
    private var previousUrlGps = ""
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    init(view: UIViewController, delegate: CLLocationManagerDelegate, notificationHandler:@escaping( (_ cityName:String, _ cityUrl:String) -> Void )) {
        
        //  Instanciate the CLLocationManager and CLGeocoder
        self.locManager = CLLocationManager()
        self.locManager.delegate = delegate
        self.locManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        self.locManager.requestWhenInUseAuthorization()                
        self.locManager.startUpdatingLocation()
        
        self.notificationHandler = notificationHandler
        
        self.geocoder = CLGeocoder()
        
        //  Add an event observer to receive personnal event
        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        
        self.observers.append( notificationCenter.addObserver(forName: NSNotification.Name(rawValue: ObserversName.applicationDidEnterBackground.rawValue), object: nil, queue: mainQueue)
        {
            [unowned self] _ in
            self.locManager.stopUpdatingLocation()
        })
        
        self.observers.append( notificationCenter.addObserver(forName: NSNotification.Name(rawValue: ObserversName.applicationDidBecomeActive.rawValue), object: nil, queue: mainQueue)
        {
            [unowned self] _ in
            self.locManager.startUpdatingLocation()
        })
        
    }
    
    deinit {
        
        self.locManager.stopUpdatingLocation()
        for observer in self.observers {
        
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
        
        self.locManager.stopUpdatingLocation()
    }
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    
    /**
        Manage the update: New= added the extra optional parameter to get the city next to the coordinate '?city=true'
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locationArray = locations as NSArray
        
        if let locationObj = locationArray.lastObject as? CLLocation {
            
            let coord = locationObj.coordinate
            
            //  Example:    http://www.prevision-meteo.ch/services/json/lat=46.259lng=5.235
            //              http://www.prevision-meteo.ch/services/json/lat=46.259lng=5.235?city=true   to obtain the nearest city
            //
            //let url =  "lat=\((coord.latitude.formatDecimal(format: ".3")))lng=\(coord.longitude.formatDecimal(format:".3"))?city=true";
            
            //  second step
            self.geocoder.reverseGeocodeLocation(locationObj, completionHandler: {
                
                placemarks, error in
                
                if error == nil {
                    
                    if let placemarks = placemarks, placemarks.count > 0 {
                        
                        let pm = placemarks[0]
                        
                        if let cityName = pm.locality {
                            
                            let url = "lat=\((coord.latitude.formatDecimal(format: ".3")))lng=\(coord.longitude.formatDecimal(format:".3"))?city=true"
                            if self.previousUrlGps != url {

                                self.previousUrlGps = url
                                
                                //print("CLLocation changed: name:\(cityName)")
                                print("didUpdateLocations: CLLocation changed: url:\(url)")

                                self.notificationHandler?(cityName, url)
                            }
                        }
                        else {
                            print("didUpdateLocations: pm.locality doesn't contain a valid city name")
                        }
                    }
                    else {
                        print("didUpdateLocations: placemarks is nil")
                    }
                }
                else {
                    print("didUpdateLocations: error raised: \(String(describing: error?.localizedDescription))")
                }
            })
        }
        else {
            
            print("didUpdateLocations: locationArray.lastObject is nil or not CLLocation")
        }
            
    }
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    func locationManager(_ manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedAlways, .authorizedWhenInUse:
            
            manager.startUpdatingLocation()
            
        case  .notDetermined:
            
            break
            
        //  Positionning disabled or application not allows (Parental restriction)
        case .restricted, .denied:
            
            //  Code here to disable the TableView GPS positionning
            //NotificationCenter.default.post(name: Notification.Name(rawValue: "geolocalisationUpdate"), object: nil)
            break
        }
    }
}
