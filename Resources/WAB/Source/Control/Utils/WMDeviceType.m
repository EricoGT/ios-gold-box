//
//  WMDeviceType.m
//  Ofertas
//
//  Created by Marcelo Santos on 7/11/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "WMDeviceType.h"
#import "PSLog.h"

@interface WMDeviceType ()

@property (assign, nonatomic) BOOL boliPhone5;
@property (assign, nonatomic) BOOL bolOS7;

@end

@implementation WMDeviceType

- (float) heightScreen {
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    
    //Verify if is retina
    float heightScreen = result.height;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        // Retina display
        heightScreen = heightScreen/2;
    }
    return heightScreen;
}

- (BOOL) isPhone5 {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            CGFloat scale = [UIScreen mainScreen].scale;
            result = CGSizeMake(result.width * scale, result.height * scale);
            return result.height == 1136;
        }
        else {
            return NO;
        }
    }
    return NO;
}

+ (BOOL) isOS6 {
    return [[[UIDevice currentDevice] systemVersion] floatValue] < 7;
}

+ (BOOL) isPhone4 {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            CGFloat scale = [UIScreen mainScreen].scale;
            result = CGSizeMake(result.width * scale, result.height * scale);
            return !(result.height == 1136);
        }
        else{
            return YES;
        }
    }
    else {
        return NO;
    }
}

+ (float) heightDevice {
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    
    //Verify if is retina
    float heightScreen = result.height;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        // Retina display
        heightScreen = heightScreen/2;
    }
    return heightScreen;
}

+ (BOOL)isPhone5orBigger
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)])
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            CGFloat scale = [UIScreen mainScreen].scale;
            result = CGSizeMake(result.width * scale, result.height * scale);
            return result.height >= 1136;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}


@end
