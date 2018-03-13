//
//  AboutViewController.swift
//  Meteo Kids
//
//  Created by Laurent Favard on 16/01/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import StoreKit

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    @IBOutlet weak var giveOpinionButton: UIButton!
    //---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Initialisers
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 10.3, *) {
            self.giveOpinionButton.isHidden = false
        }
        else {
            self.giveOpinionButton.isHidden = true
        }
    }
    
    //  MARK: - IBAction
    @IBAction func sendMail(_ sender: UIButton) {
        
        let mailComposer = MFMailComposeViewController()
        
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["laurent68k.ios@gmail.com"])
        mailComposer.setSubject((Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String) ?? "Little Kids")
        mailComposer.setMessageBody(NSLocalizedString("Hi Laurent, I would like to share with you the followings:\n\n", comment:""), isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            
            self.present(mailComposer, animated: true, completion: nil)
        }
    }
    
    @IBAction func giveNote() {
    
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
        else {
            // Fallback on earlier versions
        }
    }
    
    //  MARK: - Internal Functions
    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    //  MARK: - Public Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let locationPoint = touch.location(in: self.view)
            let subView = self.view.hitTest(locationPoint, with: event)
            
            if subView === self.view {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}
