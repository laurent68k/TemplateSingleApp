//
//  JSonNetwork.swift
//  TemplateSingleApp
//
//  Created by Laurent Favard on 15/03/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//

import Foundation

/**
 Represent the root struct regarding the root
 */
struct ITunesContent: Codable {
    
    var artistName : String
    var collectionName : String
    var trackName : String
    
    var artistId : Int
    var artistViewUrl : String
    
    var artworkUrl30 : String
    var artworkUrl60 : String
    var artworkUrl100 : String
}

struct JSonNetwork : Codable {
    
    var resultCount : Int
    var results : [ITunesContent]
}


