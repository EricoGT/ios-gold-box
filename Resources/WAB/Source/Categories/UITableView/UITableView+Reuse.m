//
//  UITableView+Reuse.m
//  Walmart
//
//  Created by Renan Cargnin on 21/02/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "UITableView+Reuse.h"

@implementation UITableView (Reuse)

- (void)registerClassForCellWithClass:(Class)cellClass {
    [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)registerNibForCellWithClass:(Class)cellClass {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (UITableViewCell *)dequeueReusableCellWithClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
}

- (UITableViewCell *)dequeueReusableCellWithClass:(Class)cellClass {
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
}

@end
