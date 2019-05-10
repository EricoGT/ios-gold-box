//
//  DepartmentMenuItemCell.h
//  Walmart
//
//  Created by Bruno Delgado on 11/25/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DepartmentMenuItem;

@interface DepartmentMenuItemCell : UITableViewCell

+ (UINib *)nib;
- (void)setupWithMenuName:(NSString *)name image:(UIImage *)image;
- (void)setupWithMenuName:(NSString *)name imageURL:(NSURL *)imageURL;
- (void)setupWithDepartmentMenuItem:(DepartmentMenuItem *)item;

@end
