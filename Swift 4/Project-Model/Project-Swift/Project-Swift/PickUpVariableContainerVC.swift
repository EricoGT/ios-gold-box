//
//  PickUpVariableContainerVC.swift
//  Etna
//
//  Created by Erico GT on 09/02/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

//MARK: - • INTERFACE HEADERS

//MARK: - • FRAMEWORK HEADERS
import UIKit

//MARK: - • OTHERS IMPORTS

class PickUpVariableContainerVC: PMViewController{
    
    //MARK: - • LOCAL DEFINES
    
    
    //MARK: - • PUBLIC PROPERTIES
    @IBOutlet weak var viewA:UIView!
    @IBOutlet weak var viewB:UIView!
    @IBOutlet weak var viewC:VariableContainerView!
    
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
        
        self.view.layoutIfNeeded()
        
        viewC.registerLayoutConstraints()
    }
    
    //MARK: - • INTERFACE/PROTOCOL METHODS
    
    
    //MARK: - • PUBLIC METHODS
    
    
    //MARK: - • ACTION METHODS
    @IBAction func  actionHide(sender:Any){
    
        viewC.hideVerticallyFromParent(animated: true)
    
    }
    
    @IBAction func actionExpand(sender:Any){
        
        viewC.expandVertically(animated: true)
        
    }
    
    @IBAction func actionCompress(sender:Any){
        
        viewC.compressVertically(factor: 0.15, animated: false)
        
    }
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
}
