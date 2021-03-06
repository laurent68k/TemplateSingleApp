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
    @IBOutlet weak var itunesLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var infoBtnItem: UIBarButtonItem!
    @IBOutlet weak var settingsBtnItem: UIBarButtonItem!
    @IBOutlet weak var cameraBtnItem: UIBarButtonItem!
    @IBOutlet weak var shareBtnItem: UIBarButtonItem!
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
        
        self.customizeToolBarItems()
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

    override func imageCaptured(image: UIImage) {
    
        self.photoImageView.image = image
    }
    
    override func locationUpdated(cityName:String, cityCoordinate: String) {
        
        self.viewModel.upateLocation(cityName:cityName, cityCoordinate: cityCoordinate)
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    /*
     TEST: ToolBar item with image and text
     */
    private func customizeToolBarItems() {
        
        //  Settings Item
        let button =  UIButton(type: .custom)
        button.setImage(UIImage(named: "info"), for: .normal)
        button.frame = CGRect(x:0, y:0, width:50, height:30)
        button.tintColor = UIColor.black
        button.backgroundColor = UIColor.red
        
        let label = UILabel(frame: CGRect(x:3, y:20, width:47, height:20))
        label.font = UIFont(name: "Arial-BoldMT", size: 10)
        label.text = "About me"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.backgroundColor =   UIColor.clear
        button.addSubview(label)
        //button.addTarget(self, action: #selector(self.settingsButtonAction), for: .touchUpInside)
        self.infoBtnItem.customView = button
        
        //  Settings Item
        let button2 = UIButton(type: .system)
        button2.setImage(UIImage(named: "settings"), for: .normal)
        button2.frame = CGRect(x:0, y:0, width:48, height:28)
        button2.tintColor = UIColor.black
        button2.backgroundColor = UIColor.green

        let label2 = UILabel(frame: CGRect(x:3, y:20, width:47, height:20))
        label2.font = UIFont(name: "Arial-BoldMT", size: 10)
        label2.text = "Settings"
        label2.textAlignment = .center
        label2.textColor = UIColor.black
        label2.backgroundColor =   UIColor.clear
        button2.addSubview(label2)
        //button2.addTarget(self, action: #selector(self.shareAppAction(_:)), for: .touchUpInside)
        self.settingsBtnItem.customView = button2
        
        //  Settings Item
        let button3 = UIButton(type: .system)

        //button3.addTarget(self, action: #selector(self.infoButtonAction), for: .touchUpInside)
//        self.shareBtnItem.customView = button3
        
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - RxObservers
    private func addRxObservers() {
        
//        self.viewModel?.gpsCityName.asObservable().subscribe(onNext: {
//
//            gpsCityName in
//
//            if !gpsCityName.isEmpty {
//
//                self.refresh(withMiddleIndicator:true)
//            }
//        } ).disposed(by: self.disposeBag)

        self.viewModel.jsonNetwork.asObservable().subscribe(onNext: {

            jsonNetwork in

            self.displayInformations(jsonNetwork:jsonNetwork)

        } ).disposed(by: self.disposeBag)

        self.viewModel.isGpsValid.asObservable().subscribe( {
            
            _ in
            
            self.localisationLabel.text = "\(String(describing: self.viewModel.gpsCityName.value)), \(String(describing: self.viewModel.cityCoordinate.value))"
            
        } ).disposed(by: self.disposeBag)

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
                let alert  = UIAlertController(title: "AlertController.Network.Issue".asLocalizable, message: "AlertController.Network.ErrorMessage".asLocalizable, preferredStyle: .alert)
                
                alert.addAction( UIAlertAction(title: "OK".asLocalizable, style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    private func displayInformations(jsonNetwork:JSonNetwork?) {
        
        self.itunesLabel.text = jsonNetwork?.results[0].artistName
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
    
    @IBAction func cameraAction(_ sender: UIBarButtonItem) {
        
        self.shootPhoto()
    }
    
    @IBAction func eventKitAction(_ sender: UIBarButtonItem) {
        
        let customEventKit = CustomEventKit()
        
        customEventKit.dateStart = Date()
        customEventKit.dateEnd = Date().addingTimeInterval(TimeInterval(3600))
        customEventKit.title = "Example of event"
        
        self.addCalendar(event: customEventKit) {
            
            (success) in
            
            let message = ( success ? "AlertController" : "AlertController" )
            
            //  Alert the user
            let alert  = UIAlertController(title: "AlertController".asLocalizable, message: message.asLocalizable, preferredStyle: .alert)
            
            alert.addAction( UIAlertAction(title: "AlertController.OK".asLocalizable, style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)

        }
    }
}

