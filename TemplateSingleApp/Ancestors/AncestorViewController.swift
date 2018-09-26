//
//  AncestorViewControlleur.swift
//  Meteo Kids
//
//  Created by Laurent Favard on 05/01/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//

import UIKit
import RxSwift
import EventKit
import CoreLocation

class AncestorViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    private var observers = [NSObjectProtocol]()
    private var geolocalisation : Geolocalisation?
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    var activityIndicator : OSLActivityIndicatorView?
    let disposeBag = DisposeBag()
    let refreshControl = UIRefreshControl()
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.activateLocation()
        
        //  Add an event observer to receive personnal event
        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        
        self.observers.append( notificationCenter.addObserver(forName: NSNotification.Name(rawValue: ObserversName.applicationDidEnterBackground.rawValue), object: nil, queue: mainQueue)
        {
            [unowned self] _ in
            
            self.applicationDidEnterBackground()
        })
        
        self.observers.append( notificationCenter.addObserver(forName: NSNotification.Name(rawValue: ObserversName.applicationDidBecomeActive.rawValue), object: nil, queue: mainQueue)
        {
            [unowned self] _ in
            
            self.applicationDidBecomeActive()
        })

    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    //  Good citizen...
    deinit {
        
        for observer in self.observers {
            
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - To override

    //  Called when App become back active
    @objc func applicationDidBecomeActive() {
        
        //  OVERRIDE ME
    }

    //  Called when App enter background
    @objc func applicationDidEnterBackground() {
        
        //  OVERRIDE ME
    }

    @objc func pullRefreshControl(_ sender:AnyObject?) {
        
        //  OVERRIDE ME
    }

    func imageCaptured(image:UIImage) {
        
        //  OVERRIDE ME
    }

    func locationUpdated(cityName:String, cityCoordinate: String) {
        
        print("cityName:\(cityName), cityCoordinate: \(cityCoordinate)")
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    ///    Functions to mamange the delegate for CLLocationManagerDelegate
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        self.geolocalisation?.locationManager(manager, didFailWithError: error as NSError)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.geolocalisation?.locationManager(manager, didUpdateLocations: locations)
        
    }
    
    func locationManager(_ manager: CLLocationManager,  didChangeAuthorization status: CLAuthorizationStatus) {
        
        self.geolocalisation?.locationManager(manager, didChangeAuthorizationStatus: status)
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    func addRefreshControl(forScrollView scrollView:UIScrollView?) {
        
        if let scrollView = scrollView {
            
            self.refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Loading...", comment: ""))
            self.refreshControl.addTarget(self, action: #selector(self.pullRefreshControl(_:)), for: UIControl.Event.valueChanged)
            
            if #available(iOS 10.0, *) {
                scrollView.addSubview(self.refreshControl)
                scrollView.refreshControl = self.refreshControl
            }
            else {
                
            }
        }
    }

    func delay(delay: Double, closure: @escaping () -> ()) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    func start3DRotateAnimation(forObject: UIView, withDuration duration: TimeInterval = 10) {
        
        if forObject.layer.animation(forKey: "r3") == nil {
            
            let animation = CABasicAnimation(keyPath: "transform.rotation.y")
            
            animation.fromValue = 0.0
            animation.toValue = CGFloat(.pi * 2.0)
            
            animation.duration = duration
            animation.repeatCount = Float.greatestFiniteMagnitude
            
            forObject.layer.add(animation, forKey: "r3")
        }
    }
    
    func activateLocation() {
        
        self.geolocalisation = Geolocalisation(view: self, delegate: self, notificationHandler: {
            
            [unowned self ] cityName, cityCoordinate  in
            
            self.locationUpdated(cityName:cityName, cityCoordinate: cityCoordinate)
        })
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    /**
     Add programmaticaly an UIActivityIndicatorView
     */
    func addActivityIndicator(viewParent:UIView) {
        
        //  If not already created
        if self.activityIndicator == nil {
            
            self.activityIndicator = OSLActivityIndicatorView()
            
            //  Unwrap to manipulate easily
            if let activityIndicator = self.activityIndicator {
                
                //  Set my preferrences
                activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                
                viewParent.addSubview(activityIndicator)
                
                //  finally add the constraints for the UI
                let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewParent, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
                
                let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewParent, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
                
                viewParent.addConstraint(horizontalConstraint)
                viewParent.addConstraint(verticalConstraint)
                
                viewParent.bringSubviewToFront(activityIndicator)
            }
        }
    }
    
    /**
     Handle the photo shoot
     */
    func shareData(_ sender:Any, image:UIImage) {
        
        if let imageData = image.jpegData(compressionQuality: 1.0) {

            let data : [Any] = ["Text to share", imageData]
            let activityController = UIActivityViewController(activityItems: data, applicationActivities: nil)
    
            activityController.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook,
                                                        UIActivity.ActivityType.postToWeibo,
                                                        UIActivity.ActivityType.assignToContact,
                                                        UIActivity.ActivityType.addToReadingList,
                                                        UIActivity.ActivityType.postToFlickr,
                                                        UIActivity.ActivityType.postToVimeo,
                                                        UIActivity.ActivityType.postToTencentWeibo]
        
            if let popoverPresentationController = activityController.popoverPresentationController {
                
                popoverPresentationController.sourceView = (sender as? UIView)
            }
        
            present(activityController, animated: true, completion: nil)
        }
    }
    
    /**
     Handle the photo shoot
     */
    func shootPhoto() {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            
            let alert  = UIAlertController(title: "AlertController.Camera.Title.Error".asLocalizable, message: "AlertController.Camera.NoCamera".asLocalizable, preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "AlertController.OK".asLocalizable, style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        if let editedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            
            self.imageCaptured(image: editedImage)
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil )
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    /**
     Add a new event in the iOS calendar
     */
    func addCalendar(event schoolEvent: CustomEventKit, completionHandler: @escaping( (Bool) -> Void ) ) {
        
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) {
            
            (granted, error) in
            
            if (granted) && (error == nil) {
                
                let ekEvent = EKEvent(eventStore: eventStore)
                
                ekEvent.title = schoolEvent.title
                ekEvent.startDate = schoolEvent.dateStart
                ekEvent.endDate = schoolEvent.dateEnd
                ekEvent.notes = schoolEvent.notes
                ekEvent.calendar = eventStore.defaultCalendarForNewEvents
                
                if let address = schoolEvent.address {
                    
                    ekEvent.structuredLocation = EKStructuredLocation()
                    ekEvent.structuredLocation?.title = address.cityName + ", " + address.streetAddress
                }
                
                do {
                    try eventStore.save(ekEvent, span: .thisEvent, commit: true)
                    completionHandler(true)
                }
                catch {
                    completionHandler(false)
                }
            }
            else {
                
                completionHandler(false)
            }
        }
    }

}

extension AncestorViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let popoverController = segue.destination.popoverPresentationController, let button = sender as? UIButton {
            
            popoverController.delegate = self
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
        }
        
        super.prepare(for: segue, sender: sender)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
