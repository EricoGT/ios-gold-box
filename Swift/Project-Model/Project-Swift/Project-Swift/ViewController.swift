//
//  ViewController.swift
//  Project-Swift
//
//  Created by Erico GT on 3/31/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController, InternetHelperDelegate {

    @IBOutlet weak var lblResult:UILabel!
    //
    var soundManager:SoundManager?
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
        
        self.view.backgroundColor = App.Style.colorTextLabel_Other
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager = LocationServiceControl.initAndStartMonitoringLocation()
    }
    
    @IBAction func actionPlaySound(sender:UIButton) {
        
        let iH:InternetHelper = InternetHelper.init()
        
        //URL destino
        var urlRequest:String = "http://md5.jsontest.com/?text=<text>"
        urlRequest = urlRequest.replacingOccurrences(of: "<text>", with: "erico.gimenes")
        
        //Parameters
        let parameters:Dictionary = [
            "x": App.RandInt(1, 100),
            "y": App.RandInt(1, 100)
        ]
        
        iH.post(toURL: urlRequest, httpBodyData: parameters, delegate: self)
        
//        iH.post(toURL: urlRequest, httpBodyData: parameters) { (response, statusCode, error) in
//            
//            print("StatusCode: %li", statusCode)
//            
//            if let erro:NSError = error{
//                DispatchQueue.main.async {
//                    self.lblResult.text = String.init(format:"Error: %@, %@", [erro.domain, erro.userInfo["message"]])
//                }
//            }
//            
//            if let data:Dictionary = response{
//                DispatchQueue.main.async {
//                    self.lblResult.text = String.init(format:"Result: %@", [data])
//                }
//            }
//        }
    }
    
    func didFinishTaskWithError(error: NSError) {
        DispatchQueue.main.async {
            self.lblResult.text = String.init(format:"Error: %@, %@\n\nLatitude: %f\nLongitude: %f", [error.domain, error.userInfo["message"], (self.locationManager?.latitude)!, (self.locationManager?.longitude)!])
        }
    }
    
    func didFinishTaskWithSuccess(resultData: Dictionary<String, Any>) {
        DispatchQueue.main.async {
            self.lblResult.text = String.init(format:"Result: %@\n\nLatitude: %f\nLongitude: %f", [resultData, (self.locationManager?.latitude)!, (self.locationManager?.longitude)!])
        }
    }
    
}

