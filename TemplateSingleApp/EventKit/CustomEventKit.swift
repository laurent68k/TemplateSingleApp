//
//  CustomEvent.swift
//  TemplateSingleApp
//
//  Created by Laurent Favard on 13/03/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//

import Foundation

//ekEvent.title = schoolEvent.title
//ekEvent.startDate = schoolEvent.dateStart.asDate(fromFormat: MainViewModel.kDateFormatJson)
//ekEvent.endDate = schoolEvent.dateEnd.asDate(fromFormat: MainViewModel.kDateFormatJson)
//ekEvent.notes = schoolEvent.excerpt
//ekEvent.calendar = eventStore.defaultCalendarForNewEvents

class CustomEventKit: Codable {
    
    var dateStart: Date?
    var dateEnd: Date?
    var title: String = ""
    var notes : String = ""
    
    var address: CustomAddressKit? = nil
    
    enum CodingKeys: String, CodingKey {
        
        case dateStart = "dateStart"
        case dateEnd = "dateEnd"
        case title = "title"
        case notes = "notes"
    }
}

struct CustomAddressKit: Codable {
    
    var streetAddress: String = ""
    var zipCode: String = ""
    var cityName: String = ""
    var countryCode: String = ""
    var countryName: String = ""
    
    enum CodingKeys: String, CodingKey {
        case streetAddress = "streetAddress"
        case zipCode = "zipCode"
        case cityName = "cityName"
        case countryCode = "countryCode"
        case countryName = "countryName"
    }
}
