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
protocol SampleManagerViewControllerProtocol: class {
    func showLoading()
    func hideLoading()
}

//View Model Protocol
protocol SampleManagerProtocol: class {
    func method1() -> Int
    func method2() -> Int
    func method3() -> Int
}

//View Model
class SampleManager : SampleManagerProtocol {
    
    private weak var viewController: SampleManagerViewControllerProtocol?
    
    required init(_ viewControllerProtocol: SampleManagerViewControllerProtocol) {
        self.viewController = viewControllerProtocol
    }
    
    //SampleManagerProtocol:
    
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
