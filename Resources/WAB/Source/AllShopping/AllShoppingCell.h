//
//  AllShoppingCell.h
//  Walmart
//
//  Created by Bruno Delgado on 12/2/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DepartmentMenuItem;

@interface AllShoppingCell : UITableViewCell

@property (strong, nonatomic) NSString *strName;
@property (strong, nonatomic) NSString *strImage;

- (void)setupCellWithDepartmentMenuItem:(DepartmentMenuItem *)item;
+ (UINib *)nib;

@end
