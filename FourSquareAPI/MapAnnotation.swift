//
//  MapAnnotation.swift
//  FourSquareAPI
//
//  Created by Mujtaba Alam on 8/27/16.
//  Copyright © 2016 Mujtaba Alam. All rights reserved.
//

import UIKit
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    
    let title:String?
    let subtitle:String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle:String?, coordinate: CLLocationCoordinate2D) {
        self.title = title;
        self.subtitle = subtitle;
        self.coordinate = coordinate;
        
        super.init();
    }
    
}
