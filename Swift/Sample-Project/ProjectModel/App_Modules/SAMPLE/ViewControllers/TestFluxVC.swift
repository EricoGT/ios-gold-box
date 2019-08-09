//
//  TestFluxVC.swift
//  Tembici
//
//  Created by lordesire on 11/06/2019.
//  Copyright © 2019 Tembici. All rights reserved.
//

//MARK: - • INTERFACE HEADERS

//MARK: - • FRAMEWORK HEADERS
import UIKit

//MARK: - • OTHERS IMPORTS

//MARK: - • EXTENSIONS

//MARK: - • CLASS

class TestFluxVC: ViewController {
    
    //MARK: - • LOCAL DEFINES
    
    
    //MARK: - • PUBLIC PROPERTIES
    
    @IBOutlet weak var lblTitle:UILabel!
    //
    var screenNumber:Int = 1
    
    //MARK: - • PRIVATE PROPERTIES
    
    
    //MARK: - • INITIALISERS
    
    
    //MARK: - • CUSTOM ACCESSORS (SETS & GETS)
    
    
    //MARK: - • DEALLOC
    
    deinit {
        // NSNotificationCenter no longer needs to be cleaned up!
    }
    
    //MARK: - • SUPER CLASS OVERRIDES
    
    
    //MARK: - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupLayout()
        
        
    }
    
    //MARK: - • INTERFACE/PROTOCOL METHODS
    
    
    //MARK: - • PUBLIC METHODS
    
    
    //MARK: - • ACTION METHODS
    
    @IBAction func actionReturn(sender : Any?) {
        
        self.pop(returning: .by(1))
    }
    
    @IBAction func actionSetRoot(sender : Any?) {
        
        App.Delegate.rootViewController = self
    }
    
    @IBAction func actionSetStep(sender : Any?) {
        
        App.Delegate.stepArrayViewController.addObject(self)
    }
    
    @IBAction func actionPopRoot(sender : Any?) {
        
        self.pop(returning: .root)
    }
    
    @IBAction func actionPopStep(sender : Any?) {
        
        self.pop(returning: .step)
    }
    
    @IBAction func actionPopOriginalRoot(sender : Any?) {
        
        self.pop(returning: .by(0))
    }
    
    @IBAction func actionPopByTree(sender : Any?) {
        
        self.pop(returning: .by(3))
    }
    
    @IBAction func actionPush(sender : Any?) {
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "TestFluxVC") as? TestFluxVC {
            controller.awakeFromNib()
            controller.screenNumber = self.screenNumber + 1
            //
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
    
    @IBAction func actionModal(sender : Any?) {
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "TestFluxVC") as? TestFluxVC {
            controller.awakeFromNib()
            controller.screenNumber = self.screenNumber + 1
            //
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
    
    override func setupLayout() {
        super.defaultSetup("Title")
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.navigationItem.title = "Screen \(self.screenNumber)"
        self.lblTitle.text = "Screen \(self.screenNumber)"
    }
}
