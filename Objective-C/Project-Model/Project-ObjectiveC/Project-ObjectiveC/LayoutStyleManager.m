//
//  LayoutStyleManager.m
//  Project-ObjectiveC
//
//  Created by Erico GT on 17/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "LayoutStyleManager.h"

@implementation LayoutStyleManager

- (id)init
{
    self = [super init];
    if (self)
    {
        [self applyDefaultStyle];
    }
    
    return self;
}

@synthesize style;
@synthesize colorBackgroundScreen_Light, colorBackgroundScreen_Normal, colorBackgroundScreen_Dark, colorBackgroundScreen_Other;
@synthesize colorTextLabel_Light, colorTextLabel_Normal, colorTextLabel_Dark, colorTextLabel_Other;
@synthesize colorBackgroundButton_Light, colorBackgroundButton_Normal, colorBackgroundButton_Dark, colorBackgroundButton_Other;

- (void)applyDefaultStyle
{
    style = Default;
    //
    colorBackgroundScreen_Light = [UIColor lightGrayColor];
    colorBackgroundScreen_Normal = [UIColor grayColor];
    colorBackgroundScreen_Dark = [UIColor darkGrayColor];
    colorBackgroundScreen_Other = [UIColor blackColor];
    //
    colorTextLabel_Light = [UIColor whiteColor];
    colorTextLabel_Normal = [UIColor grayColor];
    colorTextLabel_Dark = [UIColor blackColor];
    colorTextLabel_Other = [UIColor redColor];
    //
    colorBackgroundButton_Light = [UIColor clearColor];
    colorBackgroundButton_Normal = [UIColor whiteColor];
    colorBackgroundButton_Dark = [UIColor blackColor];
    colorBackgroundButton_Other = [UIColor redColor];
}

- (void)setStyle:(AppStyle)newStyle
{
    style = newStyle;
    
    switch (style) {
        case Default:{
            [self applyDefaultStyle];
        }break;
            //
        case Light:{
            [self applyDefaultStyle];
        }break;
            //
        case Dark:
        {
            [self applyDefaultStyle];
        }break;
            //
        case Special:{
            [self applyDefaultStyle];
        }break;
            //
        default:{
            [self applyDefaultStyle];
        }   break;
    }
    
}


@end
