//
//  ViewController.swift
//  TemplateSingleAp
//
//  Created by Laurent Favard on 13/03/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import Spring
import StoreKit

class MainViewController: AncestorViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageViewApple: UIImageView!
    @IBOutlet weak var localisationLabel: UILabel!
    //---------------------------------------------------------------------------------------------------------------------------------------------
    static let kApplicationDidBecomeActive = "applicationDidBecomeActive"
    //---------------------------------------------------------------------------------------------------------------------------------------------
    var viewModel = MainViewModel()
    //---------------------------------------------------------------------------------------------------------------------------------------------
    private var longPressGestureRecognizer : UILongPressGestureRecognizer?
    private var simpleTapGestureRecognizer : UITapGestureRecognizer?
    private var doubleTapGestureRecognizer : UITapGestureRecognizer?
    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //self.activateLocation()
        
        self.addRefreshControl( forScrollView: mainScrollView )
        self.addRxObservers()
        self.addGestures()
        self.addActivityIndicator(viewParent: self.view)
    
        //  Initial Refresh data request
        self.refresh(withMiddleIndicator: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        AudioServicesPlaySystemSound (1104)
        
        //  Try to ask to rate this App
        if #available(iOS 10.3, *) {
            if Settings.numberOfSessions() % Settings.kNumberOfSessions == 0 {
                
                Settings.saveSessions(number: 1)
                SKStoreReviewController.requestReview()
            }
        }
        else {
            // Fallback on earlier versions
        }
        
        (self.imageViewApple as? SpringImageView)?.animation = "slideDown"
        (self.imageViewApple as? SpringImageView)?.duration = 2
        (self.imageViewApple as? SpringImageView)?.animate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  Good citizen...
    deinit {
        
        if let gesture = self.longPressGestureRecognizer {
            
            self.imageViewApple.removeGestureRecognizer(gesture)
        }
        if let gesture = simpleTapGestureRecognizer {
            
            self.imageViewApple.removeGestureRecognizer(gesture)
        }
        
        if let gesture = doubleTapGestureRecognizer {
            
            self.imageViewApple.removeGestureRecognizer(gesture)
        }
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    
    //  Called when App become back active
    override func applicationDidBecomeActive() {
        
    }
    
    //  Called when App enter background
    override func applicationDidEnterBackground() {
        
    }
    
    override func pullRefreshControl(_ sender: AnyObject?) {
        
        self.refresh()
    }

    override func locationUpdated(cityName:String, cityCoordinate: String) {
        
        self.localisationLabel.text = "\(cityName), \(cityCoordinate)"
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - RxObservers
    private func addRxObservers() {
        
//        self.viewModel?.variablehere.asObservable().subscribe(onNext: {
//
//            variablehere in
//
//            self.refresh(withMiddleIndicator:true)
//
//        } ).disposed(by: self.disposeBag)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.applicationDidBecomeActive),
            name: NSNotification.Name(rawValue: MainViewController.kApplicationDidBecomeActive),
            object: nil)
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    private func refresh(withMiddleIndicator:Bool = false) {
        
        if withMiddleIndicator {
            self.activityIndicator?.startAnimating()
        }
        
        self.refreshControl.beginRefreshing()
        self.viewModel.load(completionHandler: {
            
            success in
            
            //  Stop rrefresing indicator
            self.refreshControl.endRefreshing()
            
            if withMiddleIndicator {
                self.activityIndicator?.stopAnimating()
            }
            
            if !success {
                //  Alert the user
                let alert  = UIAlertController(title: "Network.Issue".asLocalizable, message: "Network.ErrorMessage".asLocalizable, preferredStyle: .alert)
                
                alert.addAction( UIAlertAction(title: "OK".asLocalizable, style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Gestures handlers
    private func addGestures() {
        
        if self.doubleTapGestureRecognizer == nil {
            
            self.doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
            self.doubleTapGestureRecognizer?.numberOfTapsRequired = 2
            
            if let gesture = self.doubleTapGestureRecognizer {
                
                self.imageViewApple.addGestureRecognizer(gesture)
            }
        }
        
        if self.simpleTapGestureRecognizer == nil {
            
            self.simpleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleSimpleTap(_:)))
            self.simpleTapGestureRecognizer?.numberOfTapsRequired = 1
            
            if let doubleTapGestureRecognizer = self.doubleTapGestureRecognizer {
                self.simpleTapGestureRecognizer?.require(toFail: doubleTapGestureRecognizer)
            }
            
            if let gesture = self.simpleTapGestureRecognizer {
                
                self.imageViewApple.addGestureRecognizer(gesture)
            }
        }
        
        if self.longPressGestureRecognizer == nil {
            
            self.longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
            self.longPressGestureRecognizer?.minimumPressDuration = 1
            self.longPressGestureRecognizer?.delaysTouchesBegan = true
            
            if let gesture = self.longPressGestureRecognizer {
                
                self.imageViewApple.addGestureRecognizer(gesture)
            }
        }
    }
    
    //  Callback called when the gesture long press is raised
    @objc func handleLongPress(_ gestureRecognizer : UILongPressGestureRecognizer) {
        
    }
    
    //  Callback called when the 1-tap gesture is raised
    @objc func handleSimpleTap(_ gestureRecognizer : UITapGestureRecognizer) {
        
    }
    
    //  Callback called when the 1-tap gesture is raised
    @objc func handleDoubleTap(_ gestureRecognizer : UITapGestureRecognizer) {
        
    }

    @IBAction func shareItemAction(_ sender: UIBarButtonItem) {
        
        if let image = self.imageViewApple.image {
         
            self.shareData(sender, image: image)
        }
    }
    
    @IBAction func eventKitAction(_ sender: UIBarButtonItem) {
        
        let customEventKit = CustomEventKit()
        
        customEventKit.dateStart = Date()
        customEventKit.dateEnd = Date().addingTimeInterval(TimeInterval(60))
        customEventKit.title = "Example of event"
        
        self.addCalendar(event: customEventKit) {
            
            (success) in
            
            let message = ( success ? "Event.Added" : "Event.Failed" )
            
            //  Alert the user
            let alert  = UIAlertController(title: "Calendar".asLocalizable, message: message.asLocalizable, preferredStyle: .alert)
            
            alert.addAction( UIAlertAction(title: "OK".asLocalizable, style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)

        }
    }
}

