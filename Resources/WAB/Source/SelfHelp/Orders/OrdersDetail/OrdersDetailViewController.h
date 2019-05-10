//
//  OrdersDetailViewController.h
//  Tracking
//
//  Created by Bruno Delgado on 4/22/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "WMBaseViewController.h"
#import "Order.h"

#define TimelineAlertActionNotification @"TimelineAlertActionNotification"
#define kAlertURL @"AlertURLKey"
#define kAlertType @"AlertTypeKey"
#define kTypeAlertInvoicePDF @"kAlertInvoicePDF"
#define kTypeEmail @"kAlertInvoiceEmail"
#define kTypeBarcode @"kAlertBarcode"

@interface OrdersDetailViewController : WMBaseViewController {
    
    NSMutableDictionary *dict1;
    NSMutableDictionary *dict2;
    NSMutableDictionary *dict3;
    NSMutableArray *arrStatus;
}

@property (nonatomic, strong) Order *order;

@end
