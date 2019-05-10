//
//  WBRThankYouPageProductTableViewCell.m
//  Walmart
//
//  Created by Rafael Valim on 22/09/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRThankYouPageProductTableViewCell.h"

@implementation WBRThankYouPageProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier {
    return @"cellThankYouPageProductTableViewCell";
}

@end
