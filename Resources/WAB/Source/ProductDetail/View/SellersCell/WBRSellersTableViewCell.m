//
//  WBRSellersTableViewCell.m
//  Walmart
//
//  Created by Cássio Sousa on 20/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRSellersTableViewCell.h"
#import "NSNumber+Currency.h"
#import "OFFormatter.h"
#import "WBRCreditCardUtils.h"

NSString *const currency = @"R$ ";
NSString *const freeFreight = @"FRETE GRÁTIS";

@interface WBRSellersTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceOfLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *installmentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UIView *radioView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftContentView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

// Card Brand Container IBOutlets
@property (weak, nonatomic) IBOutlet UIView *cardBrandView;
@property (weak, nonatomic) IBOutlet UIButton *paymentOptionsButton;
@property (weak, nonatomic) IBOutlet UILabel *cardBrandTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardBrandViewHeightConstraint;

// Freight Container IBOutlets
@property (weak, nonatomic) IBOutlet UIView             *noFreightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noFreightViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView             *freightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freightViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *freightEstimateLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *freightScheduleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freightScheduleLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton           *freightMoreOptionsButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freightMoreOptionsButtonHeightConstraint;

@property (copy, nonatomic) NSString *sellerId;
@property (copy, nonatomic) SellerOptionModel *sellerOptionModel;

@end

static CGFloat const kCardBrandViewHeightConstraint            = 35.0f;

static CGFloat const kFreightViewHeightConstraint              = 90.0f;
static CGFloat const kFreightMoreOptionsButtonHeightConstraint = 19.0f;
static CGFloat const kFreightScheduleLabelConstraint           = 13.0f;
static CGFloat const kFreightNoFreightHeightConstraint         = 20.0f;

@implementation WBRSellersTableViewCell

#pragma mark - Setup Layout
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.checkImageView setImage:[UIImage imageNamed:selected ? @"shipmentCheckOn" : @"shipmentCheckOff"]];}

- (void)setupWithSellerOption:(SellerOptionModel *)sellerOption{
    
    self.sellerOptionModel = sellerOption;

    [self setupSellerButton:self.sellerOptionModel];
    [self setupPriceOf:self.sellerOptionModel];
    [self setupPrice:self.sellerOptionModel];
    [self setupInstallment:self.sellerOptionModel];
    [self setupFreight:self.sellerOptionModel];
    
    self.sellerId = self.sellerOptionModel.sellerId;
}

-(void)setupSellerButton:(SellerOptionModel *)sellerOption{
    self.sellerNameLabel.text = sellerOption.name;
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sellerName:)];
    [self.sellerNameLabel addGestureRecognizer:gesture];
}

-(void)setupPriceOf:(SellerOptionModel *)sellerOption{
    
    NSNumber *originalPrice = sellerOption.originalPrice;
    NSNumber *discountPrice = sellerOption.discountPrice;
    
    if (originalPrice.floatValue > discountPrice.floatValue) {
        UIFont *font = [UIFont fontWithName:@"Roboto-Regular" size:11];
        NSString *strValueOfStrike = originalPrice.integerValue > 0 ? [NSString stringWithFormat:@"%@", [originalPrice currencyFormatWithCurrencySymbol:currency]] : @"";
        
        NSMutableAttributedString *attributedValueOf = [[NSMutableAttributedString alloc] initWithString:strValueOfStrike];
        
        [attributedValueOf addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, strValueOfStrike.length)];
        [attributedValueOf addAttribute:NSStrikethroughStyleAttributeName value:@(1) range:NSMakeRange(0, strValueOfStrike.length)];
        
        self.priceOfLabel.attributedText = attributedValueOf;
        
    }
    else {
        self.priceOfLabel.text = @"";
    }
}

#pragma mark - Card Brand Setup
- (void)showCardBrand {
    [self.cardBrandView setHidden:NO];
    self.cardBrandViewHeightConstraint.constant = kCardBrandViewHeightConstraint;
}

- (void)hideCardBrand {
    [self.cardBrandView setHidden:YES];
    self.cardBrandViewHeightConstraint.constant = 0;
}

#pragma mark - Price Setup
-(void)setupPrice:(SellerOptionModel *)sellerOption{
    WBRPaymentSuggestion *paymentSuggestion = sellerOption.paymentSuggestion;
    NSNumber *discountPrice = sellerOption.discountPrice;
    UIColor *midGreen = RGBA(76, 175, 80, 1);
    
    NSMutableAttributedString *attributedTotal;
    
    if (paymentSuggestion && paymentSuggestion.discountedPrice && [paymentSuggestion isBankSlip] && [OFSetup enableBankSlipDiscount]) {
        
        UIFont *symbolFont = [UIFont fontWithName:@"Roboto-Regular" size:13];
        UIFont *currencyFont = [UIFont fontWithName:@"Roboto-Regular" size:17];
        UIFont *bankslipTextFont = [UIFont fontWithName:@"Roboto-Medium" size:11];
        
        NSString *bankslipText = paymentSuggestion.paymentMethodString;
        
        NSString *strValueComplete = [NSString stringWithFormat:@"%@%@", [paymentSuggestion.discountedPrice currencyFormatWithCurrencySymbol:currency], bankslipText];
        
        attributedTotal = [[NSMutableAttributedString alloc] initWithString:strValueComplete];
        [attributedTotal addAttribute:NSForegroundColorAttributeName value:midGreen range:NSMakeRange(0, strValueComplete.length)];
        [attributedTotal addAttribute:NSFontAttributeName value:currencyFont range:NSMakeRange(0, strValueComplete.length)];
        [attributedTotal addAttribute:NSFontAttributeName value:symbolFont range:NSMakeRange(0, currency.length)];
        [attributedTotal addAttribute:NSFontAttributeName value:bankslipTextFont range:NSMakeRange(strValueComplete.length - bankslipText.length, bankslipText.length)];
        
    } else {
        UIFont *symbolFont = [UIFont fontWithName:@"Roboto-Regular" size:13];
        UIFont *currencyFont = [UIFont fontWithName:@"Roboto-Regular" size:17];
        UIFont *centsFont = [UIFont fontWithName:@"Roboto-Regular" size:17];
        
        NSString *strValueComplete = [NSString stringWithFormat:@"%@", [discountPrice currencyFormatWithCurrencySymbol:currency]];
        
        attributedTotal = [[NSMutableAttributedString alloc] initWithString:strValueComplete];
        [attributedTotal addAttribute:NSForegroundColorAttributeName value:midGreen range:NSMakeRange(0, strValueComplete.length)];
        [attributedTotal addAttribute:NSFontAttributeName value:currencyFont range:NSMakeRange(0, strValueComplete.length)];
        [attributedTotal addAttribute:NSFontAttributeName value:symbolFont range:NSMakeRange(0, currency.length)];
        [attributedTotal addAttribute:NSFontAttributeName value:centsFont range:NSMakeRange(strValueComplete.length - 2, 2)];
    }
    
    
    
    self.priceLabel.attributedText = attributedTotal.copy;
}

#pragma mark - Installment Setup

-(void)setupInstallment:(SellerOptionModel *)sellerOption{
    
    WBRPaymentSuggestion *paymentSuggestion = sellerOption.paymentSuggestion;
    NSNumber *discountPrice = sellerOption.discountPrice;
    
    NSUInteger installmentsCount = sellerOption.instalment.integerValue;
    NSNumber *installmentValue = sellerOption.instalmentValue;
    
    //If not global, hide installments
    if (installmentsCount > 0) {
        
        UIColor *numberColor = RGB(76,175,80);
        UIColor *textColor = RGB(53,53,53);
        NSString *fontName = @"Roboto-Regular";
        int fontSize = 11;
        
        BOOL installmentCardStamp = [self setupCardBrandStamp:sellerOption];
        NSMutableAttributedString *installmentMutableAttString = [[NSMutableAttributedString alloc] init];
        
        if (paymentSuggestion && paymentSuggestion.discountedPrice && [paymentSuggestion isBankSlip] && [OFSetup enableBankSlipDiscount]) {
            
            NSString *installmentText = @"ou %@ em %ldx sem juros";
            if (installmentCardStamp) {
                installmentText = @"ou %@ em %ldx sem juros com";
            }
            NSString *fullPriceAndInstallmentString = [NSString stringWithFormat:installmentText,  [discountPrice currencyFormatWithCurrencySymbol:currency], (long)installmentsCount];
            installmentMutableAttString = [[NSMutableAttributedString alloc] initWithString:fullPriceAndInstallmentString
                                                                                                                        attributes:@{
                                                                                                                                     NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize],
                                                                                                                                     NSUnderlineStyleAttributeName : @0 ,
                                                                                                                                     NSForegroundColorAttributeName : numberColor
                                                                                                                                     }];
            NSRange orRange = [fullPriceAndInstallmentString rangeOfString:@"ou"];
            NSRange inRange = [fullPriceAndInstallmentString rangeOfString:@"em"];
            NSRange interestRange = [fullPriceAndInstallmentString rangeOfString:@"sem juros"];
            
            [installmentMutableAttString addAttribute:NSForegroundColorAttributeName value:textColor range:orRange];
            [installmentMutableAttString addAttribute:NSForegroundColorAttributeName value:textColor range:inRange];
            [installmentMutableAttString addAttribute:NSForegroundColorAttributeName value:textColor range:interestRange];
            
        } else {
        
            NSAttributedString *installmentValueAttr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ldx de ", (unsigned long) installmentsCount] attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : textColor}];
            
            NSAttributedString *intallmentPrice = [[NSAttributedString alloc] initWithString:[installmentValue currencyFormatWithCurrencySymbol:currency] attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size: fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : numberColor}];
            
            NSString *installmentText = @" sem juros";
            NSAttributedString *interestFree = [[NSAttributedString alloc] initWithString:installmentText attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : textColor}];
            
            [installmentMutableAttString appendAttributedString:installmentValueAttr];
            [installmentMutableAttString appendAttributedString:intallmentPrice];
            [installmentMutableAttString appendAttributedString:interestFree];
            
            
        }
        
        self.installmentLabel.attributedText = installmentMutableAttString;
        self.installmentLabel.hidden = NO;
    } else {
        
        self.installmentLabel.text = @"";
        self.installmentLabel.hidden = YES;
    }
}

- (BOOL)setupCardBrandStamp:(SellerOptionModel *)sellerOption {
    BOOL isInstallCampaignEnabled = [WALMenuViewController singleton].services.installCampaign.boolValue;
    BOOL isStampCampaignEnabled = [WALMenuViewController singleton].services.masterCampaign.boolValue;

    BOOL installmentCardStamp = NO;
    
    if (isStampCampaignEnabled && !isInstallCampaignEnabled) {
        if ((sellerOption.paymentTypes.count == 1 || sellerOption.paymentTypes.count == 2) && [WBRCreditCardUtils isPaymentTypesEnableStamp:sellerOption.paymentTypes]){
            installmentCardStamp = YES;
            [self showCardBrand];
        } else {
            [self hideCardBrand];
        }
    } else {
        [self hideCardBrand];
    }
    
    return installmentCardStamp;
}

#pragma mark - Freight Setup
- (void)setupFreight:(SellerOptionModel *)sellerOption {
    UIColor *midGreen = RGB(76, 175, 80);
    UIColor *textColor = RGB(53,53,53);

    if (sellerOption.deliveryTypes) {
        [self showFreightView:YES];
        
        NSArray<DeliveryType*> *deliveryTypes = [NSArray<DeliveryType*> arrayWithArray:sellerOption.deliveryTypes];

        NSNumber *estimateDaysNumber;
        NSNumber *priceNumber;
        
        if (deliveryTypes.count == 0) {
            [self showFreightView:NO];

            [self showNoFreightView:YES];
        
        } else if (deliveryTypes.count == 1 && (([deliveryTypes.firstObject.deliveryTypeID isEqualToString:@"5"]) || ([deliveryTypes.firstObject.deliveryTypeID isEqualToString:@"12"]))) {
            [self showScheduleViewLabel:YES];
            [self showNoFreightView:NO];
            [self showMoreFreightOptionsView:NO];

            estimateDaysNumber = deliveryTypes.firstObject.shippingEstimateInDays;
            priceNumber = deliveryTypes.firstObject.price;
            
        } else if (deliveryTypes.count == 2) {
            [self showNoFreightView:NO];
            [self showMoreFreightOptionsView:YES];
            [self showScheduleViewLabel:[self allDeliveryIsSchedule:deliveryTypes]];

            if (![deliveryTypes.firstObject.deliveryTypeID isEqualToString:@"5"] && (![deliveryTypes.firstObject.deliveryTypeID isEqualToString:@"12"])) {
                estimateDaysNumber = deliveryTypes.firstObject.shippingEstimateInDays;
                priceNumber = deliveryTypes.firstObject.price;
            } else {
                estimateDaysNumber = deliveryTypes[1].shippingEstimateInDays;
                priceNumber = deliveryTypes[1].price;
            }
            
        } else {
            [self showScheduleViewLabel:[self allDeliveryIsSchedule:deliveryTypes]];

            [self showNoFreightView:NO];
            [self showScheduleViewLabel:NO];

            priceNumber = deliveryTypes.firstObject.price;
            estimateDaysNumber = deliveryTypes.firstObject.shippingEstimateInDays;
        }
        
        if (deliveryTypes.count > 1) {
            [self showMoreFreightOptionsView:YES];
        } else {
            [self showMoreFreightOptionsView:NO];
        }
        
        if (priceNumber) {
            if (priceNumber.integerValue == 0) {
                NSAttributedString *priceNumberGreenString = [[NSAttributedString alloc] initWithString:freeFreight attributes:@{NSForegroundColorAttributeName : midGreen }];
                [self.freightPriceLabel setAttributedText:priceNumberGreenString];
            } else {
                NSString *priceString = [self priceForFreight:priceNumber];
                
                NSMutableAttributedString *priceColorString = [[NSMutableAttributedString alloc] initWithString:@"Por " attributes:@{NSForegroundColorAttributeName : textColor }];
                NSAttributedString *priceNumberGreenString = [[NSAttributedString alloc] initWithString:priceString attributes:@{NSForegroundColorAttributeName : midGreen }];
                [priceColorString appendAttributedString:priceNumberGreenString];
                [self.freightPriceLabel setAttributedText:priceColorString];
            }
        }
        
        
        if (estimateDaysNumber.integerValue > 1){
            [self.freightEstimateLabel setText:[NSString stringWithFormat: @"Até %@ dias úteis", estimateDaysNumber]];
        } else if (estimateDaysNumber.integerValue == 1) {
            [self.freightEstimateLabel setText:[NSString stringWithFormat: @"Até %@ dia útil", estimateDaysNumber]];
        } else {
            [self.freightEstimateLabel setText:[NSString stringWithFormat: @"Entrega hoje"]];
        }
        
    } else {
        [self showNoFreightView:NO];
        [self showFreightView:NO];
    }
}

#pragma mark - View Helpers
- (void)showFreightView:(BOOL)show {
    if (show) {
        [self.freightView setHidden:NO];
        self.freightViewHeightConstraint.constant = kFreightViewHeightConstraint;
    } else {
        [self.freightView setHidden:YES];
        self.freightViewHeightConstraint.constant = 0;
    }
}

- (void)showScheduleViewLabel:(BOOL)show {
    if (show) {
        [self.freightScheduleLabel setHidden:NO];
        self.freightScheduleLabelHeightConstraint.constant = kFreightScheduleLabelConstraint;
    } else {
        [self.freightScheduleLabel setHidden:YES];
        self.freightScheduleLabelHeightConstraint.constant = 0;
    }
}

- (void)showMoreFreightOptionsView:(BOOL)show {
    if (show) {
        [self.freightMoreOptionsButton setHidden:NO];
        self.freightMoreOptionsButtonHeightConstraint.constant = kFreightMoreOptionsButtonHeightConstraint;
    } else {
        [self.freightMoreOptionsButton setHidden:YES];
        self.freightMoreOptionsButtonHeightConstraint.constant = 0;
    }
}

- (void)showNoFreightView:(BOOL)show {
    if (show) {
        [self.noFreightView setHidden:NO];
        self.noFreightViewHeightConstraint.constant = kFreightNoFreightHeightConstraint;
    } else {
        [self.noFreightView setHidden:YES];
        self.noFreightViewHeightConstraint.constant = 0;
    }
}

- (BOOL)allDeliveryIsSchedule:(NSArray<DeliveryType*>*)deliveryType{
    BOOL allSchedule = YES;
    
    for (DeliveryType *deliveryTypeTemp in deliveryType) {
        if (![deliveryTypeTemp.deliveryTypeID isEqualToString:@"5"]) {
            allSchedule = NO;
            break;
        }
    }
    return allSchedule;
}

- (NSString *)priceForFreight:(NSNumber *)freightPrice {
    NSNumber *price = [NSNumber numberWithDouble:[freightPrice doubleValue]/100];
    
    if (price) {
        if (price.integerValue == 0) {
            return @"FRETE GRÁTIS";
        } else {
            NSNumberFormatter *formatter = [[OFFormatter sharedInstance] currencyFormatter];
            return [formatter stringFromNumber:price];
        }
    }
    return @"";
}

#pragma mark - Other Payment Method Action
- (IBAction)otherPaymentMethodTap:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(productSellerOtherPaymentTap:)]) {
        [self.delegate productSellerOtherPaymentTap:self.sellerOptionModel];
    }
}

#pragma mark - Seller Name Action
- (IBAction)sellerName:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(productSellerNameDidTapWithSellerId:)]) {
        [self.delegate productSellerNameDidTapWithSellerId:self.sellerId];
    }
}

#pragma mark - More Freight Options Action
- (IBAction)moreFreightOptionsTap:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(productSellerMoreOptionsFreightTap)]) {
        [self.delegate productSellerMoreOptionsFreightTap];
    }
}

#pragma mark - Hide Components
- (void)hideRadioButton{
    self.leftContentView.constant = 17;
    self.radioView.hidden = YES;
    [self layoutIfNeeded];
}

- (void)hideSeparator{
    self.separatorView.hidden = YES;
}

@end
