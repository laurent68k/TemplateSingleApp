//
//  HomeViewLayout.swift
//  PizzaCheese
//
//  Created by etudiant on 16/02/2018.
//  Copyright © 2018 etudiant. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewLayout {

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    var delegate : CollectionViewController?
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    func sizeForItemAt(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 64, height: 64)
    }
    
    func minimumLineSpacingForSection() -> CGFloat {
        
        return 0.0
    }
    
    func minimumInteritemSpacingForSectionAt() -> CGFloat {
        
        return 0.0
    }
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
}
