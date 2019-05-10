//
//  ModelCheckoutDelivery.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 8/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "CartItem.h"

@interface ModelCheckoutDelivery : JSONModel

@property (strong, nonatomic) NSArray<CartItem> *items;
@property (strong, nonatomic) NSArray *selectedDeliveries;
@property (strong, nonatomic) NSString *giftCard;
@property (assign, nonatomic) BOOL splitServicePayment;

- (instancetype)initWithItemsToDelete:(NSArray<CartItem> *)items;

@end
