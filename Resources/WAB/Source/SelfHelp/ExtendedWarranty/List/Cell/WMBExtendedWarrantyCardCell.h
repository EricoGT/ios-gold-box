//
//  WMBExtendedWarrantyCardCell.h
//  Walmart
//
//  Created by Bruno Delgado on 8/11/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DATE_FORMAT @"dd/MM/yyyy"
@class ExtendedWarrantyResumeModel;

@interface WMBExtendedWarrantyCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *innerContentView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UILabel *ticketNumberTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *accessionDateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *accessionDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *extendedWarrantyLabel;
@property (weak, nonatomic) IBOutlet UILabel *coverageLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoader;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;

- (WMBExtendedWarrantyCardCell *)initForTestCase;
- (void)setupWithExtendedWarrantyResumeModel:(ExtendedWarrantyResumeModel *)warranty;
- (void)setupProductWithImage:(UIImage *)image;

@end
