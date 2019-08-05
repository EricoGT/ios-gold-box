//
//  AppStartViewController.swift
//  Tembici
//
//  Created by lordesire on 10/06/2019.
//  Copyright © 2019 Tembici. All rights reserved.
//

//MARK: - • INTERFACE HEADERS

//MARK: - • FRAMEWORK HEADERS
import UIKit

//MARK: - • OTHERS IMPORTS

//MARK: - • EXTENSIONS

//MARK: - • CLASS

class AppStartViewController: UIViewController {
    
    //MARK: - • LOCAL DEFINES
    
    
    //MARK: - • PUBLIC PROPERTIES
    
    @IBOutlet weak var imvBackground : UIImageView!
    @IBOutlet weak var btnContinue : UIButton!
    
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
        
        //NOTE: Esta tela tem como finalidade realizar configurações essenciais ao aplicativo.
        //Ela pode ser utilizada para verificação de versão (app/servidor) e avaliação de conteúdo, além de exibição de tutoriais de inicialização.
        //O usuário somente visualizará esta tela quando uma mensagem/conteúdo lhe for exibida. Caso contrário ele deve ser direcionado automaticamente para o "root" da aplicação.
        self .configureApp()
    }
    
    //MARK: - • INTERFACE/PROTOCOL METHODS
    
    
    //MARK: - • PUBLIC METHODS
    
    
    //MARK: - • ACTION METHODS
    
    @IBAction func actionContinue(sender : Any?) {
        
        //Normal flux:
        //self.performSegue(withIdentifier: "SegueToMainMenuNormal", sender: nil)
        
        //Test flux:
        self.performSegue(withIdentifier: "SegueToTestFlux", sender: nil)
    }
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
    
    private func setupLayout() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.layoutIfNeeded()
        
        self.view.backgroundColor = UIColor.white
        
        imvBackground.backgroundColor = UIColor.clear
        imvBackground.image = nil
        
        btnContinue.setTitle("CONTINUE", for: .normal)
    }
    
    private func configureApp() {
        
        //NOTE: Em caso de interação com o usuário, prossiga para a próxima tela usando "SegueToMainMenuNormal". Caso não haja interação nesta tela, utilize "SegueToMainMenuFast".
        self.performSegue(withIdentifier: "SegueToMainMenuFast", sender: nil)
        
    }
}
