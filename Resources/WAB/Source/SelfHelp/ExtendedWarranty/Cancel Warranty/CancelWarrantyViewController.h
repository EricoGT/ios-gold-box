//
//  CancelWarrantyViewController.h
//  Walmart
//
//  Created by Bruno on 6/11/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMBaseViewController.h"
#import "ExtendedWarrantyDetail.h"
#import "ExtendedWarrantyCancelManager.h"
#import "ExtendedWarrantyCancelTicket.h"
@class WMButtonRounded;
@class WMPickerTextField;
@class WMFloatLabelMaskedTextField;

typedef NS_ENUM(NSInteger, FormState) {
    FormStateInitial,
    FormStateChoosingRefundPossibilities,
    FormStateBankRefund,
    FormStateDocumentRefund
};

@protocol CancelWarrantyDelegate <NSObject>
@optional
- (void)cancelExtendedWarrantyWillPopBack;
- (void)didCancelExtendedWarrantyWithSuccess:(ExtendedWarrantyCancelTicket *)cancelTicket;
@end

@interface CancelWarrantyViewController : WMBaseViewController

@property (weak) id <CancelWarrantyDelegate> delegate;
@property (strong, nonatomic) ExtendedWarrantyDetail *warranty;

@property (weak, nonatomic) IBOutlet UIImageView *ticketIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *ticketNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *warrantyNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *enrollmentDateTitle;
@property (weak, nonatomic) IBOutlet UILabel *enrollmentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateTitle;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;

@property (weak, nonatomic) IBOutlet WMPickerTextField *reasonTextField;
@property (weak, nonatomic) IBOutlet WMPickerTextField *optionTextField;
@property (weak, nonatomic) IBOutlet WMPickerTextField *bankAccountTextField;
@property (weak, nonatomic) IBOutlet WMPickerTextField *bankNameTextField;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *agencyTextField;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *accountTextField;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *documentTextField;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (weak, nonatomic) IBOutlet WMButtonRounded *sendButton;

@property (nonatomic, assign) FormState state;

- (void)fillExtendedWarrantyCard;
- (void)showLoading;
- (void)hideLoading;
- (NSArray *)validateAndGetInvalidFields;

@end
