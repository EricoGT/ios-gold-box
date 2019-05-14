//
//  TrackingAddress.h
//  Walmart
//
//  Created by Bruno Delgado on 10/8/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

@protocol TrackingAddress
@end

#import "JSONModel.h"
#import "TrackingState.h"
#import "TrackingOwner.h"

@interface TrackingAddress : JSONModel

@property (nonatomic, strong) NSString<Optional> *addressLine1;
@property (nonatomic, strong) NSString<Optional> *addressLine2;
@property (nonatomic, strong) TrackingState<Optional> *state;
@property (nonatomic, strong) NSString<Optional> *city;
@property (nonatomic, strong) NSString<Optional> *zipcode;
@property (nonatomic, assign) BOOL defaultAddress;
@property (nonatomic, strong) TrackingOwner<Optional> *owner;
@property (nonatomic, strong) NSString<Optional> *number;
@property (nonatomic, strong) NSString<Optional> *neighborhood;

@end
