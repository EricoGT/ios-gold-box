//
//  OFLoginViewController.h
//  Ofertas
//
//  Created by Marcelo Santos on 8/23/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "WMBaseViewController.h"

@interface OFLoginViewController : WMBaseViewController <UITextFieldDelegate>

@property (copy, nonatomic) void (^dismissBlock)();

@property BOOL isFacebook;
@property BOOL isFacebookWithLink;
@property (nonatomic, strong) NSString *strSnId;
@property (nonatomic, strong) NSString *strScreen;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (OFLoginViewController *)initWithLoginSuccessBlock:(void (^)())loginSuccessBlock;

@end
