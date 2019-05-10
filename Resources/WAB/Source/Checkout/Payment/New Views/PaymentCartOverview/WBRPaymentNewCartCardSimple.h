//
//  NewCartCardSimple.h
//  Walmart
//
//  Created by Marcelo Santos on 5/19/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMStepper.h"

#define kProductTitleLabelSize 206
#define kProductTitleFont [UIFont fontWithName:@"OpenSans" size:13]

#define kMinimumTextSize 50
#define kTitleTopMargin 10
#define kSellerViewHeight 24
#define kStepperViewHeight 64
#define kTitleBottonMargin 10
#define kBottonViewHeight 50
#define kViewWarningHeight 40
#define kViewProductHeight 175
#define kViewFooterHeight 50
#define kExtendedWarrantyHeight 24

@protocol WBRPaymentNewCartCardSimpleDelegate <NSObject>
@required
@optional
- (void)qtyPressed:(int)qty keyProduct:(NSString *)keyProd descriptionProduct:(NSString *)desc selId:(NSString *)sellId andOldQty:(NSString *)oldQt;
- (void)updateProductQuantityForNewQuantity:(NSInteger)newQuantity forKeyProduct:(NSString *)keyProd sellerID:(NSString *)sellId;
- (void)keyProduct:(NSString *)keyProd selId:(NSString *)sellId prodId:(NSString *)prodId;
- (void)showSellerDescriptionWithSellerId:(NSString *)sellerId;
- (void)changeDeliveryDateTouched;
@end

@interface WBRPaymentNewCartCardSimple : UITableViewCell

@property (weak) id <WBRPaymentNewCartCardSimpleDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *viewProduct;
@property (weak, nonatomic) IBOutlet UIButton *btDelete;
@property (weak, nonatomic) IBOutlet UILabel *deliveryDaysLabel;

+ (NSString *)reuseIdentifier;

- (void)setCell:(NSDictionary *) dictProdInfo;

@end
