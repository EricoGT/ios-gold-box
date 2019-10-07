//
//  File.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 01/07/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

struct SwiftDocumentation {
    
    /**
     Summary: The leading paragraph of a documentation comment becomes the documentation Summary. Any additional content is grouped together into the Discussion section.
     
     Discussion: You can apply *italic*, **bold**, or ` code ` inline styles.
     
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
     - Parameter p1:        Parâmetro 1.
     - Parameter p2:        Parâmetro 2.
     - Parameters:
     - p1:               Parâmetro 1 alternativo.
     - p2:               Parâmetro 2 alternativo.
     
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
