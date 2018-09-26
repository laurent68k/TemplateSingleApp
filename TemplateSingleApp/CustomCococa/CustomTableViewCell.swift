//
//  EventTableViewCell.swift
//  Nomad Education
//
//  Created by Laurent Favard on 05/03/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//


import UIKit
import RxSwift

class CustomTableViewCell: XIBTableViewCell {

    static let preferedHeight = CGFloat(64)
    
    @IBOutlet weak var customLabel: UILabel!
    
    var customText : String = "" {
        
        didSet {
            self.customLabel.text = customText
        }
    }

    //
    //  Initializer
    //

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style:style, reuseIdentifier:reuseIdentifier)
    }
    
    required init?(coder aCoder: NSCoder) {

        super.init(coder: aCoder)
    }
    
    override func prepareForReuse() {
        
        self.customLabel.text = ""
    }
    
    /**
     Reuse identifier to use in TableView while dequeuing
     */
    override class func reuseIdentifier() -> String {
        
        return "CustomTableViewCell"
    }
    
    /**
     Register to the TableView this kind of cell
     */
    override class func register(to tableView:UITableView) {
        
        let className = String(describing: CustomTableViewCell.self)
        
        tableView.register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: CustomTableViewCell.reuseIdentifier())
    }
}
