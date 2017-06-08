//
//  Exemplo_VC.swift
//  Etna
//
//  Created by Erico GT on 05/06/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

//MARK: - • INTERFACE HEADERS

//MARK: - • FRAMEWORK HEADERS
import UIKit

//MARK: - • OTHERS IMPORTS

class Exemplo_VC: PMViewController{
    
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - • INTERFACE/PROTOCOL METHODS
    

    //MARK: - • PUBLIC METHODS
    
    
    //MARK: - • ACTION METHODS
    

    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
}
