//
//  TrackingTimelineSubItem.h
//  Walmart
//
//  Created by Bruno Delgado on 10/17/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol TrackingTimelineSubItem
@end

@interface TrackingTimelineSubItem : JSONModel

@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *alert;
@property (nonatomic, strong) NSDate *eventDate;
@property (nonatomic, assign) BOOL trackingDelivery;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *descriptionText;


@end
