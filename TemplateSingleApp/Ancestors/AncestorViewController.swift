//
//  AncestorViewControlleur.swift
//  Meteo Kids
//
//  Created by Laurent Favard on 05/01/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//

import UIKit
import RxSwift

class AncestorViewController: UIViewController {
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    var activityIndicator : OSLActivityIndicatorView?
    let disposeBag = DisposeBag()
    let refreshControl = UIRefreshControl()
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        
        //self.unregisterGesturesRecognizers()
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    func addRefreshControl(forScrollView scrollView:UIScrollView?) {
        
        if let scrollView = scrollView {
            
            self.refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Loading...", comment: ""))
            self.refreshControl.addTarget(self, action: #selector(self.pullRefreshControl(_:)), for: UIControlEvents.valueChanged)
            
            if #available(iOS 10.0, *) {
                scrollView.addSubview(self.refreshControl)
                scrollView.refreshControl = self.refreshControl
            }
            else {
                
            }
        }
    }

    @objc func pullRefreshControl(_ sender:AnyObject?) {
        
        //  OVERRIDE ME
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
                let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: viewParent, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
                
                let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: viewParent, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
                
                viewParent.addConstraint(horizontalConstraint)
                viewParent.addConstraint(verticalConstraint)
                
                viewParent.bringSubview(toFront: activityIndicator)
            }
        }
    }
    
    /**
     Handle the photo shoot
     */
    func shareData(_ sender:Any, image:UIImage) {
        
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {

            let data : [Any] = ["Text to share", imageData]
            let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
    
            activityController.excludedActivityTypes = [UIActivityType.postToFacebook,
                                                        UIActivityType.postToTwitter,
                                                        UIActivityType.postToWeibo,
                                                        UIActivityType.print,
                                                        UIActivityType.assignToContact,
                                                        UIActivityType.addToReadingList,
                                                        UIActivityType.postToFlickr,
                                                        UIActivityType.postToVimeo,
                                                        UIActivityType.postToTencentWeibo]
        
            if let popoverPresentationController = activityController.popoverPresentationController {
                
                popoverPresentationController.sourceView = (sender as? UIView)
            }
        
            present(activityController, animated: true, completion: nil)
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
