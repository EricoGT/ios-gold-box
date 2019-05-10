//
//  SHPMenuItem.m
//  Walmart
//
//  Created by Bruno Delgado on 4/22/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "SHPMenuItem.h"

@implementation SHPMenuItem

- (instancetype)initWithName:(NSString *)name icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon
{
    self = [super init];
    if (self)
    {
        self.menuName = name;
        self.menuIcon = icon;
        self.menuIconSelected = selectedIcon;
    }
    return self;
}

@end
