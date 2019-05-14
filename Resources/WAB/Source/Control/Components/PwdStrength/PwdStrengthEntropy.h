//
//  PwdStrengthEntropy.h
//  Walmart
//
//  Created by Renan Cargnin on 4/1/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PwdStrengthEntropy : NSObject

@property (assign, nonatomic) NSInteger weight;
@property (strong, nonatomic) NSString *pattern;

- (PwdStrengthEntropy *)initWithWeight:(NSInteger)weight pattern:(NSString *)pattern;
+ (PwdStrengthEntropy *)entropyWithWeight:(NSInteger)weight pattern:(NSString *)pattern;

- (BOOL)isTheSame:(char)c;

@end
