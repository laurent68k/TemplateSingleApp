//
//  TodayViewModel.swift
//  Meteo Kids
//
//  Created by Laurent Favard on 05/01/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//

import Foundation
import RxSwift

class MainViewModel {

    // ---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Public Variables

    // ---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Private Variables

    // ---------------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - Computed accessors for display
    // ---------------------------------------------------------------------------------------------------------------------------------------------

    var accessorExample : String {
        
        return ""
    }


    // ---------------------------------------------------------------------------------------------------------------------------------------------

    //  MARK: - Initializers
    init() {
        
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Private functions
    

    func upateLocation(cityName:String, cityUrlPostfix:String) {
        
//        self.gpsUrlPostfix.value = cityUrlPostfix
//        self.gpsCityName.value = cityName                                   //  Name comming from Apple geo location
    }
    
    /**
        Start the model data downloading
     */
    func load(completionHandler closure: @escaping( (_ success:Bool) -> Void)) {

        //  Just to show the asynchronous closure execution
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            closure(true)
        }
    }
}

