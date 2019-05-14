//
//  NewCartOthers.m
//  Walmart
//
//  Created by Marcelo Santos on 5/20/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "NewCartOthers.h"
#import "UIImage+Additions.h"
#import "NSNumber+Currency.h"
#import "WBRCreditCardUtils.h"
#import "CouponView.h"

@interface NewCartOthers() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *addCouponViewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addCouponViewContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *addCouponButton;
@property (weak, nonatomic) IBOutlet UIButton *removeCouponButton;
@property (weak, nonatomic) IBOutlet UILabel *couponTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *couponIcon;

@property (weak, nonatomic) IBOutlet UIView *estimateShippingCostView;
@property (weak, nonatomic) IBOutlet UIButton *editPostalCodeButton;

@property (weak, nonatomic) IBOutlet UIView *cardBrandInstallmentSeparatorView;
@property (weak, nonatomic) IBOutlet UIView *cardBrandInstallmentView;
@property (weak, nonatomic) IBOutlet UIImageView *cardBrandInstallmentImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardBrandInstallmentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardBrandInstallmentAmountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardBrandInstallmentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardBrandInstallmentBottomHeight;

@property (nonatomic, copy) NSString *discountCouponCode;

@property (nonatomic, assign) BOOL zipCodeActive;

@property (assign, nonatomic) BOOL firstCouponAssignment;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *posYFirstItem;
@property (weak, nonatomic) IBOutlet UIView *couponRemovedView;
@property (assign, nonatomic) BOOL removedCoupon;
@property (weak, nonatomic) IBOutlet UILabel *couponRemovedLabel;

@end

static CGFloat const ContainerViewVisibleHeight = 25.0f;
static CGFloat const ContainerViewHiddenHeight = 0.0f;

static CGFloat const CardViewInstallmentsVisibleHeight = 38.0f;
static CGFloat const CardViewInstallmentsHiddenHeight = 0.0f;

@implementation NewCartOthers

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupCartFooterView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCartFooterView];
    }
    return self;
}

- (void)setupCartFooterView {
    
    BOOL isCouponEnabled = [WALMenuViewController singleton].services.isCouponEnabled.boolValue;
    
    if (isCouponEnabled) {
        self.addCouponViewContainer.hidden = NO;
        self.addCouponViewContainerHeightConstraint.constant = ContainerViewVisibleHeight;
    }
    else {
        self.addCouponViewContainer.hidden = YES;
        self.addCouponViewContainerHeightConstraint.constant = ContainerViewHiddenHeight;
    }
}

- (void)setCoupon:(NSDictionary *)coupon withNominalDiscount:(CGFloat)nominalDiscount {
    
    if (!_removedCoupon || coupon) {
        self.posYFirstItem.constant = -5;
        _couponRemovedView.hidden = YES;
    }
   
    if (coupon) {
        
        self.addCouponButton.hidden = YES;
        self.removeCouponButton.hidden = NO;
        
        [self.couponIcon setImage:[UIImage imageNamed:@"icTrashSmall"]];
        
        self.discountCouponCode = coupon[@"redemptionCode"];
        
        [self.couponTextLabel setText:[NSString stringWithFormat:@"Cupom de desconto %@", [self formatCouponCodeForPresentation:self.discountCouponCode]]];
        [self.couponTextLabel setTextColor:RGBA(76.0f, 175.0f, 80.0f, 1.0f)];
    }
    else {
        
        self.addCouponButton.hidden = NO;
        self.removeCouponButton.hidden = YES;
        
        [self.couponIcon setImage:[UIImage imageNamed:@"icCoupom"]];
        
        [self.couponTextLabel setText:@"Incluir cupom de desconto"];
        [self.couponTextLabel setTextColor:RGBA(33.0f, 150.0f, 243.0f, 1.0f)];
    }
    
    if (nominalDiscount > 0) {
        self.lblDiscountValue.text = [NSString stringWithFormat:@"-%@", [self currencyFormat:nominalDiscount] ];
        self.lblDiscountValue.hidden = NO;
    }
    else {
        [self currencyFormat:0];
        self.lblDiscountValue.hidden = YES;
    }
}

- (NSString *)formatCouponCodeForPresentation:(NSString *)discountCoupon {
    
    NSString *returnString;
    if ([discountCoupon length] <= 7) {
        //Mask half of the string
        NSInteger numberOfCharsToBeReplaced = ([discountCoupon length] / 2);
        NSMutableString *maskedString = [NSMutableString new];
        for (NSInteger i = 0; i < numberOfCharsToBeReplaced; i++) {
            [maskedString appendString:@"*"];
        }
        [maskedString appendString:[discountCoupon substringFromIndex:numberOfCharsToBeReplaced]];
        returnString = maskedString;
    }
    else {
        returnString = [NSString stringWithFormat:@"***%@", [discountCoupon substringWithRange:NSMakeRange([discountCoupon length] - 4, 4)]];
    }
    
    return returnString;
}

- (void)setupWithSubtotal:(float)subtotal
                 itemsQty:(int)itemsQty
               postalCode:(NSString *)postalCode
             freightPrice:(NSString *)freightPrice
                    total:(float)total
      valuePerInstallment:(float)valuePerInstallment
           installmentQty:(int)installmentQty
          bestInstallment:(WBRBestInstallment *)bestInstallment {
    
    [self setSubtotal:subtotal itemsQty:itemsQty];
    [self setFreightPrice:freightPrice andPostalCode:postalCode];
    [self setTotal:total valuePerInstallment:valuePerInstallment installmentQty:installmentQty];

    BOOL isStampCampaignEnabled = [WALMenuViewController singleton].services.masterCampaign.boolValue;
    BOOL isInstallCampaignEnabled = [WALMenuViewController singleton].services.installCampaign.boolValue;
    
    if (!isInstallCampaignEnabled) {
        if (isStampCampaignEnabled && bestInstallment && ((bestInstallment.paymentTypes.count == 1 || bestInstallment.paymentTypes.count == 2) && [WBRCreditCardUtils isPaymentTypesEnableStamp:bestInstallment.paymentTypes])) {
            [self showCardBrandInstallmentInfoView:[NSString stringWithFormat:@"%@", bestInstallment.installmentAmount] cardBrandName:@"Mastercard"];
        } else {
            [self hideCardBrandInstallmentInfoView];
        }
    } else {
        [self hideCardBrandInstallmentInfoView];
    }
}

- (void)setSubtotal:(float)subtotal itemsQty:(int)itemsQty {
    if (itemsQty > 1) {
        self.lblSubtotalTitle.text = [NSString stringWithFormat:@"Subtotal (%d itens):", itemsQty];
    }
    else {
        self.lblSubtotalTitle.text = @"Subtotal (1 item):";
    }
    self.lblSubtotalValue.text = [NSNumber currencyFormatWithFloatValue:subtotal];
}

- (void)setDiscountValue:(NSString *)discountValue {
    self.lblDiscountValue.text = discountValue;
}

- (void)setInstallmentBestAmount:(NSString *)installmentAmount cardBrandName:(NSString *)cardBrandName {

    //Card Brand Name
    NSMutableAttributedString *installmentCardNameFinalText = [[NSMutableAttributedString alloc] initWithString:@"Pague com " attributes:[self attributedNormalText]];
    NSMutableAttributedString *installmentCardNameText = [[NSMutableAttributedString alloc] initWithString:cardBrandName attributes:[self attributedBoldText]];
    [installmentCardNameFinalText appendAttributedString:installmentCardNameText];

    //Amount Text
    NSMutableAttributedString *installmentAmountAttributedFinal = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *installmentAmountFinalText = [[NSMutableAttributedString alloc] initWithString:@"e parcele em até " attributes:[self attributedNormalText]];
    [installmentAmountAttributedFinal appendAttributedString:installmentAmountFinalText];
    NSString *amountText = [NSString stringWithFormat:@"%@x", installmentAmount];
    NSMutableAttributedString *installmentAmountText = [[NSMutableAttributedString alloc] initWithString:amountText attributes:[self attributedGreenNormalText]];
    [installmentAmountAttributedFinal appendAttributedString:installmentAmountText];
    
    [self.cardBrandInstallmentTitleLabel setAttributedText:installmentCardNameFinalText];
    [self.cardBrandInstallmentAmountLabel setAttributedText:installmentAmountAttributedFinal];
}

- (void)setFreightPrice:(NSString *)price andPostalCode:(NSString *)postalCode {
    
    if (price && ![price isEqualToString:@""]) {
        
        self.lblFreightTitle.text = @"Frete para";
        if ([postalCode length] > 0) {
            NSMutableString *formattedPostalCode = [NSMutableString stringWithString:postalCode];
            if ([postalCode length] > 5) {
                [formattedPostalCode insertString:@"-" atIndex:5];
            }
            [self.editPostalCodeButton setTitle:formattedPostalCode forState:UIControlStateNormal];
        }
        
        self.editPostalCodeButton.hidden = NO;
        
        self.lblFreightValue.text = price;
        self.lblFreightValue.hidden = NO;
        self.estimateShippingCostView.hidden = YES;
    }
    else {
        self.lblFreightTitle.text = @"Frete:";
        self.editPostalCodeButton.hidden = YES;
        self.lblFreightValue.hidden = YES;
        self.estimateShippingCostView.hidden = NO;
    }
    LogNewCheck(@"FreightPriceLabel: %@", price);
}

- (void)setTotal:(float)total valuePerInstallment:(float)valuePerInstallment installmentQty:(int)installmentQty {
    
    NSString *totalCurrency = [NSNumber currencyFormatWithFloatValue:total];
    NSMutableAttributedString *totalCurrencyAttributed = [[NSMutableAttributedString alloc] initWithString:totalCurrency];
    UIFont *totalCurrencyFont = [UIFont fontWithName:@"Roboto-Medium" size:13.0f];
    [totalCurrencyAttributed addAttribute:NSFontAttributeName value:totalCurrencyFont range:NSMakeRange(0, 2)];
    self.lblTotalValue.attributedText = totalCurrencyAttributed;
    
    if (installmentQty > 0 && valuePerInstallment > 0) {
        
        NSString *totalInstCurrency = [NSNumber currencyFormatWithFloatValue:valuePerInstallment];
        NSString *totalInst = [NSString stringWithFormat:@"%dx de %@", installmentQty, totalInstCurrency];
        
        NSArray *arrFirstPart = [totalInst componentsSeparatedByString:totalInstCurrency];
        NSString *strFirstPart = [arrFirstPart objectAtIndex:0];
        
        NSMutableAttributedString *instAttributed = [[NSMutableAttributedString alloc] initWithString:totalInst];
        UIFont *currencyFont = [UIFont fontWithName:@"Roboto-Regular" size:11.0f];
        
        [instAttributed addAttribute:NSFontAttributeName value:currencyFont range:NSMakeRange(0, totalInst.length)];
        [instAttributed addAttribute:NSForegroundColorAttributeName value:RGBA(76, 175, 80, 255) range:NSMakeRange(strFirstPart.length, totalInstCurrency.length)];
        
        self.lblInstallment.attributedText = instAttributed;
    }
    else {
        self.lblInstallment.hidden = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [[NSString alloc] initWithString:[textField.text stringByAppendingString:string]];
    NSInteger lenght = text.length;
    
    NSCharacterSet *acceptableCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++)
    {
        unichar c = [string characterAtIndex:i];
        if (![acceptableCharactersSet characterIsMember:c])
        {
            return NO;
        }
    }
    
    if (lenght > 8) return NO;
    return YES;
}

- (void) continueBuying {
    if ([_delegate respondsToSelector:@selector(continueShopping)]) {
        [_delegate continueShopping];
    }
}

- (void) showMsgCouponRemoved:(NSString *) coupon {
    
    self.posYFirstItem.constant = 20;
    _couponRemovedView.hidden = NO;
    self.removedCoupon = YES;
    
    [self.couponRemovedLabel setText:[NSString stringWithFormat:@"O seguinte cupom foi excluído: %@", [self formatCouponCodeForPresentation:coupon]]];
}

#pragma mark Card Brand Stamp Helper
- (void)hideCardBrandInstallmentInfoView {
    [self.cardBrandInstallmentSeparatorView setHidden:YES];
    self.cardBrandInstallmentBottomHeight.constant = 70;
    [self.cardBrandInstallmentView setHidden:YES];
    _cardBrandInstallmentViewHeight.constant = CardViewInstallmentsHiddenHeight;
}

-(void)showCardBrandInstallmentInfoView:(NSString *)installmentAmount cardBrandName:(NSString *)cardBrandName {
    [self.cardBrandInstallmentSeparatorView setHidden:NO];
    [self.cardBrandInstallmentView setHidden:NO];
    self.cardBrandInstallmentBottomHeight.constant = 110;
    _cardBrandInstallmentViewHeight.constant = CardViewInstallmentsVisibleHeight;
    [self setInstallmentBestAmount:[NSString stringWithFormat:@"%@",installmentAmount] cardBrandName:cardBrandName];
}

#pragma mark - Button Actions
- (IBAction)removeCouponAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(removeCouponWithRedemptionCode:)]) {
        [_delegate removeCouponWithRedemptionCode:self.discountCouponCode];
    }
}

- (IBAction)addCouponAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(showAddCouponViewController)]) {
        [_delegate showAddCouponViewController];
    }
}

- (IBAction)calculateShipmentAction:(id)sender {
    [FlurryWM logEvent_cart_calc_shipping_btn];
    
    if ([_delegate respondsToSelector:@selector(showCalculateShipmentViewController)]) {
        [_delegate showCalculateShipmentViewController];
    }
}

- (IBAction)editZipCode:(id)sender {
    if ([_delegate respondsToSelector:@selector(showCalculateShipmentViewController)]) {
        [_delegate showCalculateShipmentViewController];
    }
}

#pragma mark - Auxiliary Methods
- (NSDictionary *)attributedBoldText {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0], NSForegroundColorAttributeName, nil];
    return dict;
}
- (NSDictionary *)attributedNormalText {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0], NSForegroundColorAttributeName, nil];
    return dict;
}

- (NSDictionary *)attributedGreenNormalText {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithRed:76.0f/255.0f green:175.0f/255.0f blue:80.0f/255.0f alpha:1.0], NSForegroundColorAttributeName, nil];
    return dict;
}


//Currency
- (NSString *) currencyFormat:(CGFloat) value {
    NSNumber *amount = [[NSNumber alloc] initWithFloat:value];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencySymbol:@"R$ "];
    [numberFormatter setMinimumFractionDigits:2];
    NSString *newFormat = [numberFormatter stringFromNumber:amount];
    return newFormat;
}

@end
