//
//  WBRContactOrdersViewController.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 3/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WMBaseViewController.h"
#import "WBRContactRequestOrderModel.h"

typedef void(^kOrderSelectionCompletionNotification)(WBRContactRequestOrderModel *selectedOrder, BOOL exists);

@interface WBRContactOrdersViewController : WMBaseViewController

- (instancetype)initWithOrders:(NSArray<WBRContactRequestOrderModel *> *)orders withSelectionItemNotification:(kOrderSelectionCompletionNotification)selectionCompletionNotification;

@end
