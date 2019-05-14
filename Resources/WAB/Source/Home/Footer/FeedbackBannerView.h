//
//  FeedbackBannerView.h
//  Walmart
//
//  Created by Renan on 8/25/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackBannerView : UIView

/**
 *  Instantiates feedback banner view object with a block to handle its button press
 *
 *  @param buttonPressedBlock The block to handle the button press
 *
 *  @return The feedback banner view object
 */
- (FeedbackBannerView *)initWithWithButtonPressedBlock:(void (^)())buttonPressedBlock;

@end
