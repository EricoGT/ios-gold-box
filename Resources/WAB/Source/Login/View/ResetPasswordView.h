//
//  ResetPasswordView.h
//  Walmart
//
//  Created by Renan Cargnin on 3/3/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMPinnedView.h"

@interface ResetPasswordView : WMPinnedView

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (void)setRecoverPasswordSuccessBlock:(void (^)(NSString *maskedEmail))successBlock;

@end
