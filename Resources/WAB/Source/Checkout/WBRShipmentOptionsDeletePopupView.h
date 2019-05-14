//
//  ShipmentOptionsDeletePopupView.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 8/24/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShippingCell.h"
#import "CartItem.h"

@protocol ShipmentOptionDeleteDelegate <NSObject>
@required
- (void)didDeleteShipmentOption:(NSArray<CartItem> *)cartItems;
- (void)didDismissShipmentOptionDeletePopup;
@end

@interface WBRShipmentOptionsDeletePopupView : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak) id <ShipmentOptionDeleteDelegate> delegate;

- (instancetype)initWithShippingIndexText:(NSString *)shippingIndexText AndCartItems:(NSArray<CartItem> *)cartItems;
@end
