//
//  NewCartCardSimple.m
//  Walmart
//
//  Created by Marcelo Santos on 5/19/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "WBRPaymentNewCartCardSimple.h"
#import "NSString+HTML.h"
#import "ImageCache.h"
#import "NSString+Additions.h"
#import "WMImageView.h"
#import "NSNumber+Currency.h"
#import "WBRScheduleDeliveryUtils.h"

@interface WBRPaymentNewCartCardSimple ()

@property (strong, nonatomic) NSString *sellerId;
@property (strong, nonatomic) NSString *sellerName;

@property (weak, nonatomic) IBOutlet UILabel *sellerInfoLabel;

@property (strong, nonatomic) NSDictionary *dictProd;

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblProductNotAvailable;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;
@property (weak, nonatomic) IBOutlet UIView *viewPriceDiff;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceDiff;
@property (weak, nonatomic) IBOutlet WMImageView *imgThumb;
@property (weak, nonatomic) IBOutlet UIView *viewPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblMsgWarning;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warningLabelTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warningLabelBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightUnavailable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *posYUnavailable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *posYFirstCard;

@end

@implementation WBRPaymentNewCartCardSimple

+ (NSString *)reuseIdentifier {
    return @"cellCartSimple";
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    _viewWarning.layer.cornerRadius = 2.0f;
//    _viewWarning.layer.masksToBounds = YES;
//    _viewNotAvailable.layer.cornerRadius = 2.0f;
//    _viewNotAvailable.layer.masksToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_lblMsgWarning.superview setNeedsLayout];
    [_lblMsgWarning.superview layoutIfNeeded];
    _lblMsgWarning.preferredMaxLayoutWidth = _lblMsgWarning.bounds.size.width;
    
    [_sellerInfoLabel.superview setNeedsLayout];
    [_sellerInfoLabel.superview layoutIfNeeded];
    _sellerInfoLabel.preferredMaxLayoutWidth = _sellerInfoLabel.bounds.size.width;
    
   // [_viewWarning updateConstraintsIfNeeded];
    [self.superview layoutIfNeeded];
    //[_viewWarning layoutIfNeeded];
    
    [_lblDescription updateConstraintsIfNeeded];
    [self.superview layoutIfNeeded];
    [_lblDescription layoutIfNeeded];
}

- (void)setCell:(NSDictionary *) dictProdInfo {
    
    LogNewCheck(@"Dict Card: %@", dictProdInfo);
    
    self.dictProd = dictProdInfo;
    _viewPriceDiff.hidden = YES;
    
    [self fillValues];
    
    self.sellerId = dictProdInfo[@"sellerId"];
    self.sellerName = dictProdInfo[@"sellerName"];
    
    if (_sellerName.length > 0) {
        NSString *sellerInfo = [NSString stringWithFormat:SELLER_SOLD_AND_DELIVERED_BY_FORMAT, _sellerName];
        NSMutableAttributedString *attributedSellerInfo = [[NSMutableAttributedString alloc] initWithString:sellerInfo];
        [attributedSellerInfo addAttribute:NSForegroundColorAttributeName value:RGBA(26, 117, 207, 1) range:[sellerInfo rangeOfString:_sellerName]];
        _sellerInfoLabel.attributedText = attributedSellerInfo.copy;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedSellerInfo:)];
        [_sellerInfoLabel addGestureRecognizer:tapGesture];
        _sellerInfoLabel.userInteractionEnabled = YES;
    }
    
    BOOL qtyAvailable = [dictProdInfo[@"quantityAvailable"] boolValue];
    
    BOOL priceIsDivergent = [dictProdInfo[@"priceDivergent"] boolValue];
    BOOL errorRoute = [dictProdInfo[@"errorRoute"] boolValue];
    BOOL errorGeneralBySeller = [dictProdInfo[@"errorGeneralBySeller"] boolValue];
    BOOL errorCartLevel = [dictProdInfo[@"errorCartLevel"] boolValue];
    BOOL couponNotAllowed = [dictProdInfo[@"couponNotAllowed"] boolValue];
    BOOL noStock = [_dictProd[@"unavailableProduct"] boolValue];
    
    if (noStock) { // unavailable
        [self.btDelete setImage:[UIImage imageNamed:@"icTrash"] forState:UIControlStateNormal];
        _viewPrice.hidden = YES;
        _heightUnavailable.constant = 33;
    }
    else {
        
        _posYUnavailable.constant = 20;
        [self.btDelete setImage:[UIImage imageNamed:@"icTrash"] forState:UIControlStateNormal];
        _viewPrice.hidden = NO;
        _heightUnavailable.constant = 0;
    }

    BOOL showWarning = NO;
    
    if ((priceIsDivergent || !qtyAvailable || errorRoute || errorGeneralBySeller || errorCartLevel || couponNotAllowed) && !noStock)
    {
        //Show warning
        
        showWarning = YES;
        
        _warningLabelTopSpaceConstraint.constant = 5.0f;
        _warningLabelBottomSpaceConstraint.constant = 5.0f;
        
        if (couponNotAllowed) {
            _lblMsgWarning.attributedText = [self formatErrorWithXtid:COUPON_NOT_ALLOWED];
        }
        else if (!qtyAvailable)
        {
            _lblMsgWarning.attributedText = [self formatErrorWithXtid:ERROR_PRODUCT_QUANTITY_AVAILABLE];
        }
        else if (priceIsDivergent)
        {
            _lblMsgWarning.attributedText = [self formatErrorWithXtid:PRODUCT_PRICE_DIVERGENT];
        }
        else if (errorGeneralBySeller)
        {
            _lblMsgWarning.attributedText = [self formatErrorWithXtid:ERROR_GENERAL_SELLER];
        }
        else if (errorRoute)
        {
            _lblMsgWarning.attributedText = [self formatErrorWithXtid:ERROR_SHIPPING_ROUTE];
        }
        else if (errorCartLevel)
        {
            _lblMsgWarning.attributedText = [self formatErrorWithXtid:ERROR_GENERAL_SELLER];
        }
        else
        {
            _lblMsgWarning.attributedText = [self formatErrorWithXtid:ERROR_GENERAL_SELLER];
        }
    }
    else {
        
        _lblMsgWarning.text = @"";
        _warningLabelTopSpaceConstraint.constant = 0.0f;
        _warningLabelBottomSpaceConstraint.constant = 0.0f;
    }
}

- (NSAttributedString *) formatErrorWithXtid:(NSString *) msgError {
    
    NSString *completeErrorMsg = [NSString stringWithFormat:@"%@ %@", msgError, _dictProd[@"loggerKey"]];
    
    NSMutableAttributedString *errorAttributed = [[NSMutableAttributedString alloc] initWithString:completeErrorMsg];
    UIFont *currencyFont = [UIFont fontWithName:@"Roboto" size:9.0f];
    
    [errorAttributed addAttribute:NSFontAttributeName value:currencyFont range:NSMakeRange(msgError.length, completeErrorMsg.length - msgError.length)];
    [errorAttributed addAttribute:NSForegroundColorAttributeName value:RGBA(153, 153, 153, 255) range:NSMakeRange(msgError.length, completeErrorMsg.length - msgError.length)];
    
    return errorAttributed;
}


- (void) fillValues {
    NSString *pathImage = _dictProd[@"imageUrl"] ?: @"";
    
    if ([pathImage rangeOfString:@"//"].location == NSNotFound) {
        NSString *strSeparator = @"//";
        pathImage = [strSeparator stringByAppendingString:pathImage];
        
    }
    
    NSArray *arrPathImg = [pathImage componentsSeparatedByString:@"//"];
    NSString *strProtocol = arrPathImg[0];
    
    if (strProtocol.length == 0) {
        
        NSString *strUrl = arrPathImg[1];
        strProtocol = @"https://";
        pathImage = [strProtocol stringByAppendingString:strUrl];
        
    }

    pathImage = [pathImage stringByAppendingString:@"-120-120"];

    [_imgThumb setImageWithURL:[NSURL URLWithString:pathImage] failureImageName:IMAGE_UNAVAILABLE_NAME];
    
    LogNewCheck(@"Path Img: %@", pathImage);

    _lblDescription.text = [_dictProd[@"description"] kv_decodeHTMLCharacterEntities];
    
    float qtyProduct = [_dictProd[@"quantity"] floatValue];

    NSNumber *value = @([_dictProd[@"price"] floatValue] / 100 * qtyProduct);
    NSString *strValue = [value currencyFormat];
    
    _lblValue.text = strValue;
    
    int qty = [_dictProd[@"quantity"] intValue];
    self.quantityLabel.text = [NSString stringWithFormat:@"Quantidade %i", qty];
    
    NSDictionary *deliveryWindow = self.dictProd[@"selectedDelivery"][@"deliveryWindow"];
    if (deliveryWindow != nil) {
        
        NSNumber *UTCTime = deliveryWindow[@"startDateUtc"];
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:(UTCTime.doubleValue) / 1000.0];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *formattedDate = [dateFormatter stringFromDate:startDate];
        
        NSString *period = deliveryWindow[@"period"];
        
        NSString *scheduledShippingText = [NSString stringWithFormat:@"%@ - Período: %@", formattedDate, [WBRScheduleDeliveryUtils convertePeriodText:period]];
        self.deliveryDaysLabel.text = scheduledShippingText;
        
    } else {
        NSString *customDeliveryInformation = self.dictProd[@"customDeliveryInformation"];
        self.deliveryDaysLabel.text = [NSString stringWithFormat:@"Entrega %@", [customDeliveryInformation lowercaseString]];
    }
}

- (void)errorConnection:(NSString *) msgError {
    LogInfo(@"Error cardproductcart: %@", msgError);
}

- (IBAction)toucheChangeDeliveryDate:(id)sender {
    if ([self.delegate respondsToSelector:@selector(changeDeliveryDateTouched)]) {
        [self.delegate changeDeliveryDateTouched];
    }
}

- (void)tappedSellerInfo:(id)sender {
    if ([_delegate respondsToSelector:@selector(showSellerDescriptionWithSellerId:)]) {
        [_delegate showSellerDescriptionWithSellerId:_sellerId];
    }
}

@end
