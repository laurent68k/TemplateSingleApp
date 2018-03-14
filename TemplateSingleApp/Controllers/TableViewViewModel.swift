//
//  MainViewModel.swift
//  Metal Radio
//
//  Created by Laurent on 19/09/2017.
//  Copyright © 2017 Laurent68k. All rights reserved.
//

import Foundation
import RxSwift

/**
 MVVM class for the MainViewController
 */
class TableViewModel {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Public Constants
    // ---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Private Variables
    private (set) var items = Variable<[String]>(["Cell a", "Cell b", "Cell c", "Cell d"])
    private let titles = ["Cell a"]
    // ---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Public Variables
    // ---------------------------------------------------------------------------------------------------------------------------------------------

    var numberOfSections : Int {
        
        return self.titles.count
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    
    //  MARK: - Initializers
    init() {
        
        //  Nothing special to do
    }
   
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    //  MARK: - Public functions
    /**
     Start the events downloading and call the completionHandler when events has been downloaded or not after a time out for example.
     */
    func load(completionHandler closure: @escaping( (_ success:Bool) -> Void)) {
        
        //  Just to show the asynchronous closure execution
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            closure(true)
        }
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// functions for the ViewController
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    func numberOfRowsInSection(inSection section: Int) -> Int  {
    
        return self.items.value.count
    }
    
    func titleForHeaderInSection(inSection index: Int) -> String {
        
        return self.titles[index]
    }
    
    func objectTexteExampme(atIndex indexPath: IndexPath) -> String {
        
        return self.items.value[indexPath.row]
    }    
}
