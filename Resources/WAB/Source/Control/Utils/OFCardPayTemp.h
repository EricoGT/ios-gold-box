//
//  OFCardPayTemp.h
//  Walmart
//
//  Created by Marcelo Santos on 6/10/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFCardPayTemp : NSObject

- (void) assignCardValue:(NSDictionary *) dictValues;
- (NSDictionary *) getCardValue;

@end
