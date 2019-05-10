//
//  OFCartTemp.h
//  Ofertas
//
//  Created by Marcelo Santos on 15/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardProductsResume.h"

@interface OFCartTemp : NSObject

- (void) assignProductDictionary:(NSDictionary *) dict;
- (NSDictionary *) getProductDictionary;
- (void) lastUpdatedTotal:(float) valueUpdated;
- (void) lastUpdatedTotalWithShipments:(float)valueWithShipment;

- (NSString *) getJsonProducts;
- (NSString *) getJsonProductsToShipping;
- (NSString *) getJsonProductsSimple;
- (float) getLastUpdatedTotal;
+ (NSArray *) getAllProductsFromCartApp;
- (float) getLastUpdatedTotalWithShipment;
+ (NSString *)convertToXMLEntities:(NSString *)myString;

- (void) assignCardProducts:(CardProductsResume *) viewProducts;
- (CardProductsResume *) getViewCardProducts;

@end
