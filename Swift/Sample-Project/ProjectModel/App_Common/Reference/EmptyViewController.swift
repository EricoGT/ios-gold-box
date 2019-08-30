//
//  EmptyViewController.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 05/07/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

//MARK: - • PROTOCOLS

//MARK: - • INTERFACE HEADERS

//MARK: - • FRAMEWORK HEADERS
import UIKit

//MARK: - • OTHERS IMPORTS

//MARK: - • EXTENSIONS

//MARK: - • LOCAL DEFINES / ENUMS

//MARK: - • CLASS

class EmptyViewController: ViewController {
    
    //MARK: - • PUBLIC PROPERTIES
    
    
    //MARK: - • PRIVATE PROPERTIES
    
    
    //MARK: - • INITIALISERS
    
    
    //MARK: - • CUSTOM ACCESSORS (SETS & GETS)
    
    
    //MARK: - • DEALLOC
    
    deinit {
        // NSNotificationCenter no longer needs to be cleaned up!
    }
    
    //MARK: - • SUPER CLASS OVERRIDES
    
    //ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //Super Methods
    
    override func setupLayout() {
        super.defaultSetup("Title")
        //
        //Custom setup here...
    }
    
    override func loadContent() {
        //Insert code here...
        //
        contentLoaded = true
    }
    
    override func systemKeyboardShow(height: CGFloat, animationDuration: TimeInterval, animationCurve: UIView.AnimationOptions) {
        print("\(#function)")
    }
    
    override func systemKeyboardHide() {
        print("\(#function)")
    }
    
    //MARK: - • CONTROLLER LIFECYCLE
    
    
    //MARK: - • INTERFACE/PROTOCOL METHODS

    
    //MARK: - • PUBLIC METHODS
    
    
    //MARK: - • ACTION METHODS
    
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
    
}
