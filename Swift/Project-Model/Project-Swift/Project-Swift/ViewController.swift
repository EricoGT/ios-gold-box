//
//  ViewController.swift
//  Project-Swift
//
//  Created by Erico GT on 3/31/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
        
        let iv:UIImageView = UIImageView(frame: CGRect(x: 100.0, y: 100.0, width: 80.0, height: 80.0))
        iv.backgroundColor = UIColor.lightGray
        iv.image = App.Utils.graphicHelper_Crop(image: UIImage.init(named: "animal.jpg"), frame: CGRect(x: 50.0, y: 50.0, width: 50.0, height: 50.0))
        //
        self.view.addSubview(iv)
        
        
        print("\(String(describing: App.STR("THE_KEY")))")
        
        var pos:Int = 0;
        var neg:Int = 0;
        
        for _ in 0...100 {
            
            let n:Int = App.RandInt(0, 1000)
            
            if (n < 500){
                pos += 1
            }else{
                neg += 1
            }
        }
        
        print("POS: \(pos), NEG: \(neg)")
 
    }
    
    
}

