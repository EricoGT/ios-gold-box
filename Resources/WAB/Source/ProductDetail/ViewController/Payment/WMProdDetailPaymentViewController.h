//
//  WMProdDetailPaymentViewController.h
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/12/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMBaseViewController.h"

@protocol prodDetailPaymentDelegate <NSObject>
@optional
- (void) closePaymentFromContinueShopping;
@end

@interface WMProdDetailPaymentViewController : WMBaseViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) NSString *standardSKU;
@property(nonatomic, strong) NSString *price;
@property(nonatomic, strong) NSString *sellerId;
@property (weak) id <prodDetailPaymentDelegate> delegate;

- (WMProdDetailPaymentViewController *)initWithStandardSKU:(NSString *)standardSKU price:(NSString *)price sellerId:(NSString *) sellerId delegate:(id<prodDetailPaymentDelegate>)delegate;

-(void)setStandardSKU:(NSString*)sku;
-(void)setPrice:(NSString *)price;

- (IBAction) cart;
@end
