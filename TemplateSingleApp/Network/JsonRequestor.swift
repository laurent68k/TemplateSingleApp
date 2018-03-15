//
//  CityRequestor.swift
//  Meteo Kids
//
//  Created by Laurent Favard on 04/01/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//

import Foundation
import Alamofire


/// ---------------------------------------------------------------------------------------------------------------------------------------------

class JsonRequestor : Requestor {
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    static var sharedInstance = JsonRequestor()
    private static let urlItunes = "https://itunes.apple.com/search?term=Metallica+One&entity=song"
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - Initializers
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    private override init() {

        //  Private for Singleton class
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    /**
        Download the informations for a city given. Execute the closure with the City filled or nil.
     */
    func downloadInformations(forSingle single: String, completionHandler closure: @escaping( (_ city:JSonNetwork?) -> Void) ) {
        
        do {
            let queryURL = String(format: JsonRequestor.urlItunes, single)

            try self.downloadData(at: queryURL, completionHandler: {
                
                data in
                
                if let data = data {
                    
                    do {
                        //  Parse JSon data
                        let jsonDecoder = JSONDecoder()
                        let jsonNetwork = try jsonDecoder.decode( JSonNetwork.self, from: data)
                        
                        if (jsonNetwork.resultCount > 0 ) {
                            
                            //  Request the main thread in order to access to the UI
                            closure(jsonNetwork)
                        }
                        else {
                            
                            closure(nil)
                        }
                    }
                    catch let error {
                        
                        //  Unable to decode, we let fall, too bad.
                        print(error.localizedDescription)
                        closure(nil)
                    }
                }
                else {
                    closure(nil)
                }
            })
        }
        catch RequestorException.InvalidUrl(let url) {
            
            print("URL is invalid: \(url)")
        }
        catch RequestorException.Others(let message) {
            
            print("Others CityRequestorException exeption: \(message)")
        }
        catch let error {
            
            print("\(error.localizedDescription)")
        }
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    /**
        Download image at the specified URL.
     */
    func downloadImage(at url: String, completionHandler closure: @escaping (UIImage?) -> Void) {
        
        //  Using Alamofire with validate to ensure that the response is in range of 200-299 code
        AFManager.request( url ).validate().responseData {
            
            response in
            
            switch response.result {
                
            case .success:
                if let data = response.result.value, let image = UIImage(data: data as Data) {
                    
                    closure(image)
                }
            case .failure:
                closure(nil)
            }
        }
    }
}

