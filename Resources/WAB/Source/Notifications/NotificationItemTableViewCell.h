//
//  NotificationItemTableViewCell.h
//  Walmart
//
//  Created by Bruno Delgado on 3/26/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *switchControl;

+ (UINib *)nib;

@end
