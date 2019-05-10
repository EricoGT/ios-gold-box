//
//  TrackingTimelineItem.h
//  Walmart
//
//  Created by Bruno Delgado on 10/17/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

@protocol TrackingTimelineItem
@end

#import "JSONModel.h"
#import "TrackingTimelineSubItem.h"

@interface TrackingTimelineItem : JSONModel

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, strong) NSString *alert;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSArray<TrackingTimelineSubItem> *tracking;

@end
