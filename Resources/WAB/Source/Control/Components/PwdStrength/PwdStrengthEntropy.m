//
//  PwdStrengthEntropy.m
//  Walmart
//
//  Created by Renan Cargnin on 4/1/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "PwdStrengthEntropy.h"

@implementation PwdStrengthEntropy

- (PwdStrengthEntropy *)initWithWeight:(NSInteger)weight pattern:(NSString *)pattern {
    self = [super init];
    if (self) {
        _weight = weight;
        _pattern = pattern;
    }
    return self;
}

+ (PwdStrengthEntropy *)entropyWithWeight:(NSInteger)weight pattern:(NSString *)pattern {
    return [[PwdStrengthEntropy alloc] initWithWeight:weight pattern:pattern];
}

- (BOOL)isTheSame:(char)c {
    return [_pattern rangeOfString:[NSString stringWithFormat:@"%c", c]].location != NSNotFound;
}

@end
