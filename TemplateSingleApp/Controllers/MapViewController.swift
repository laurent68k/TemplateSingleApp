//
//  MapViewController.swift
//  Little Meteo
//
//  Created by Laurent Favard on 03/02/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import RxSwift

class MapViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapKitView: MKMapView!

    // ---------------------------------------------------------------------------------------------------------------------------------------------
    private let kCustomAnnotation = "CustomAnnotation"
    private let kCustomPinAnnotation = "CustomPinAnnotation"
    // ---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Variable
    let disposeBag = DisposeBag()
    var viewModel : MapViewModel?
    // ---------------------------------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        
        self.mapKitView.mapType = MKMapType.standard
        self.mapKitView.delegate = self
        
        self.mapKitView.mapType = MKMapType.hybrid
        self.mapKitView.showsUserLocation = true
        
        self.displayMapKit()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Private functions
    
    private func displayMapKit() {
        
        //let coordinate = CLLocationCoordinate2D( latitude: 48.8772202, longitude: 2.5783329)
        if let focusLatitude = self.viewModel?.focusedLatitude, let focusLongitude = self.viewModel?.focusedLongitude {
            
            let coordinate = CLLocationCoordinate2D( latitude: focusLatitude, longitude: focusLongitude)
            
            self.setMap(atFocusLocation: coordinate )
        }
    }
    
    private func setMap(atFocusLocation focusCoordinate: CLLocationCoordinate2D) {
        
        self.mapKitView.setCenter( focusCoordinate, animated:true)
        
        //  The way we calculate this is that 1 degree is equal to 69 mile. If we have a span of half a mile we can use this equation: (1/69)*0.5 which equals 0.00725
        // one mile = 1609 m
        //
        let regionRadius : CLLocationDistance = (1000.0 * 1000.0 )
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(focusCoordinate, regionRadius, regionRadius)
        self.mapKitView.setRegion(coordinateRegion, animated: true)
        
        //  Add all annotation for each city
        if let count = self.viewModel?.numberOfCity, count > 0 {
            
            for index in 0..<count {
            
                if let latitude = self.viewModel?.latitude(inControllerAt: index), let longitude = self.viewModel?.longitude(inControllerAt: index) {
                    
                    //  Using my own MKPointAnnotation sub-class
                    let annotation = OSLPointAnnotation()
                
                    annotation.tagIdentifier = index
                    
                    let coordinate = CLLocationCoordinate2D( latitude: latitude, longitude: longitude)
                    
                    annotation.coordinate = coordinate
                    annotation.title = self.viewModel?.cityName(inControllerAt: index)
                    annotation.subtitle = NSLocalizedString("From ", comment: "") + (self.viewModel?.temperatureMin(inControllerAt: index) ?? String.empty)
                    annotation.subtitle? += NSLocalizedString("To ", comment: "") + (self.viewModel?.temperatureMax(inControllerAt: index) ?? String.empty)
                
                    //print("Add annotation: index=\(index), name=\(self.viewModel?.cityName(inControllerAt: index))")
                    self.mapKitView.addAnnotation(annotation)
                }
            }
        }
        
        //  Camera
        let distance: CLLocationDistance = 25000
        let pitch: CGFloat = 65
        let heading = 0.0

        let camera = MKMapCamera( lookingAtCenter: focusCoordinate, fromDistance: distance, pitch: pitch, heading: heading )

        self.mapKitView.setCamera(camera, animated: true )

    }
    
    //  MARK: - Internals
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        var tagIdentifier : Int?
        var pinView : MKAnnotationView?

        //  If we are displaying the user location, return nil so map view draws "blue dot"
        if annotation is MKUserLocation {
            return nil
        }

        if let pointAnnotation = annotation as? OSLPointAnnotation {
            
            tagIdentifier = pointAnnotation.tagIdentifier
        }
        
        
        if let image = self.viewModel?.photoCover(inControllerAt: tagIdentifier) {
            
            pinView = mapView.dequeueReusableAnnotationView(withIdentifier: kCustomAnnotation)
            if pinView == nil {
                
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: kCustomAnnotation)
            }
        
            //  Set the image for my custom AnnotationView
            pinView?.image = image
            pinView?.frame.size = CGSize(width:45, height:45)
        }
        else {

            pinView = mapView.dequeueReusableAnnotationView(withIdentifier: kCustomPinAnnotation)
            if pinView == nil {

                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: kCustomPinAnnotation)
            }
        }

        //  Common infos to display
        pinView?.annotation = annotation
        pinView?.canShowCallout = true
        
        //  Set the left image
        if let tagIdentifier = tagIdentifier {
            
            let imageView = UIImageView(image: self.viewModel?.currentWeatherImage(inControllerAt: tagIdentifier) )
            pinView?.leftCalloutAccessoryView = imageView
            pinView?.leftCalloutAccessoryView?.frame.size = CGSize(width:30, height:30)
        }
        
        return pinView
    }

    //  MARK: - IBActions
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            self.mapKitView.mapType = MKMapType.hybrid
            
        case 1:
            self.mapKitView.mapType = MKMapType.standard
            
        default:
            break
        }
    }
}
