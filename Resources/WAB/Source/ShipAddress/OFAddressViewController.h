//
//  OFAddressViewController.h
//  Ofertas
//
//  Created by Marcelo Santos on 9/23/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMConnectionAddress.h"
#import "MsgCommonViewController.h"
#import "WMButton.h"

@class OFAddressViewController;

@protocol addressAddDelegate <NSObject>
@required
@optional
- (void) closeAddAddress;
- (void) closeAddAddressAndRefresh;
- (void) redirectLoginTokenExpired;
- (void)addressViewController:(OFAddressViewController *)addressViewcontroller updatedAddress:(NSDictionary *)addressDict;
- (void)addressViewController:(OFAddressViewController *)addressViewController addedNewAddress:(NSDictionary *)addressDict;
@end

@interface OFAddressViewController : WMBaseViewController <addressRequestDelegate,UITextFieldDelegate>

@property (weak) id <addressAddDelegate> delegate;

- (OFAddressViewController *)initWithOperation:(NSString *)operation dictAddress:(NSDictionary *)dictAddress delegate:(id <addressAddDelegate>)delegate;

- (IBAction) showHideCombo;
- (IBAction) pressedSearch;
- (IBAction) typeResidential;
- (IBAction) typeCommercial;
- (IBAction) refreshButtonPressed;

@end
