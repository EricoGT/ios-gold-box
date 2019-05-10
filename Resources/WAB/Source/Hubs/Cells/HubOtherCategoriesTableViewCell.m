//
//  HubOtherCategoriesTableViewCell.m
//  Walmart
//
//  Created by Renan Cargnin on 7/3/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "HubOtherCategoriesTableViewCell.h"

#import "CategoryMenuItem.h"

@implementation HubOtherCategoriesTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
}

- (void)setupWithCategory:(CategoryMenuItem *)category {
    self.categoryLabel.text = category.name;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.categoryLabel.textColor = highlighted ? RGBA(244, 123, 32, 1) : RGBA(26, 117, 207, 1);
}

@end
