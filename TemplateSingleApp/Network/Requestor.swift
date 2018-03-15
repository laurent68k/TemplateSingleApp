//
//  Requestor.swift
//  Meteo Kids
//
//  Created by Laurent Favard on 18/01/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//

import Foundation
import Alamofire

/// ---------------------------------------------------------------------------------------------------------------------------------------------
enum RequestorException : Error {
    
    case    InvalidUrl(url:String)
    case    Others(message:String)
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------
class Requestor {
 
    var AFManager : SessionManager {
        
        get {
            let manager = Alamofire.SessionManager.default
            
            if #available(iOS 11.0, *) {
                manager.session.configuration.waitsForConnectivity = false
            }
            else {
                // Fallback on earlier versions
            }
            manager.session.configuration.timeoutIntervalForResource = 4
            manager.session.configuration.timeoutIntervalForRequest = 60
            
            return manager
        }
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - Public methods
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    /**
        Perform the download of data
     */
    func downloadData(at queryURL: String, completionHandler closure: @escaping( (_ data: Data?) -> Void) ) throws {
        
        if let percentEncodedURL = queryURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: percentEncodedURL) {
            
            print("\(url)")

            AFManager.request( url ).validate().responseData {
                
                response in
                
                switch response.result {
                    
                case .success:
                    closure(response.result.value)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    closure(nil)
                }
            }
        }
        else {
            throw RequestorException.InvalidUrl(url: queryURL)
        }
    }

}
