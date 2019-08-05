//
//  Palette.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 01/07/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

import UIKit

public class Palette {
    
    
    //MARK: - Colors
    
    let colorName = UIColor.color(hexSTR: "#000000")
    
    //MARK: - Controls Configuration
    
    func configureNavigationController(viewController: inout ModelViewController) -> Void {
        viewController.navigationItem.title = "Título"
        //
        viewController.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        viewController.navigationController?.navigationBar.shadowImage = nil
        viewController.navigationController?.navigationBar.isTranslucent = false
        //
        viewController.navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15.0)]
        //
        viewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
