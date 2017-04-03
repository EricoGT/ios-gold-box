//
//  LocationManager.swift
//  Project-Swift
//
//  Created by Erico GT on 03/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import Foundation
import CoreLocation

class LocationServiceControl: NSObject, CLLocationManagerDelegate{
    
    //Properties
    var authorizationStatus:CLAuthorizationStatus?
    var locationError:Error?
    var statusMessage:String?
    //
    var updateCount:Int = 0
    var latitude:Double = 0
    var longitude:Double = 0
    //
    var name:String?
    var addressDictionary:Dictionary<AnyHashable, Any>?
    var ISOcountryCode:String?
    var country:String?
    var postalCode:String?
    var administrativeArea:String?
    var subAdministrativeArea:String?
    var locality:String?
    var subLocality:String?
    var thoroughfare:String?
    var subThoroughfare:String?
    var region:CLRegion?
    //
    private var locationManager:CLLocationManager?
    
    //Initializer:
    override init(){
        
        super.init()
        //
        resetData()
        //
        locationManager = CLLocationManager.init()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.distanceFilter = kCLDistanceFilterNone
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    
    //Methods:
    class func initAndStartMonitoringLocation() ->LocationServiceControl{
        
        let lsc:LocationServiceControl = LocationServiceControl.init()
        lsc.startMonitoringLocation()
        return lsc
    }
    
    func startMonitoringLocation(){
        print("Iniciando monitoramento GPS!")
        //
        locationManager?.startUpdatingLocation()
        authorizationStatus = CLLocationManager.authorizationStatus()
    }
    
    func stopMonitoring(){
        print("Parando monitoramento GPS!")
        //
        resetData()
        locationManager?.stopUpdatingLocation()
    }
    
    //Private func
    
    private func resetData(){
        
        updateCount = 0
        //
        authorizationStatus = CLAuthorizationStatus.notDetermined
        locationError = nil
        statusMessage = "OK!"
        //
        latitude = 0.0
        longitude = 0.0
        //
        name = nil
        addressDictionary = nil
        ISOcountryCode = nil
        country = nil
        postalCode = nil
        administrativeArea = nil
        subAdministrativeArea = nil
        locality = nil
        subLocality = nil
        thoroughfare = nil
        subThoroughfare = nil
        region = nil
        
    }
    
    //MARK: - Location Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        updateCount += 1
        
        latitude = (manager.location?.coordinate.latitude)!
        longitude = (manager.location?.coordinate.longitude)!
        
        let geocoder:CLGeocoder = CLGeocoder.init()
        
        geocoder.reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            
            guard error == nil else {
                print("reverseGeocodeLocation Error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            guard placemarks != nil else {
                print("reverseGeocodeLocation Error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            let placemark:CLPlacemark? = placemarks?.last
            
            guard placemark != nil else{
                print("reverseGeocodeLocation Error: empty location")
                //
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: App.Constants.SYSNOT_LOCATION_SERVICE_UPDATE_WITHOUT_GEOCODEINFO), object: nil)
                return
            }
            
            self.name = placemark?.name
            self.addressDictionary = placemark?.addressDictionary
            self.ISOcountryCode = placemark?.isoCountryCode
            self.country = placemark?.country
            self.postalCode = placemark?.postalCode
            self.administrativeArea = placemark?.administrativeArea
            self.subAdministrativeArea = placemark?.subAdministrativeArea
            self.locality = placemark?.locality
            self.subLocality = placemark?.subLocality
            self.thoroughfare = placemark?.thoroughfare
            self.subThoroughfare = placemark?.subThoroughfare
            self.region = placemark?.region
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: App.Constants.SYSNOT_LOCATION_SERVICE_UPDATE_WITH_GEOCODEINFO), object: nil, userInfo: self.addressDictionary)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error
        statusMessage = error.localizedDescription
    }
    
//    NotificationCenter.default.addObserver(
//    self,
//    selector: #selector(self.batteryLevelChanged),
//    name: .UIDeviceBatteryLevelDidChange,
//    object: nil)

}
