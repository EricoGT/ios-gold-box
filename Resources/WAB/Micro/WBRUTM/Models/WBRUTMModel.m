//
//  WBRUTMModel.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 10/24/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRUTMModel.h"

#import "TimeManager.h"

@interface WBRUTMModel() <NSCoding>

@end

@implementation WBRUTMModel

- (instancetype)initWithUTMValue:(NSString *)UTMValue {
    
    self = [super init];
    
    if (self) {
        self.UTMValue = UTMValue;
    }
    
    return self;
}

#pragma mark - Custom Getter

- (BOOL)valid {
    
    return [TimeManager UTMDateStillValid:self.savedDate];
}

#pragma mark - NSCoding Protocol

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    
    if (self) {
        self.UTMValue = [aDecoder decodeObjectForKey:@"UTMValue"];
        self.savedDate = [aDecoder decodeObjectForKey:@"savedData"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.UTMValue forKey:@"UTMValue"];
    [aCoder encodeObject:self.savedDate forKey:@"savedData"];
}

@end
