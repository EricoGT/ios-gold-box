//
//  ShipmentOptions.h
//  Ofertas
//
//  Created by Marcelo Santos on 10/8/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ListProductsConstructor.h"
//#import "ListShipOptionsConstructor.h"
#import "CardShipmentOptions.h"
#import "ShipmentBoxViewController.h"
#import "DeliveryItemView.h"
#import "SeparatePaymentAlertViewController.h"
#import "ExtendedWarrantyLicenseViewController.h"
#import "WBRShipmentOptionsDeletePopupView.h"

@protocol shipOptionsDelegate <NSObject>
@required
@optional
- (void) closeShipOptions;
- (void) closeShipOptionsAndGoBackToCart;
- (void) gotoCart;
- (void) closeShipOptionsFromSuccess;
@end

@interface ShipmentOptions : WMBaseViewController <cardOptionsDelegate, shipDelegate, separatePaymentDelegate, ShipmentOptionDeleteDelegate>

- (ShipmentOptions *)initWithDictAddress:(NSDictionary *)addressDict fullAddress:(NSDictionary *)fullAdress delegate:(id <shipOptionsDelegate>)delegate;
- (void)shipOptionsForDeliveryItemView:(DeliveryItemView *)deliveryItemView;

@property (weak) id <shipOptionsDelegate> delegate;
@property (nonatomic, strong) ShipmentBoxViewController *shipbox;

@end
