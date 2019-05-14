//
//  OFSplashViewController.h
//  Ofertas
//
//  Created by Marcelo Santos on 7/11/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OFSkinInfo.h"

@interface OFSplashViewController : WMBaseViewController {
    //Activity Indicator
    IBOutlet UIActivityIndicatorView *actInd;
}

@property (weak) IBOutlet UIImageView *imgPromotion;
@property (nonatomic, strong) UINavigationController *container;

- (void) configureServices;

@end
