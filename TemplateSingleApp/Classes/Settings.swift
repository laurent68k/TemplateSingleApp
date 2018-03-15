//
//  Settings.swift
//  Meteo Kids
//
//  Created by etudiant on 19/01/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//

import Foundation
import UIKit

class Settings {
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    private static var kResourcesDefault = "ResourcesDefault"
    private static var kNumberOfSessionsKey = "NumberOfSessions"
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    static var kNumberOfSessions = 30
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// functions to save/load any JSon content in UserDefaults
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    /**
     Read from the user settings the JSonResourcesDefault data or from the default App's JSon
    */
    class func jsonFromUserDefaults() -> JSonResourcesDefault {
    
        let jsonDecoder = JSONDecoder()
        let data = UserDefaults.standard.data(forKey: Settings.kResourcesDefault)
        
        //  try to read the cities list from user settings
        if let data = data {
            
            let jsonExample = try? jsonDecoder.decode( JSonResourcesDefault.self, from: data)
            
            if let jsonExample = jsonExample {
                
                return jsonExample
            }
        }

        //  Otherwise use the default json embedded inside the application
        if let filepath = Bundle.main.path(forResource: Settings.kResourcesDefault, ofType: "json") {
            
            let data = try? Data(contentsOf: URL(fileURLWithPath: filepath) )
            if let data = data {
                
                let jsonExample = try? jsonDecoder.decode( JSonResourcesDefault.self, from: data)
                
                if let jsonExample = jsonExample {
                    
                    return jsonExample
                }
            }
        }
        
        return JSonResourcesDefault()
    }
    
    /**
     Save the user JSonResourcesDefault data
     */
    class func saveJsonUserDefaults(jsonExample:JSonResourcesDefault?) {
        
        if let jsonExample = jsonExample {
            
            let jsonEncoder = JSONEncoder()
            let data = try? jsonEncoder.encode(jsonExample)
            if let data = data {
             
                UserDefaults.standard.set(data, forKey: Settings.kResourcesDefault)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// functions to save/load any file content in sandbox
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    class func loadFromSandbox(inDocumentName: String ) -> JSonResourcesDefault {
        
        var documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        documentDirectory?.appendPathComponent(inDocumentName)
        
        print("loadFromSandbox: file url: \(String(describing: documentDirectory?.absoluteString))")

        if let documentDirectory = documentDirectory {
            let file = try? Data(contentsOf: documentDirectory )
            if let file = file {
                let jsonDecoder = JSONDecoder()
                let jsonExample = try? jsonDecoder.decode(JSonResourcesDefault.self, from:file)
                
                if let jsonExample = jsonExample, jsonExample.items.count > 0 {
                    
                    print("jsonExample:\(jsonExample.items.count)")
                    return jsonExample
                }
            }
        }
        return JSonResourcesDefault()
    }
    
    class func saveInSandbox( inDocumentName: String, jsonExample:JSonResourcesDefault ) {
        
        var documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        documentDirectory?.appendPathComponent(inDocumentName)
        
        print("saveInSandbox: file url: \(String(describing: documentDirectory?.absoluteString))")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(jsonExample)
        if let data = data, let documentDirectory = documentDirectory {
            
            do {
                try data.write(to: documentDirectory)
            }
            catch let error {
                
                //  Unable to decode, we let fall, too bad.
                print(error.localizedDescription)
            }
        }
    }

    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// functions to save/load/delete image file in sandbox
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    /**
     Get the file image from Documents
     */
    class func fileImageFrom(forCity name:String) -> Data? {
        
        guard !name.isEmpty else {
        
            return nil
        }
        
        var documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:true)
        let file = "\(name).jpg"
            
        documentDirectory?.appendPathComponent(file)
        
        print("reading from: \(String(describing: documentDirectory?.absoluteString))")
        
        var data : Data?
        if let document = documentDirectory {
        
            data = try? Data(contentsOf: document)
        }
        return data
    }
    
    /**
     Save the file image in Documents
     */
    class func saveFileImage(_ data:Data?, forCity name:String) {
        
        guard !name.isEmpty else {
            
            return
        }
        
        var documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:true)
        let file = "\(name).jpg"
        
        documentDirectory?.appendPathComponent(file)
        
        print("writing from: \(String(describing: documentDirectory?.absoluteString))")

        if let document = documentDirectory {
         
            try? data?.write(to: document)
        }
    }

    /**
     Remove the file image in Documents
     */
    class func deletePhotoCover(forCity name:String) {
        
        guard !name.isEmpty else {
            
            return
        }
        
        var documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:true)
        let file = "\(name).jpg"
        
        documentDirectory?.appendPathComponent(file)
        
        print("deleting from: \(String(describing: documentDirectory?.absoluteString))")
        
        if let document = documentDirectory {
            
            try? FileManager.default.removeItem(at: document)
        }
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    class func numberOfSessions() -> Int {
        
        return UserDefaults.standard.integer(forKey: Settings.kNumberOfSessionsKey)
    }
    
    class func saveSessions(number count:Int) {
        
        UserDefaults.standard.set(count, forKey: Settings.kNumberOfSessionsKey)
    }

}
