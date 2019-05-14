//
//  OFRatingViewController.h
//  Walmart
//
//  Created by on 12/2/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OFRatingViewControllerDelegate <NSObject>
@required
- (void)ratingYesPressed;
- (void)ratingAfterPressed;
@end

@interface OFRatingViewController : WMBaseViewController

@property (nonatomic, assign) id<OFRatingViewControllerDelegate> delegate;

@end
