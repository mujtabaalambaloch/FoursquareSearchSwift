//
//  SearchResponse.swift
//  FourSquareAPI
//
//  Created by Mujtaba Alam on 8/27/16.
//  Copyright © 2016 Mujtaba Alam. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class SearchResponse: Mappable {
    
    var code: Int?
    var venues : [Venue]?
    
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        venues <- map["response.venues"]
        code <- map["meta.code"]
    }

}
