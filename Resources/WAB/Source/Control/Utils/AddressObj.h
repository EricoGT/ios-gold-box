//
//  AddressObj.h
//  Walmart
//
//  Created by Marcelo Santos on 6/9/14..
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressObj : NSObject

@property (assign) NSString *idDelivery;
@property (assign) NSString *receiverName;
@property (assign) NSString *country;
@property (assign) NSString *state;
@property (assign) NSString *city;
@property (assign) NSString *neighborhood;
@property (assign) NSString *street;
@property (assign) NSString *number;
@property (assign) NSString *complement;
@property (assign) NSString *postalCode;
@property (assign) NSString *referencePoint;
@property (assign) NSString *type;
//@property (assign) NSString *description;

//- (id)initWithModelToJSONDictionary:(NSDictionary *) dict;
- (id) init;

@end
