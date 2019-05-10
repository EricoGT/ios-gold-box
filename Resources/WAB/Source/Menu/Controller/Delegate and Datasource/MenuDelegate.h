//
//  MenuDelegate.h
//  Walmart
//
//  Created by Bruno on 8/20/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALMenuViewController.h"

@interface MenuDelegate : NSObject <UITableViewDelegate>

- (id)initWithMenuReference:(WALMenuViewController *)controllerReference;

@end
