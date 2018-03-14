//
//  XIBTableViewCell.swift
//  Nomad Education
//
//  Created by Laurent Favard on 05/03/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//


import UIKit

/**
 Base class for implementing easily your own XIB UITableViewCell
 */
class XIBTableViewCell : UITableViewCell {
    
    /**
        represent any free user object 
      */
    var anyObject : Any?
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Initializers
    
//    init(frame: CGRect) {
//        
//        super.init(frame: frame)
//    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style:style, reuseIdentifier:reuseIdentifier)
    }
    
    required init?(coder aCoder: NSCoder) {
        
        super.init(coder: aCoder)
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Class functions to override for a UITableView for instance.
    /**
     Reuse identifier to use in UITableView for dequeuing
     */
    class func reuseIdentifier() -> String {
      
        //  Override this identifier in the sub-class
        return "XIBTableViewCell"
    }

    /**
     Register to the UITableView this kind of cell: Must be override
     */
    class func register(to tableView:UITableView) {
        
        let className = String(describing: XIBTableViewCell.self)
        
        tableView.register( UINib(nibName: className, bundle: nil), forCellReuseIdentifier: reuseIdentifier())
    }
}
