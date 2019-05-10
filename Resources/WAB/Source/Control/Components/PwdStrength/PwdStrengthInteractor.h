//
//  PwdStrengthInteractor.h
//  Walmart
//
//  Created by Renan Cargnin on 4/1/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PwdStrengthEnum.h"

@interface PwdStrengthInteractor : NSObject

+ (instancetype)singleton;
- (PwdStrength)strengthWithPwd:(NSString *)pwd;

@end
