//
//  OFSimpleRegister.h
//  Ofertas
//
//  Created by Marcelo Santos on 12/11/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "WMBaseViewController.h"

@protocol WALRegisterViewControllerDelegate <NSObject>
@optional
- (void)walRegisterViewControllerRegisteredUserWithEmail:(NSString *)email pass:(NSString *)pass;
@end

@interface WALRegisterViewController : WMBaseViewController

@property (nonatomic, assign) id <WALRegisterViewControllerDelegate> delegate;
@property BOOL isFacebook;
@property (nonatomic, strong) NSString *strSnId;
@property BOOL isFacebookWithLink;

- (WALRegisterViewController *)initWithDelegate:(id <WALRegisterViewControllerDelegate>)delegate;

@end
