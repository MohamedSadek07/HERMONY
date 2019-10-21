//
//  MapViewController.swift
//  HERMONY
//
//  Created by 2p on 5/3/19.
//  Copyright © 2019 Magdy rizk. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import CoreLocation

class MapViewController: UIViewController ,GMSMapViewDelegate,CLLocationManagerDelegate{
  @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var currentloc = CLLocation()
    var locations = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "الخريطه"
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
         mapView.delegate = self
        self.mapView?.isMyLocationEnabled = true
//
//
//        let camera = GMSCameraPosition.camera(withLatitude: 29.88930, longitude: 31.28958, zoom: 6.0)
////        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
////        view = mapView
//        mapView.camera = camera
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 29.88930, longitude: 31.28958)
//
//        marker.map = mapView
//

       
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    
    @IBAction func pickPlace(_ sender: UIButton) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        
        present(placePicker, animated: true, completion: nil)
    }
    
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("Place name \(place.name)")
        print("Place address \(place.formattedAddress)")
        print("Place attributions \(place.attributions)")
        let location  = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
         getloc(loc: location)
        
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
    
    
    
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        currentloc = locations.last!
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        
        self.mapView?.animate(to: camera)
//        getLocations()
        getloc(loc: currentloc)
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
  
    func getloc(loc:CLLocation)   {
        self.view.lock()
        let parameters =   ["lat":loc.coordinate.latitude, "lng": loc.coordinate.longitude]//["lat":29.88930, "lng": 31.28958]
        let api = BackendApi()
        api.getlocations(serviceName: ServiceName.map.rawValue, parameters: parameters as! [String : Any], completion: { [ self] (response) in
            self.locations = response["Products"] as! [[String:Any]]
            self.view.unlock()
            
            for loc in self.locations {
                print(loc)
                let Lat = loc["lat"] as! String
                let Lng = loc["lng"] as! String
                let Title = loc["en_title"] as! String
                let TitleAr = loc["ar_title"] as! String
                //                            let IsActive = loc["IsActive"] as! Bool
                //print(location)
                
                let coordinate = CLLocationCoordinate2D(latitude: Double(Lat) as! CLLocationDegrees, longitude: Double(Lng) as! CLLocationDegrees)
                print(coordinate.latitude)
                print(coordinate.longitude)
                
                
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
                
//                let marker = GMSMarker(position: coordinate)
                marker.title = TitleAr
                marker.map = self.mapView
                let img = UIImageView(image: UIImage(named: "29"))
                img.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
                marker.iconView = img
            }
            }
        )}
    

}
