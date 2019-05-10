//
//  SHPMenuTableViewCell.h
//  Walmart
//
//  Created by Bruno Delgado on 4/22/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackingTableViewCell.h"
#import "SHPMenuItem.h"

@interface SHPMenuTableViewCell : TrackingTableViewCell

@property (nonatomic, weak) IBOutlet UIView *topSeparator;
@property (nonatomic, weak) IBOutlet UIView *bottomSeparator;

- (void)setupWithMenuItem:(SHPMenuItem *)item;

@end
