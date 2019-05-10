//
//  ShowcaseTrackerModel.m
//  Walmart
//
//  Created by Bruno Delgado on 8/28/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ShowcaseTrackerModel.h"
#import "NSDate+DateTools.h"

@interface ShowcaseTrackerModel ()

@property (nonatomic, strong) NSDate *creationDate;

@end

@implementation ShowcaseTrackerModel

- (instancetype)initWithShowcaseId:(NSString *)showcaseid {
    self = [super init];
    if (self) {
        _showcaseId = showcaseid;
        _creationDate = NSDate.date;
    }
    
    return self;
}

- (void)setShowcaseId:(NSString *)showcaseId {
    _showcaseId = showcaseId;
    self.creationDate = NSDate.date;
}

- (BOOL)isInValidTimeRange {
    
    NSInteger days = (NSInteger)[NSDate.date daysFrom:_creationDate];
    if (days <= 30) {
        LogInfo(@"Last showcase is stored for %ld days (%ld minutes)", (long)days, (long) [NSDate.date minutesFrom:_creationDate]);
        return YES;
    } else {
        return NO;
    }
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_showcaseId forKey:@"showcaseId"];
    [encoder encodeObject:_showcaseName forKey:@"showcaseName"];
    [encoder encodeObject:_creationDate forKey:@"creationDate"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.showcaseId = [decoder decodeObjectForKey:@"showcaseId"];
        self.showcaseName = [decoder decodeObjectForKey:@"showcaseName"];
        self.creationDate = [decoder decodeObjectForKey:@"creationDate"];
    }
    return self;
}

@end
