//
//  UITableView+Reuse.h
//  Walmart
//
//  Created by Renan Cargnin on 23/02/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Reuse)

- (void)registerClassForCellWithClass:(nullable Class)cellClass;
- (void)registerNibForCellWithClass:(nullable Class)cellClass;

- (__kindof UITableViewCell * _Nonnull)dequeueReusableCellWithClass:(nullable Class)cellClass forIndexPath:(nonnull NSIndexPath *)indexPath;
- (__kindof  UITableViewCell * _Nonnull)dequeueReusableCellWithClass:(nullable Class)cellClass;

@end
