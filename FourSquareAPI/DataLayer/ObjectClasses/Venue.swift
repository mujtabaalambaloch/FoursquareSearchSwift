//
//  Venue.swift
//  FourSquareAPI
//
//  Created by Mujtaba Alam on 8/27/16.
//  Copyright © 2016 Mujtaba Alam. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class Venue: Mappable {

    var id : String?
    var name : String?
    var storeId : String?
    var address : String?
    var distance : Double?
    var latitude : Double?
    var longitude : Double?
    
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        storeId <- map["storeId"]
        address <- map["location.address"]
        distance <- map["location.distance"]
        latitude <- map["location.lat"]
        longitude <- map["location.lng"]
    }
    
}
