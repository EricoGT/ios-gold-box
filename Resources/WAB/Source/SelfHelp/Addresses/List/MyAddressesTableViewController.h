//
//  MyAddressesTableViewController.h
//  Walmart
//
//  Created by Renan on 5/15/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseViewController.h"

@interface MyAddressesTableViewController : WMBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *addresses;

- (NSArray *)reorderedAddresses:(NSArray *)addresses;

@end
