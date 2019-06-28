//
//  File.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 28/06/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

import Foundation
import UIKit

//View Controller Protocol
protocol ViewControllerProtocol: class {
    func showActivityIndicator()
    func hideActivityIndicator()
}

//View Model Protocol
protocol ViewModelProtocol: class {
    func method1() -> Int
    func method2() -> Int
    func method3() -> Int
}

//View Model
class ViewModel : ViewModelProtocol {
    
    private weak var viewController: ViewControllerProtocol?
    
    init(_ viewControllerProtocol: ViewControllerProtocol) {
        self.viewController = viewControllerProtocol
    }
    
    //ViewModelProtocol:
    
    func method1() -> Int {
        return 1
    }
    
    func method2() -> Int {
        return 2
    }
    
    func method3() -> Int {
        return 3
    }
}
