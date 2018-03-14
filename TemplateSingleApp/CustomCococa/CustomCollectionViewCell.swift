//
//  TopCollectionCellCollectionViewCell.swift
//  PizzaCheese
//
//  Created by etudiant on 15/02/2018.
//  Copyright © 2018 etudiant. All rights reserved.
//

import UIKit
import Spring

class CustomCollectionViewCell: XIBCollectionViewCell {

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    static let preferedHeight = CGFloat(128)
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var buttonShare: UIButton!
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    var shareActionHandler : ((_:CustomCollectionViewCell) -> Void)?
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    var textExample : String = "" {
        
        didSet {
            self.textLabel.text = textExample
        }
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    @IBAction func shareButton(_ sender: UIButton) {
        
        self.shareActionHandler?(self)
    }
    

    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    //
    //  Initializer
    //
    
    override func prepareForReuse() {
        
        self.textLabel.text = ""
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    /**
     Reuse identifier to use in CollectionView while dequeuing
     */
    override class func reuseIdentifier() -> String {
        
        return "CustomCollectionViewCell"
    }
    
    /**
     Register to the CollectionView this kind of cell
     */
    override class func register(to collectionView:UICollectionView) {
        
        let className = String(describing: CustomCollectionViewCell.self)
        
        collectionView.register( UINib(nibName: className, bundle: nil), forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier())
    }
}
