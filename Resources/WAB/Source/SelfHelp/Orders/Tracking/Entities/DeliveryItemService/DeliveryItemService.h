//
//  DeliveryItemService.h
//  Tracking
//
//  Created by Bruno Delgado on 27/04/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#define serviceTypeWarranty @"WARRANTY"

@protocol DeliveryItemService
@end

@interface DeliveryItemService : JSONModel

@property (nonatomic, strong) NSString *serviceType;
@property (nonatomic, strong) NSNumber<Optional> *price;
@property (nonatomic, strong) NSString<Optional> *localizedDescription;
@property (nonatomic, strong) NSNumber<Optional> *months;

@end
