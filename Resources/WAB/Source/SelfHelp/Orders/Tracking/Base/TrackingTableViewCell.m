//
//  TrackingTableViewCell.m
//  Tracking
//
//  Created by Bruno Delgado on 4/17/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "TrackingTableViewCell.h"

@implementation TrackingTableViewCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
}

@end
