//
//  ViewController.swift
//  Project-Swift
//
//  Created by Erico GT on 3/31/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var soundManager:SoundManager?
    //
    var locationManager:LocationServiceControl?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        self.soundManager = SoundManager.init()
        locationManager = nil
        //
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.soundManager = SoundManager.init()
        locationManager = nil
        //
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //NotificationCenter.default.addObserver( self, selector: #selector(self.locationUpdate), name: NSNotification.Name(rawValue: App.Constants.SYSNOT_LOCATION_SERVICE_UPDATE_WITH_GEOCODEINFO), object: nil)
        //NotificationCenter.default.addObserver( self, selector: #selector(self.locationUpdate2), name: NSNotification.Name(rawValue: App.Constants.SYSNOT_LOCATION_SERVICE_UPDATE_WITH_GEOCODEINFO), object: nil)
        
        //locationManager = LocationServiceControl.initAndStartMonitoringLocation()
        
    }
    
    @IBAction func actionPlaySound(sender:UIButton) {
        
        let sm:SoundMedia = SoundMedia(rawValue: App.RandInt(1, 19))!
        
        soundManager?.speak("Tocando som: \(sm)")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2 ) {
            self.soundManager?.play(sound: sm, volume: 1.0)
            //
            print("Latitude: \(self.locationManager?.latitude ?? 0)")
            print("Longitude: \(self.locationManager?.longitude ?? 0)")
        }
        
    }
    
    @IBAction func testSaveData(sender:UIButton){
        
        let dataFileManager:DataFileManager = DataFileManager.init()
        
        var dic:Dictionary<String, Any> = Dictionary.init()
        
        dic["user"] = "Erico Gimenes"
        dic["id"] = 25
        dic["email"] = "erico.gimenes@gmail.com"
        dic["password"] = "*********"
        
        let ok:Bool = dataFileManager.saveData(dictionaryData: dic)
        
        if (ok){
            
            if let userDic:Dictionary = dataFileManager.loadData(){
                
                print("User data: \(userDic)")
                
                if let _:Bool = dataFileManager.deleteData(){
                    print("COMPLETE-SUCCESS!")
                }else{
                    print("DELETE ERROR")
                }
                
            }else{
                print("LOAD ERROR")
            }
        }else{
            print("SAVE ERROR")
        }
    }
    
    
//    func locationUpdate(notification:Notification){
//        print("Notification: \(notification.userInfo)")
//    }
//    
//    func locationUpdate2(notification:Notification){
//        print("Notification: \(notification.userInfo)")
//    }
    
}

