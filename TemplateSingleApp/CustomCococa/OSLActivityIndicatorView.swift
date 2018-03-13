//
//  OSLActivityIndicator.swift
//  Meteo Kids
//
//  Created by Laurent Favard on 06/01/2018.
//  Copyright © 2018 Laurent68k. All rights reserved.
//

import UIKit

/**
 Represent an advanced UIActivityIndicatorView embedded in an UIView subclassed.
 */
class OSLActivityIndicatorView: UIView {

    //  -------------------------------------------------------------------------------------------------------------------------------------------
    private var activityIndicator : UIActivityIndicatorView?
    //  -------------------------------------------------------------------------------------------------------------------------------------------
    //  Accessors
    //  -------------------------------------------------------------------------------------------------------------------------------------------
    /**
     Indicates if the spinner is running
     */
    var isAnimating : Bool {
        
        return self.activityIndicator?.isAnimating ?? false
    }
    
    /**
     Spinner style
     */
    var activityIndicatorViewStyle : UIActivityIndicatorViewStyle {
        
        get {
            return self.activityIndicator?.activityIndicatorViewStyle ?? UIActivityIndicatorViewStyle.whiteLarge
        }
        set {
            self.activityIndicator?.activityIndicatorViewStyle = newValue
        }
    }
    
    /**
     Hide the spinner onf animation end
     */
    var hidesWhenStopped : Bool {
        
        get {
            return self.activityIndicator?.hidesWhenStopped ?? true
        }
        set {
            self.activityIndicator?.hidesWhenStopped  = newValue
        }
    }

    /**
     Get or set the background color
     */
    var backColor : UIColor = UIColor.darkGray {
    
        didSet {
            
            self.backgroundColor = backColor
        }
    }
    
    //  -------------------------------------------------------------------------------------------------------------------------------------------
    //  -------------------------------------------------------------------------------------------------------------------------------------------

    override init(frame: CGRect) {
        
        super.init(frame: frame)

        self.myDraw()
        self.addActivityIndicator()
    }
    
    convenience init() {
        
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  -------------------------------------------------------------------------------------------------------------------------------------------
    //  -------------------------------------------------------------------------------------------------------------------------------------------

    /**
     Start the spiner animation
     */
    func startAnimating() {
        
        self.activityIndicator?.startAnimating()
        
        self.backgroundColor = self.backColor
        self.alpha = 0.60
    }
    
    /**
     Stop the spiner animation
     */
    func stopAnimating() {
        
        self.activityIndicator?.stopAnimating()

        self.backgroundColor = .clear
    }

    //  -------------------------------------------------------------------------------------------------------------------------------------------
    //  -------------------------------------------------------------------------------------------------------------------------------------------
    
    private func myDraw() {
        
        self.backgroundColor = .clear
        self.layer.cornerRadius = 6
    }

    /**
     Add programmaticaly an UIActivityIndicatorView
     */
    private func addActivityIndicator() {
        
        //  If not already created
        if self.activityIndicator == nil {
            
            self.activityIndicator = UIActivityIndicatorView()
            
            //  Unwrap to manipulate easily
            if let activityIndicator = self.activityIndicator {
                
                //  Set my preferrences
                activityIndicator.activityIndicatorViewStyle = .whiteLarge
                activityIndicator.hidesWhenStopped = true
                activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
                self.addSubview(activityIndicator)
                
                //  finally add the constraints for the UI
                let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
                
                let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)

                let leftConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)

                let rightConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)

                self.addConstraint(horizontalConstraint)
                self.addConstraint(verticalConstraint)
                self.addConstraint(leftConstraint)
                self.addConstraint(rightConstraint)
            }
        }
    }

}
