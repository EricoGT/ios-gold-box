//
//  OFShipAddressViewController.h
//  Ofertas
//
//  Created by Marcelo Santos on 9/21/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OFAddressViewController.h"
#import "ShipmentOptions.h"

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

@interface OFShipAddressViewController : WMBaseViewController <addressAddDelegate, shipOptionsDelegate>

@property (weak) id <addressShipAddDelegate> delegate;
@property (nonatomic, strong) NSString *strAllAddress;
@property (nonatomic, strong) NSDictionary *dictSkin;
@property (nonatomic, strong) OFAddressViewController *oa;

@end
