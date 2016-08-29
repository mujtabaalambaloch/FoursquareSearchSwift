//
//  ViewController.swift
//  FourSquareAPI
//
//  Created by Mujtaba Alam on 8/27/16.
//  Copyright © 2016 Mujtaba Alam. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ViewModel()
    
    var locationManager:CLLocationManager?
    let zoomLevel:Double = 500
    
    var callOnce = false
    
    // MARK: Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.mapView.delegate = self
        
        if self.locationManager == nil {
            self.locationManager = CLLocationManager();
            self.locationManager!.delegate = self;
            self.locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            self.locationManager!.requestAlwaysAuthorization();
            self.locationManager!.distanceFilter = 50;
            self.locationManager!.startUpdatingLocation();
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TableView Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel!.attributedText = self.viewModel.nameAtIndex(indexPath)
        cell.detailTextLabel!.text = self.viewModel.distanceAtIndex(indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let venue = self.viewModel.venueAtIndex(indexPath)
        
        let coordinate = CLLocationCoordinate2D(latitude: venue.latitude!, longitude: venue.longitude!)
        
        self.regionWithDistance(coordinate, latMeters: zoomLevel, lngMeters: zoomLevel)
        
        for annotation in self.mapView.annotations {
            if annotation.coordinate.latitude == coordinate.latitude
                && annotation.coordinate.longitude == coordinate.longitude {
                self.mapView.selectAnnotation(annotation, animated: true)
                break
            }
        }
    }
    
    // MARK: Location Manager Methods
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        if !self.callOnce {
            self.callAPI(newLocation.coordinate)
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.Denied {
            
            let alert = UIAlertController(title: "Location Required", message: "You must turn location on to use this service", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) in
                let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString)!
                UIApplication.sharedApplication().openURL(settingsURL)
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    // MARK: Set Region
    
    func regionWithDistance(location:CLLocationCoordinate2D, latMeters:Double, lngMeters:Double) {
        let region = MKCoordinateRegionMakeWithDistance(location, latMeters, lngMeters)
        self.mapView.setRegion(region, animated: true)
    }
    
    // MARK: Call API Methods
    
    func callAPI(location: CLLocationCoordinate2D) -> Void {
        
        self.showLoading(self.tableView)
        
        self.tableView.userInteractionEnabled = false
        
        self.viewModel.apiCall(location.latitude, longitude: location.longitude) { (success) in
            
            self.hideLoading(self.tableView)
        
            self.tableView.userInteractionEnabled = true
            
            if (success != nil) {
                
                self.callOnce = true
                for venue in self.viewModel.venuesArray() {
                    
                    let coordinate = CLLocationCoordinate2D(latitude: venue.latitude!, longitude: venue.longitude!)
                    
                    let annotation = MapAnnotation(title: venue.name, subtitle: venue.address, coordinate: coordinate)
                    
                    self.mapView.addAnnotation(annotation)
                    
                    let zoomOut = self.viewModel.zoomOut()
                    self.regionWithDistance(location, latMeters: zoomOut, lngMeters: zoomOut)
                }
                
                self.tableView.reloadData()
            } else {
                self.regionWithDistance(location, latMeters: self.zoomLevel, lngMeters: self.zoomLevel)
            }
        }
    }
    
    
    // MARK: Show / Hide Loading
    
    func showLoading(view:UIView) -> Void {
        MBProgressHUD.hideHUDForView(view, animated: true)
        MBProgressHUD.showHUDAddedTo(view, animated: true)
    }
    
    func hideLoading(view:UIView) -> Void {
        MBProgressHUD.hideHUDForView(view, animated: true)
    }
    
}
