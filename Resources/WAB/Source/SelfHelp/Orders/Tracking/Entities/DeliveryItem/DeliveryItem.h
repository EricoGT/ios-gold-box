//
//  DeliveryItem.h
//  Tracking
//
//  Created by Bruno Delgado on 4/22/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "DeliveryPicture.h"
#import "DeliveryItemService.h"

@protocol DeliveryItem
@end

@interface DeliveryItem : JSONModel

@property (nonatomic, strong) DeliveryPicture *picture;
@property (nonatomic, strong) NSArray<DeliveryItemService, Optional> *services;

@end
