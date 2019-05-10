//
//  WMDeviceType.h
//  Ofertas
//
//  Created by Marcelo Santos on 7/11/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMDeviceType : NSObject

- (BOOL) isPhone5;
+ (BOOL)isPhone5orBigger;
- (float) heightScreen;
+ (BOOL) isOS6;
+ (BOOL) isPhone4;
+ (float) heightDevice;

@end
