//
//  OFShipAddressViewController.h
//  Ofertas
//
//  Created by Marcelo Santos on 9/21/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMConnectionToken.h"
#import "OFAddressViewController.h"
#import "ShipmentOptions.h"
#import "WMConnectionAddress.h"
#import "MsgCommonViewController.h"

//Temp implementation
#import "PaymentCardViewController.h"

@protocol addressShipAddDelegate <NSObject>
@required
@optional
- (void) closeShipAddress;
- (void) refreshCartFromShipAddress;
- (void) closeShipAddressFromSuccess;
- (void) closeShipAddressToCart;

- (void) redirectToLoginFromAddress;

- (void) loadLoginScreenFromCart;

@end

@interface OFShipAddressViewController : WMBaseViewController <authToken, addressAddDelegate, shipOptionsDelegate, addressRequestDelegate, payDelegate>

@property (weak) id <addressShipAddDelegate> delegate;
@property (nonatomic, strong) NSString *strAllAddress;
@property (nonatomic, strong) NSDictionary *dictSkin;
@property (nonatomic, strong) OFAddressViewController *oa;
@property (nonatomic, strong) ShipmentOptions *shopt;

//Temp implementation
@property (nonatomic, strong) PaymentCardViewController *pc;

- (IBAction) newAddress;

@end
