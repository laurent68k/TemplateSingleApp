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
    var gpsCityName = Variable<String?>(nil)
    var cityCoordinate = Variable<String?>(nil)
    var jsonNetwork = Variable<JSonNetwork?>(nil)
    // ---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Private Variables
    private var jsonRequestor = JsonRequestor.sharedInstance
    // ---------------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - Computed accessors for display
    // ---------------------------------------------------------------------------------------------------------------------------------------------
    //  Observable ZIP when the both value has changed
    //  (http://reactivex.io/documentation/operators/zip.html)
    var isGpsValid : Observable<Bool> {
        
        return Observable.zip(self.gpsCityName.asObservable(), self.cityCoordinate.asObservable(), resultSelector: {
            
            gpsCityName, cityCoordinate in
            
            (gpsCityName != nil) && (cityCoordinate != nil)
        } )
    }

    var accessorExample : String {
        
        return ""
    }


    // ---------------------------------------------------------------------------------------------------------------------------------------------

    //  MARK: - Initializers
    init() {
        
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Private functions
    

    func upateLocation(cityName:String, cityCoordinate: String) {
        
        self.gpsCityName.value = cityName
        self.cityCoordinate.value = cityCoordinate
    }
    
    /**
        Start the model data downloading
     */
    func load(completionHandler closure: @escaping( (_ success:Bool) -> Void)) {

        let urlPostfix = "One"
        self.jsonRequestor.downloadInformations(forSingle: urlPostfix) {
            
            jsonNetwork in
            
            self.jsonNetwork.value = jsonNetwork
            
            closure( jsonNetwork != nil )
        }
    }
}

