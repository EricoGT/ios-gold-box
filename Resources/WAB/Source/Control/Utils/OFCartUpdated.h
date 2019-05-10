//
//  OFCartUpdated.h
//  Ofertas
//
//  Created by Marcelo Santos on 16/11/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFCartUpdated : NSObject

- (void) assignProductUpdated:(NSArray *) arrProds;
- (NSArray *) getAllProductsUpdated;

- (void) assignDictConfirmation:(NSDictionary *) dictConfirmation;
- (NSDictionary *) getConfirmationInfo;

@end
