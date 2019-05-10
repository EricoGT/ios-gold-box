//
//  ErrataView.h
//  Walmart
//
//  Created by Renan on 8/25/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "ErrataModel.h"
#import "ModelErrata.h"

@interface ErrataView : UIView

/**
 *  Instantiates an erratum view object with the erratum information and a block to handle a tap gesture
 *
 *  @param errata      The erratum model containing the information to be displayed in the view
 *  @param tappedBlock The block to handle tap gestures in the view
 *
 *  @return The erratum view object
 */
- (ErrataView *)initWithErrataModel:(ModelErrata *)errata tappedBlock:(void (^)())tappedBlock;

@end
