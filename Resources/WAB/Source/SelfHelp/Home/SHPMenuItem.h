//
//  SHPMenuItem.h
//  Walmart
//
//  Created by Bruno Delgado on 4/22/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHPMenuItem : NSObject

@property (nonatomic, strong) NSString *menuName;
@property (nonatomic, strong) UIImage *menuIcon;
@property (nonatomic, strong) UIImage *menuIconSelected;

- (instancetype)initWithName:(NSString *)name icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon;

@end
