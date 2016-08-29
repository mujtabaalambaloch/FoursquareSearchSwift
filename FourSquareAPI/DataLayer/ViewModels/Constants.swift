//
//  Constants.swift
//  FourSquareAPI
//
//  Created by Mujtaba Alam on 8/27/16.
//  Copyright © 2016 Mujtaba Alam. All rights reserved.
//

import Foundation

struct Constants {
    static let clientID = ""
    static let clientSecret = ""
    static let query = "restaurants"
    static let limit = String(10)
    static let categoryID = "4d4b7105d754a06374d81259" //Food
    
    static let searchVenueURL = "https://api.foursquare.com/v2/venues/search?client_id=\(clientID)&client_secret=\(clientSecret)&v=20130815&ll={lat},{lng}&categoryId=\(categoryID)&limit=\(limit)"
}