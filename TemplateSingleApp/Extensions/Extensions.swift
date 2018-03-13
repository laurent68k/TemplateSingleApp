//
//  Extensions.swift
//  Meteo Kids
//
//  Created by Laurent Favard on 04/01/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//

import Foundation


public extension String {
    
    static let empty = ""
    
    /**
     Return the translated string if any
     */
    var asLocalizable : String {
        
        return NSLocalizedString( self, comment:"")
    }
}

extension Int {
    
    static postfix func ++ (right: inout Int) -> Int {
        
        let tmp = right
        
        right = right + 1
        return tmp
    }
    static prefix func ++ (left: inout Int) -> Int {
        
        left = left + 1
        return left
    }
    
    static postfix func -- (right: inout Int) -> Int {
        
        let tmp = right
        
        right = right - 1
        return tmp
    }
    static prefix func -- (left: inout Int) -> Int {
        
        left = left - 1
        return left
    }
}

extension Double {
    
    var asTemperature : String {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        
        return formatter.string(from: NSNumber(value: self)) ?? String.empty
    }
}
