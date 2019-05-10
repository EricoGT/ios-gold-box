//
//  SubcategoryMenuCellTableViewCell.h
//  Walmart
//
//  Created by Bruno Delgado on 2/9/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CategoryMenuItem;

@interface SubcategoryMenuCellTableViewCell : UITableViewCell

- (void)setupCellWithCategory:(CategoryMenuItem *)item count:(NSNumber *)count hideIcon:(BOOL)hideIcon;
+ (UINib *)nib;

@end
