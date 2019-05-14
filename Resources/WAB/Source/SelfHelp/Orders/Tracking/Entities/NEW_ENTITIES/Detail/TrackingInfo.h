//
//  TrackingInfo.h
//  Walmart
//
//  Created by Bruno Delgado on 10/17/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

@protocol TrackingInfo
@end

#import "JSONModel.h"
#import "TrackingTimelineItem.h"

@interface TrackingInfo : JSONModel

@property (nonatomic, strong) NSArray<TrackingTimelineItem> *groups;

@end
