//
//  Random+Extensions.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 28/06/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK: Int Extension

public extension Int {
    
    /// Returns a random Int point number between 0 and Int.max.
    static var random: Int {
        return Int.random(n: Int.max)
    }
    
    /// Random integer between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random Int point number between 0 and n max
    static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    
    ///  Random integer between min and max
    ///
    /// - Parameters:
    ///   - min:    Interval minimun
    ///   - max:    Interval max
    /// - Returns:  Returns a random Int point number between 0 and n max
    static func random(min: Int, max: Int) -> Int {
        return Int.random(n: max - min + 1) + min
        
    }
}

// MARK: Double Extension

public extension Double {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    static var random: Double {
        return Double(arc4random() / UInt32.max) //0xFFFFFFFF
    }
    
    /// Random double between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random double point number between 0 and n max
    static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}

// MARK: Float Extension

public extension Float {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    static var random: Float {
        return Float(arc4random() / UInt32.max)  //0xFFFFFFFF
    }
    
    /// Random float between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random float point number between 0 and n max
    static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}

// MARK: CGFloat Extension

public extension CGFloat {
        
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    static var random: CGFloat {
        return CGFloat(Float.random)
    }
    
    /// Random CGFloat between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random CGFloat point number between 0 and n max
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random * (max - min) + min
    }
}

// MARK: Bool Extension

public extension Bool {
    
    /// Randomly returns true or false.
    static var random: Bool {
        return (arc4random_uniform(2) == 0) ? false : true
    }
    
}

struct SwiftDocumentation {
    
    /**
     Summary: The leading paragraph of a documentation comment becomes the documentation Summary. Any additional content is grouped together into the Discussion section.
     
     Discussion: You can apply *italic*, **bold**, or `code` inline styles.
     
     ## Unordered Lists
     - Lists are great,
     - but perhaps don't nest
     - Sub-list formatting
     
     ## Ordered Lists
     1. Ordered lists, too
     2. for things that are sorted;
     3. Arabic numerals
     4. are the only kind supported.
     
     ## Metadata -----------------------------------
     - Author:              bla bla...
     - Authors:             bla bla...
     - Copyright:           bla bla...
     - Date:                bla bla...
     - SeeAlso:             bla bla...
     - Since:               bla bla...
     - Version:             bla bla...
     
    ## Algorithm/Safety Information -----------------------------------
     - Precondition:        bla bla...
     - Postcondition:       blabla...
     - Requires:            bla bla...
     - Invariant:           bla bla...
     - Complexity:          bla bla...
     - Important:           bla bla...
     - Warning:             bla bla...
     
     ## General Notes & Exhortations -----------------------------------
     - Attention:           bla bla..
     - Bug:                 bla bla...
     - Experiment:          bla bla...
     - Note:                bla bla...
     - Remark:              bla bla...
     - ToDo:                bla bla...
     
     ## Basic Info -----------------------------------
     - Parameter p1:        bla...
     - Parameter p2:        bla...
     - Parameters:
        - p1:               bla...
        - p2:               bla...
     
     - Returns:             p1 + p2
     - Throws:              bla bla...
     
     ## Code Sample:
     ```
     let n1 = 1
     let n2 = 2
     let sum = method(n1, n2)
     ```
    */
    func method(_ p1:Int, _ p2:Int) -> Int {
        return p1 + p2
    }
    
    
}
