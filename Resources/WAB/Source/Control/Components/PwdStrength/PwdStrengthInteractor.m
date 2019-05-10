//
//  PwdStrengthInteractor.m
//  Walmart
//
//  Created by Renan Cargnin on 4/1/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "PwdStrengthInteractor.h"

#import "PwdStrengthEntropy.h"

#define kMinRangePwdStrength 41
#define kMaxRangePwdStrength 56

static PwdStrengthEntropy *hasUpperCaseEntropy;
static PwdStrengthEntropy *hasLowerCaseEntropy;
static PwdStrengthEntropy *hasNumberEntropy;
static PwdStrengthEntropy *hasAltSpecialCharsEntropy;
static PwdStrengthEntropy *hasSpecialCharsEntropy;
static PwdStrengthEntropy *hasSpaceEntropy;
static PwdStrengthEntropy *hasGreaterThanTilEntropy;
static PwdStrengthEntropy *hasLessThanSpaceEntropy;

@interface PwdStrengthInteractor ()

@property (strong, nonatomic) NSString *pwd;

@end

@implementation PwdStrengthInteractor

+ (instancetype)singleton
{
    static PwdStrengthInteractor *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [PwdStrengthInteractor new];
        hasUpperCaseEntropy = [PwdStrengthEntropy entropyWithWeight:26 pattern:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
        hasLowerCaseEntropy = [PwdStrengthEntropy entropyWithWeight:26 pattern:@"abcdefghijklmnopqrstuvwxyz"];
        hasNumberEntropy = [PwdStrengthEntropy entropyWithWeight:10 pattern:@"0123456789"];
        hasAltSpecialCharsEntropy = [PwdStrengthEntropy entropyWithWeight:10 pattern:@"!@#$%^&*()"];
        hasSpecialCharsEntropy = [PwdStrengthEntropy entropyWithWeight:20 pattern:@"`~-_=+[{]}\\|;:'\",<.>/?"];
        hasSpaceEntropy = [PwdStrengthEntropy entropyWithWeight:1 pattern:@" "];
        hasGreaterThanTilEntropy = [PwdStrengthEntropy entropyWithWeight:32 + 128 pattern:@"~"];
        hasLessThanSpaceEntropy = [PwdStrengthEntropy entropyWithWeight:32 + 128 pattern:@" "];
    });
    return singleton;
}

- (PwdStrength)strengthWithPwd:(NSString *)pwd {
    self.pwd = pwd;
    if (_pwd.length == 0) {
        return PwdStrengthNone;
    }
    else {
        NSInteger strength = [self smash];
        if (strength <= kMinRangePwdStrength) {
            return PwdStrengthWeak;
        }
        else if (strength > kMinRangePwdStrength && strength < kMaxRangePwdStrength) {
            return PwdStrengthMedium;
        }
        else {
            return PwdStrengthStrong;
        }
    }
}

- (NSInteger)smash {
    double strength = _pwd.length * ([self log2:[self cardinality]]);
    return fabs(strength);
}

- (NSInteger)cardinality {
    NSArray *entropies = @[hasUpperCaseEntropy,
                           hasLowerCaseEntropy,
                           hasNumberEntropy,
                           hasAltSpecialCharsEntropy,
                           hasSpecialCharsEntropy,
                           hasSpaceEntropy,
                           hasGreaterThanTilEntropy,
                           hasLessThanSpaceEntropy];
    NSInteger cardinality = 0;
    NSInteger countGreaterLess = 0;
    for (PwdStrengthEntropy *entropy in entropies) {
        for (NSInteger i = 0; i < _pwd.length; i++) {
            char c = [_pwd characterAtIndex:i];
            if (c < [hasLessThanSpaceEntropy.pattern characterAtIndex:0] || c > [hasGreaterThanTilEntropy.pattern characterAtIndex:0]) {
                cardinality += entropy.weight;
                countGreaterLess++;
                break;
            }
            else {
                if ([entropy isTheSame:c] && ![self outsideASCIITable:entropy]) {
                    cardinality += entropy.weight;
                    break;
                }
            }
        }
    }
    return cardinality;
}

- (BOOL)outsideASCIITable:(PwdStrengthEntropy *)entropy {
    return entropy == hasLessThanSpaceEntropy || entropy == hasGreaterThanTilEntropy;
}

- (double)log2:(double)number {
    return log(number) / log(2.0);
}

@end
