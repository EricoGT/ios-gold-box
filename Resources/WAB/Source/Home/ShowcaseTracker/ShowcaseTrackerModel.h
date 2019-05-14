//
//  ShowcaseTrackerModel.h
//  Walmart
//
//  Created by Bruno Delgado on 8/28/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kShowcaseDateStoreFormat @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

@interface ShowcaseTrackerModel : NSObject

@property (nonatomic, strong) NSString *showcaseName;
@property (nonatomic, strong) NSString *showcaseId;

- (id)init  __attribute__((unavailable("Use -initWithShowcaseId:")));
- (instancetype)initWithShowcaseId:(NSString *)showcaseid;
- (BOOL)isInValidTimeRange;

@end
