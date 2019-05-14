//
//  HubOtherCategoriesTableViewCell.h
//  Walmart
//
//  Created by Renan Cargnin on 7/3/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryMenuItem;

@interface HubOtherCategoriesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

- (void)setupWithCategory:(CategoryMenuItem *)category;

@end
