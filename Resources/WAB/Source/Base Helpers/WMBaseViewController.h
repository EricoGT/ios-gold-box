//
//  WMBaseViewController.h
//  Walmart
//
//  Created by Bruno on 6/18/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+Product.h"

@class OFSearchViewController, WMModalLoadingView;

@interface WMBaseViewController : UIViewController

@property (strong, nonatomic) OFSearchViewController *search;

- (WMBaseViewController *)initWithTitle:(NSString *)title isModal:(BOOL)isModal searchButton:(BOOL)searchButton cartButton:(BOOL)cartButton wishlistButton:(BOOL)wishlistButton;

- (void)openSearchWithQuery:(NSString *)query completionBlock:(void (^)())completionBlock;

/**
 *  Opens cart view controller
 */
- (void)showCartWithCompletion:(void (^)())completion;

/**
 *  Classes who inherit from WMBaseViewController should implement and retunr his own identifier for UTMI
 */
- (NSString *)UTMIIdentifier;

/**
 *  Dismiss a modal view controller if thre's any
 */
- (void)dismiss;

/**
 *  Checks for push notifications actions
 */
- (void)checkCustomOpens;

/**
 *  Expire token when available
 */
- (void)tappedExpireTokenOAuth;

@end
