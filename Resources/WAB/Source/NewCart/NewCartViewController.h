//
//  NewCartViewController.h
//  Walmart
//
//  Created by Marcelo Santos on 5/16/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCartCardSimple.h"
#import "NewCartCardWarranty.h"
#import "OFShipAddressViewController.h"

#import "WMBCalculateShippingCostViewController.h"
#import "WMBDiscountCouponViewController.h"

#define kCellMargin 18.f

@interface NewCartViewController : WMBaseViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, newCartCardSimpleDelegate, newCartCardWarrantyDelegate, CalculateShippingForCEPProtocol, DiscountCouponProtocol>

@property (nonatomic, strong) IBOutlet UITableView *tbCart;
@property (nonatomic, strong) OFShipAddressViewController *shipAdd;
@property (nonatomic, strong) NSString *freightPriceLbl;

@property (assign, nonatomic) BOOL showLoginScreen;

@property (strong, nonatomic) NSArray *arrPicker;

- (IBAction) back;

- (IBAction) buyOrder;

@end
