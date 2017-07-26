//
//  MainMenuVC.swift
//  Project-Swift
//
//  Created by Erico GT on 26/07/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

//MARK: - • INTERFACE HEADERS

//MARK: - • FRAMEWORK HEADERS
import UIKit

//MARK: - • OTHERS IMPORTS

class MainMenuVC: PMViewController{
    
    //MARK: - • LOCAL DEFINES
    
    
    //MARK: - • PUBLIC PROPERTIES
    
    
    //MARK: - • PRIVATE PROPERTIES
    
    
    //MARK: - • INITIALISERS
    
    
    //MARK: - • CUSTOM ACCESSORS (SETS & GETS)
    
    
    //MARK: - • DEALLOC
    
    deinit {
        // NSNotificationCenter no longer needs to be cleaned up!
    }
    
    //MARK: - • SUPER CLASS OVERRIDES
    
    override func setupLayout(screenName:String){
        
        super.setupLayout(screenName: "Tela de Exemplo")
        
        //Caso seja preciso delegação para o alertView (a classe deve implmentar 'ASAlertViewDelegate' e 'ASAlertViewDataSource'):
        //self.alertView.setDelegate(self)
        //self.alertView.setDataSource(self)
        
        //Aditional code here...
    }
    
    //MARK: - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        App.Delegate.updateTabBarController()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = App.Delegate.createSideMenuItem()
        
        self.view.backgroundColor = App.Style.colorView_Light
        
        let arrayImages:Array<UIImage> = [UIImage(named:"flame_a_0001.png")!,
                                          UIImage(named:"flame_a_0002.png")!,
                                          UIImage(named:"flame_a_0003.png")!,
                                          UIImage(named:"flame_a_0004.png")!,
                                          UIImage(named:"flame_a_0005.png")!,
                                          UIImage(named:"flame_a_0006.png")!]
        
        let alert:SCLAlertViewPlus = SCLAlertViewPlus.createRichAlert(bodyMessage: "Este aplicativo é um projeto modelo para Swift 3.1. Várias classes, frameworks e pods já constam no projeto, prontas para uso.\n\nBasta fazer uma cópia e renomear para um novo projeto!", images: arrayImages, animationTimePerFrame: 0.1)
        alert.addButton(title: "OK", type: SCLAlertButtonType.Default){}
        alert.showSuccess("Bem vindo!", subTitle: "")
        
    }
    
    //MARK: - • INTERFACE/PROTOCOL METHODS
    
    
    //MARK: - • PUBLIC METHODS
    
    
    //MARK: - • ACTION METHODS
    
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
}
