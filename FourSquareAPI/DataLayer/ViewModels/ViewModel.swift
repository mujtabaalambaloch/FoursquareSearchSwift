//
//  ViewModel.swift
//  FourSquareAPI
//
//  Created by Mujtaba Alam on 8/27/16.
//  Copyright © 2016 Mujtaba Alam. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class ViewModel: NSObject {

    private var venuesArr = [Venue]()
    
    // MARK: API Call
    
    func apiCall(latitude:Double, longitude:Double, completion: ((success : Bool!) -> Void)?) {
        
        self.venuesArr.removeAll()
        
        var newURL = replaceString(Constants.searchVenueURL, target:"{lat}", with: String(latitude))
        newURL = replaceString(newURL, target:"{lng}", with:String(longitude))
        
        Alamofire.request(.GET, newURL).responseObject { (response: Response<SearchResponse, NSError>) in
            
            let result = response.result.value
            
            if result!.code == 200 {
                self.venuesArr = (result!.venues)!
                completion!(success: true)
            } else {
                completion!(success: false)
            }
        }
    }
    
    // MARK: Replace String Method
    
    func replaceString(string:String, target:String, with:String) -> String {
        return string.stringByReplacingOccurrencesOfString(target, withString: with)
    }
    
    // MARK: TableView Data Methods
    
    func numberOfRows() -> Int {
        return self.venuesArr.count
    }
    
    func nameAtIndex(indexPath: NSIndexPath) -> NSMutableAttributedString {
        
        if self.venuesArr[indexPath.row].address != nil {
            
            let attributes = [
                NSForegroundColorAttributeName: UIColor.darkGrayColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(14.0)]
            
            let attrString = NSMutableAttributedString(string: self.venuesArr[indexPath.row].name!)
            
            let address = "\n\(self.venuesArr[indexPath.row].address!)"
            
            let addrString =  NSAttributedString(string: address, attributes: attributes)
            
            attrString.appendAttributedString(addrString)
            
            return attrString
        }
        
        return NSMutableAttributedString(string: self.venuesArr[indexPath.row].name!)
    }
    
    func distanceAtIndex(indexPath: NSIndexPath) -> String {
        let distance = (self.venuesArr[indexPath.row].distance! / 1000)
        return "\(Double(round(100 * distance)/100)) km"
    }
    
    func venueAtIndex(indexPath: NSIndexPath) -> Venue {
        return self.venuesArr[indexPath.row]
    }
    
    // MARK: Other Data Methods
    
    func zoomOut() -> Double {
        var distanceArr = [Double]()
        for venue in self.venuesArr {
            distanceArr.append(venue.distance!)
        }
        return distanceArr.maxElement()! + 5000.0
    }
    
    func venuesArray() -> [Venue] {
        return self.venuesArr
    }
    
}
