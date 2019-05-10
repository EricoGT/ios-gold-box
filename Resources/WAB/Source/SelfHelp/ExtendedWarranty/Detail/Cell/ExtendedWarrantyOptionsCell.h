//
//  ExtendedWarrantyOptionsCell.h
//  Walmart
//
//  Created by Bruno on 6/1/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    OptionTypeTicket,
    OptionTypeAuthorizationTerm,
    OptionTypeCancel,
    OptionTypeCancelled,
} OptionType;

@interface ExtendedWarrantyOptionsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *optionImageView;
@property (weak, nonatomic) IBOutlet UILabel *optionNameLabel;
@property (assign, nonatomic) OptionType type;

- (void)setupWithOptionType:(OptionType)type;

@end
