//
//  ExtendedWarrantyDetailViewController.h
//  Walmart
//
//  Created by Bruno Delgado on 5/28/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMBaseViewController.h"
@class ExtendedWarrantyDetail;

@interface ExtendedWarrantyDetailViewController : WMBaseViewController

@property (nonatomic, strong) NSString *ticketNumber;
@property (strong, nonatomic) ExtendedWarrantyDetail *warranty;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ticketIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *ticketNumberTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *warrantyNameLabel;
@property (weak, nonatomic) IBOutlet UIView *warrantyCard;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *enrollmentDateTitle;
@property (weak, nonatomic) IBOutlet UILabel *enrollmentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateTitle;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressTitle;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

- (void)setWarrantyState;
- (void)setupInterfaceForExtendedWarranty;

@end
