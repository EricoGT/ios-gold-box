//
//  RefreshTokenStatus.h
//  Walmart
//
//  Created by Marcelo Santos on 1/18/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol refStatusDelegate <NSObject>
@optional
- (void) removeStatusRefreshToken;
@end

@interface RefreshTokenStatus : WMBaseViewController

@property (weak) id <refStatusDelegate> delegate;
@property (nonatomic, strong) NSString *strToken;
- (void)expireToken:(NSString *) token;

@end
