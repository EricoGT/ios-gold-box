//
//  ProductCardCell.m
//  Walmart
//
//  Created by Bruno Delgado on 9/29/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "ProductCardCell.h"
#import "SearchProduct.h"
#import "SearchProductHubConnection.h"
#import "NSString+HTML.h"
#import "OFFormatter.h"
#import "UIImageView+WebCache.h"
#import "NSString+Additions.h"

#import "WMHeartButton.h"
#import "WishlistConnection.h"

#import "WBRSetupManager.h"
#import "WBRCompleteRatingView.h"

#import "WBRCreditCardUtils.h"

@interface ProductCardCell ()

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *priceFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *installmentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *outOfStockLabel;

@property (weak, nonatomic) IBOutlet WMHeartButton *heartButton;

@property (weak, nonatomic) IBOutlet UIImageView *promotionStamp;

@property (weak, nonatomic) IBOutlet UIImageView *installCampaignStampImageView;

@property (weak, nonatomic) IBOutlet UIView *installmentAmountStampView;
@property (weak, nonatomic) IBOutlet UILabel *installmentAmountStampLabel;

@property (weak, nonatomic) IBOutlet UIView *colorsStampView;
@property (weak, nonatomic) IBOutlet UIImageView *colorsImageView;
@property (weak, nonatomic) IBOutlet UILabel *colorsStampCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *globalStamp;

@property (strong, nonatomic) SearchProduct *product;
@property (strong, nonatomic) SearchProductHubConnection *productHubConnection;

@property (weak, nonatomic) IBOutlet WBRCompleteRatingView *completeRatingView;

@end

@implementation ProductCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _cardView.clipsToBounds = YES;
    
    _cardView.layer.masksToBounds = NO;
    _cardView.layer.shadowColor = RGB(204, 204, 204).CGColor;
    _cardView.layer.shadowOpacity = 0.5;
    _cardView.layer.shadowOffset = CGSizeMake(0, 2);
    _cardView.layer.shadowRadius = 4;
    _cardView.layer.cornerRadius = 2;
}

- (void)layoutSubviews {
    _nameLabel.preferredMaxLayoutWidth = _nameLabel.bounds.size.width;
    _priceFromLabel.preferredMaxLayoutWidth = _priceFromLabel.bounds.size.width;
    _priceLabel.preferredMaxLayoutWidth = _priceLabel.bounds.size.width;
    _installmentsLabel.preferredMaxLayoutWidth = _installmentsLabel.bounds.size.width;
    
    [super layoutSubviews];
}

- (void)setupWithSearchProductHubConnection:(SearchProductHubConnection *)product {
    
    self.heartButton.hidden = ![OFSetup canAddProductsToTheWishlistOutsideProductDetail];
    NSString *productDecoded = [product.title kv_decodeHTMLCharacterEntities];
    productDecoded = [productDecoded kv_decodeHTMLCharacterEntities];
    
    _nameLabel.text = productDecoded;
    
    SearchProductVariation *variation = product.productVariations[0];
    
    BOOL isInstallCampaignEnabled = [WALMenuViewController singleton].services.installCampaign.boolValue;
    BOOL isStampCampaignEnabled = [WALMenuViewController singleton].services.masterCampaign.boolValue;

    if (isInstallCampaignEnabled) {

        __weak ProductCardCell *weakSelf = self;
        [WBRSetupManager getInstallCampaign:^(WBRInstallCampaign *installCampaignModel) {
            if ((installCampaignModel) && (variation.discountPrice.doubleValue > installCampaignModel.minValue.doubleValue)) {
                [weakSelf.installCampaignStampImageView sd_setImageWithURL:[NSURL URLWithString:installCampaignModel.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [weakSelf.installCampaignStampImageView setHidden:NO];
                }];
            } else {
                [weakSelf.installCampaignStampImageView setHidden:YES];
            }
        } failure:^(NSDictionary *dictError) {
            [weakSelf.installCampaignStampImageView setHidden:YES];
        }];

    } else if (isStampCampaignEnabled) {
        [self updateProductInstallmentStamp:variation.paymentTypes andInstallmentAmount:variation.instalment];
    }
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.currencySymbol = @"R$ ";
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    if (product.productVariations.count > 1 || product.priceVariations)
    {
        _priceFromLabel.text = @"A partir de";
    }
    else if (variation.price.floatValue < variation.originalPrice.floatValue) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[formatter stringFromNumber:variation.originalPrice]];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@1
                                range:NSMakeRange(0, [attributeString length])];
        _priceFromLabel.attributedText = attributeString.copy;
    }
    else {
        _priceFromLabel.text = @"";
    }
    
    _priceLabel.text = [formatter stringFromNumber:variation.discountPrice];
    
    if (variation.instalment && variation.instalmentValue)
    {
        NSString *installmentPriceFormatted = [formatter stringFromNumber:variation.instalmentValue];
        
        NSString *installmentText;
        
        if (variation.instalment.integerValue == 1) {
            installmentText = [NSString stringWithFormat:@"À vista"];
        }
        else {
            installmentText = [NSString stringWithFormat:@"%ldx de %@ sem juros", (long)variation.instalment.integerValue, installmentPriceFormatted];
        }
        _installmentsLabel.text = installmentText;
    }
    else
    {
        _installmentsLabel.text = @"";
    }
    
    NSString *imageURLString;
    
    if (product.imageIds.count > 0) {
        NSString *imageID = product.imageIds[0];
        imageURLString = [product.baseImageUrl stringByAppendingString:imageID];
    }
    else if (variation.imageIds.count > 0) {
        NSString *imageID = [variation.imageIds[0] stringValue];
        imageURLString = [product.baseImageUrl stringByAppendingString:imageID];
    }
    
    if (imageURLString.length > 0) {
        __weak UIActivityIndicatorView *weakLoader = _activityIndicator;
        [_activityIndicator startAnimating];
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:imageURLString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakLoader stopAnimating];
            if (!image){
                self.productImageView.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME_2];
            }
        }];
    }
    else {
        [_activityIndicator stopAnimating];
        self.productImageView.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME_2];
    }
    
    BOOL available = variation.quantityAvailable.integerValue > 0;
    _outOfStockLabel.hidden = available;
    _priceFromLabel.hidden = !available;
    _priceLabel.hidden = !available;
    _installmentsLabel.hidden = !available;
    
    self.globalStamp.hidden = YES;
    if (variation.sellerId)
    {
        self.globalStamp.hidden = ([variation.sellerId isEqualToString:@"0"]) ? NO : YES;
    }
    
    NSInteger avaliableColors = (variation.totalColors) ? variation.totalColors.integerValue : 0;
    if (avaliableColors > 1)
    {
        self.colorsStampCountLabel.text = [NSString stringWithFormat:@"%li", (long)avaliableColors];
        self.colorsStampCountLabel.font = [UIFont fontWithName:@"OpenSans" size:11];
        self.colorsStampView.hidden = NO;
    }
    else
    {
        self.colorsStampView.hidden = YES;
        self.colorsStampCountLabel.text = @"";
    }
    
    self.promotionStamp.hidden = YES;
    if ((product.stampUrl) && (![product.stampUrl isEqualToString:@""]))
    {
        [self.promotionStamp sd_setImageWithURL:[NSURL URLWithString:product.stampUrl]];
        self.promotionStamp.hidden = NO;
    }
    
    self.productHubConnection = product;
    
    self.completeRatingView.hidden = YES;
}

- (void)setupWithSearchProduct:(SearchProduct *)product
{
    //Hide Global Stamp - Deprecated
    self.globalStamp.hidden = YES;
    
    //Heart button status
    self.heartButton.hidden = ![OFSetup canAddProductsToTheWishlistOutsideProductDetail];
    
    //Update Product Name
    NSString *productDecoded = [product.title kv_decodeHTMLCharacterEntities];
    productDecoded = [productDecoded kv_decodeHTMLCharacterEntities];
    _nameLabel.text = productDecoded;
    
    //Verify availability
    BOOL available = [self updateProductAvailability:product];
    
    if (available) {
        
        [self updateProductPrice:product];
        [self updateProductColors:product];
        [self updateProductStamp:product];
        
        BOOL isInstallCampaignEnabled = [WALMenuViewController singleton].services.installCampaign.boolValue;
        BOOL isStampCampaignEnabled = [WALMenuViewController singleton].services.masterCampaign.boolValue;

        if (isInstallCampaignEnabled) {
            [self.installmentAmountStampView setHidden:YES];
            [self.installmentAmountStampLabel setText:@""];

            __weak ProductCardCell *weakSelf = self;
            [WBRSetupManager getInstallCampaign:^(WBRInstallCampaign *installCampaignModel) {
                if ((installCampaignModel) && (product.sellPrice.doubleValue > installCampaignModel.minValue.doubleValue)) {
                    [weakSelf.installCampaignStampImageView sd_setImageWithURL:[NSURL URLWithString:installCampaignModel.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        [weakSelf.installCampaignStampImageView setHidden:NO];
                    }];
                } else {
                    [weakSelf.installCampaignStampImageView setHidden:YES];
                }
            } failure:^(NSDictionary *dictError) {
                [weakSelf.installCampaignStampImageView setHidden:YES];
            }];
            
        } else if (isStampCampaignEnabled) {
            [self updateProductInstallmentStamp:product.paymentTypes andInstallmentAmount:product.instalment];
            [self.installCampaignStampImageView setHidden:YES];

        } else {
            [self.installCampaignStampImageView setHidden:YES];
            
            [self.installmentAmountStampView setHidden:YES];
            [self.installmentAmountStampLabel setText:@""];
        }
    } else {
        self.colorsStampView.hidden = YES;
        self.colorsStampCountLabel.text = @"";

        [self.installCampaignStampImageView setHidden:YES];
        [self.installmentAmountStampView setHidden:YES];
        [self.installmentAmountStampLabel setText:@""];
    }
    
    [self setupRatingViewWithRating:product.rating];
    
    _outOfStockLabel.hidden = available;
    _priceFromLabel.hidden = !available;
    _priceLabel.hidden = !available;
    _installmentsLabel.hidden = !available;
    
    [self updateProductImage:product];
    
    self.product = product;
    [self updateHeartStatus];
}

- (void)setupRatingViewWithRating:(WBRRatingModel *)rating {
    _completeRatingView.onlyRatingScore = YES;
    
    if (rating.totalOfRatings && rating) {
        self.completeRatingView.hidden = NO;
        self.completeRatingView.rating = rating;
    }
    else {
        self.completeRatingView.hidden = YES;
    }
    
}


- (BOOL) updateProductAvailability:(SearchProduct *) product {
    
    BOOL available = YES;
    
    if (product.sellPrice.floatValue == 0 || !product.hasAvailability.boolValue) {
        available = NO;
    }
    
    return available;
}


- (void) updateProductPrice:(SearchProduct *)product {
    
    //Top grey label
    LogMicro(@"Product listPrice: %f", product.listPrice.floatValue);
    LogMicro(@"Product sellPrice: %f", product.sellPrice.floatValue);
    
    double listPrice = product.listPrice.doubleValue;
    double sellPrice = product.sellPrice.doubleValue;
    
    if (product.paymentSuggestion && product.paymentSuggestion.discountedPrice && [product.paymentSuggestion isBankSlip] && [OFSetup enableBankSlipDiscount]) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[self currencyFormatDouble:listPrice]];
        
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@1
                                range:NSMakeRange(0, [attributeString length])];
        _priceFromLabel.attributedText = attributeString.copy;
    }
    else {
        
        if (product.hasMoreOffers.boolValue || product.hasSkuOptions.boolValue) {
            _priceFromLabel.text = @"A partir de";
        }
        else {
            
            if (!listPrice) {
                _priceFromLabel.text = @"Por apenas";
            }
            else if (listPrice > sellPrice) {
                NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[self currencyFormatDouble:listPrice]];
                
                [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                        value:@1
                                        range:NSMakeRange(0, [attributeString length])];
                _priceFromLabel.attributedText = attributeString.copy;
            }
            else {
                _priceFromLabel.text = @"";
            }
        }
    }
    
    //Green Price
    if (product.paymentSuggestion && product.paymentSuggestion.discountedPrice && [product.paymentSuggestion isBankSlip] && [OFSetup enableBankSlipDiscount]) {
        [self formatPriceLabelForDiscountedPrice:product.paymentSuggestion.discountedPrice andPaymentMethodString:product.paymentSuggestion.paymentMethodString];
    }
    else {
        NSNumber *amount = [NSNumber numberWithDouble: product.sellPrice.doubleValue];
        [self formatPriceLabel: amount];
    }
    
    //Instalment
    if (product.paymentSuggestion && product.paymentSuggestion.discountedPrice && [product.paymentSuggestion isBankSlip] && [OFSetup enableBankSlipDiscount]) {
        
        UIColor *numberColor = RGB(102,102,102);
        UIColor *textColor = RGB(153,153,153);
        
        NSString *fullPriceAndInstallmentString = [NSString stringWithFormat:@"ou %@ em %@x sem juros", [self currencyFormatDouble:sellPrice], product.instalment];
        NSMutableAttributedString *fullPriceAndInstallmentAttributedString = [[NSMutableAttributedString alloc] initWithString:fullPriceAndInstallmentString
                                                                                                                    attributes:@{
                                                                                                                                 NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular" size:13],
                                                                                                                                 NSUnderlineStyleAttributeName : @0 ,
                                                                                                                                 NSForegroundColorAttributeName : numberColor
                                                                                                                                 }];
        NSRange orRange = [fullPriceAndInstallmentString rangeOfString:@"ou"];
        NSRange inRange = [fullPriceAndInstallmentString rangeOfString:@"em"];
        NSRange interestRange = [fullPriceAndInstallmentString rangeOfString:@"sem juros"];
        
        [fullPriceAndInstallmentAttributedString addAttribute:NSForegroundColorAttributeName value:textColor range:orRange];
        [fullPriceAndInstallmentAttributedString addAttribute:NSForegroundColorAttributeName value:textColor range:inRange];
        [fullPriceAndInstallmentAttributedString addAttribute:NSForegroundColorAttributeName value:textColor range:interestRange];
        
        _installmentsLabel.attributedText = fullPriceAndInstallmentAttributedString;
    }
    else {
        if (product.instalment && product.instalmentValue) {
            
            NSString *installmentPriceFormatted = [self currencyFormatDouble:product.instalmentValue.doubleValue];
            
            NSString *installmentText = [NSString stringWithFormat:@"À vista"];
            
            if (product.instalment.integerValue > 1) {
                
                UIColor *installmentDefaultColor = RGB(153, 153, 153);
                NSString *fontName = @"Roboto-Regular";
                int fontSize = 13;
                
                NSAttributedString *installmentValue = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ldx de ", (long)product.instalment.integerValue] attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : installmentDefaultColor}];
                
                NSAttributedString *intallmentPrice = [[NSAttributedString alloc] initWithString:installmentPriceFormatted attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size: fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : RGB(102,102,102)}];
                
                NSAttributedString *interestFree = [[NSAttributedString alloc] initWithString:@" sem juros" attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : installmentDefaultColor}];
                
                NSMutableAttributedString *installmentMutableAttString = [[NSMutableAttributedString alloc] init];
                
                [installmentMutableAttString appendAttributedString:installmentValue];
                [installmentMutableAttString appendAttributedString:intallmentPrice];
                [installmentMutableAttString appendAttributedString:interestFree];
                
                _installmentsLabel.attributedText = installmentMutableAttString;
            }else{
                _installmentsLabel.text = installmentText;
            }
        }
        else {
            
            _installmentsLabel.text = @"";
        }
    }
}


- (void) updateProductImage:(SearchProduct *)product {
    
    //Image
    __weak ProductCardCell *weakSelf = self;
    [WBRSetupManager getBaseImages:^(ModelBaseImages *baseImagesModel) {
        
        NSString *pathImgSearch = baseImagesModel.products ?: @"";
        pathImgSearch = [pathImgSearch stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *imageID = product.imageId;
        NSString *imageURLString = [pathImgSearch stringByAppendingString:imageID];
        
        if (imageURLString.length > 0) {
            __weak UIActivityIndicatorView *weakLoader = weakSelf.activityIndicator;
            [weakSelf.activityIndicator startAnimating];
            
            [weakSelf.productImageView sd_setImageWithURL:[NSURL URLWithString:imageURLString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [weakLoader stopAnimating];
                if (!image) {
                    weakSelf.productImageView.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME_2];
                }
            }];
        }
        else {
            [weakSelf.activityIndicator stopAnimating];
            weakSelf.productImageView.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME_2];
        }
        
        
    } failure:^(NSDictionary *dictError) {
        
        [weakSelf.activityIndicator stopAnimating];
        weakSelf.productImageView.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME_2];
    }];
}

- (void) updateProductColors:(SearchProduct *)product {
    
    //Colors
    
    NSInteger avaliableColors = (product.totalColors) ? product.totalColors.integerValue : 0;
    
    if (avaliableColors > 1)
    {
        self.colorsStampCountLabel.text = [NSString stringWithFormat:@"%li", (long)avaliableColors];
        self.colorsStampCountLabel.font = [UIFont fontWithName:@"OpenSans" size:11];
        self.colorsStampView.hidden = NO;
    }
    else
    {
        self.colorsStampView.hidden = YES;
        self.colorsStampCountLabel.text = @"";
    }
}


- (void) updateProductStamp:(SearchProduct *)product {
    
    //Stamp
    self.promotionStamp.hidden = YES;
    if ((product.stampImage) && (![product.stampImage isEqualToString:@""]))
    {
        [self.promotionStamp sd_setImageWithURL:[NSURL URLWithString:product.stampImage]];
        self.promotionStamp.hidden = NO;
    }
}

- (void)updateProductInstallmentStamp:(NSArray *)paymentTypes andInstallmentAmount:(NSNumber *)installmentAmount {
    
    if ((paymentTypes.count == 1 || paymentTypes.count == 2) && [WBRCreditCardUtils isPaymentTypesEnableStamp:paymentTypes]){
        [self.installmentAmountStampView setHidden:NO];
        [self.installmentAmountStampLabel setText:[NSString stringWithFormat:@"%@x com", installmentAmount]];
    } else {
        [self.installmentAmountStampView setHidden:YES];
        [self.installmentAmountStampLabel setText:@""];
    }
}

- (void)updateHeartStatusHubConnection
{
    _productHubConnection.wishlist ? [_heartButton favoriteAnimated:NO] : [_heartButton unfavoriteAnimated:NO];
    if (_productHubConnection.isRefreshingWishlistStatus) {
        _productHubConnection.wishlist ? [_heartButton pulseFullHeart] : [_heartButton pulseEmptyHeart];
    }
    else {
        [_heartButton stopPulsing];
    }
}

- (void)updateHeartStatus
{
    _product.wishlist ? [_heartButton favoriteAnimated:NO] : [_heartButton unfavoriteAnimated:NO];
    if (_product.isRefreshingWishlistStatus) {
        _product.wishlist ? [_heartButton pulseFullHeart] : [_heartButton pulseEmptyHeart];
    }
    else {
        [_heartButton stopPulsing];
    }
}

- (void)formatPriceLabel:(NSNumber *)amount {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencySymbol:@"R$ "];
    [numberFormatter setMinimumFractionDigits:2];
    
    NSString *productPrice = [numberFormatter stringFromNumber:amount];
    
    NSString *fontName = @"Roboto-Bold";
    
    UIFont *currencyFont = [UIFont fontWithName:fontName size:13];
    UIFont *valueFont    = [UIFont fontWithName:fontName size:28];
    UIFont *centsFont    = [UIFont fontWithName:fontName size:18];
    
    NSMutableAttributedString *attributedPrice = [[NSMutableAttributedString alloc] initWithString:productPrice];
    [attributedPrice addAttribute:NSForegroundColorAttributeName value:RGBA(76, 175, 80, 1) range:NSMakeRange(0, productPrice.length)];
    
    NSRange fullRange = NSMakeRange(0, productPrice.length);
    NSRange currencyRange = NSMakeRange(0, 3);
    NSRange centsRange = NSMakeRange(productPrice.length - 3, 3);
    
    [attributedPrice addAttribute:NSFontAttributeName value:valueFont range:fullRange];
    [attributedPrice addAttribute:NSFontAttributeName value:currencyFont range:currencyRange];
    [attributedPrice addAttribute:NSFontAttributeName value:centsFont range:centsRange];
    _priceLabel.attributedText = attributedPrice;
}

- (void)formatPriceLabelForDiscountedPrice:(NSNumber *)amount andPaymentMethodString:(NSString *)paymentMethodString {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencySymbol:@"R$ "];
    [numberFormatter setMinimumFractionDigits:2];
    
    NSString *productPrice = [NSString stringWithFormat:@"%@%@", [numberFormatter stringFromNumber:amount], paymentMethodString];
    
    NSString *fontName = @"Roboto-Bold";
    
    UIFont *currencyFont      = [UIFont fontWithName:fontName size:13];
    UIFont *valueFont         = [UIFont fontWithName:fontName size:28];
    UIFont *centsFont         = [UIFont fontWithName:fontName size:18];
    UIFont *paymentMethodFont = [UIFont fontWithName:@"Roboto-Medium" size:13];
    
    NSMutableAttributedString *attributedPrice = [[NSMutableAttributedString alloc] initWithString:productPrice];
    [attributedPrice addAttribute:NSForegroundColorAttributeName value:RGBA(76, 175, 80, 1) range:NSMakeRange(0, productPrice.length)];
    
    NSRange fullRange = NSMakeRange(0, productPrice.length);
    NSRange currencyRange = NSMakeRange(0, 3);
    NSRange centsRange = NSMakeRange(productPrice.length - 3, 3);
    NSRange paymentMethodRange = [productPrice rangeOfString:paymentMethodString];
    
    [attributedPrice addAttribute:NSFontAttributeName value:valueFont range:fullRange];
    [attributedPrice addAttribute:NSFontAttributeName value:currencyFont range:currencyRange];
    [attributedPrice addAttribute:NSFontAttributeName value:centsFont range:centsRange];
    [attributedPrice addAttribute:NSFontAttributeName value:paymentMethodFont range:paymentMethodRange];
    _priceLabel.attributedText = attributedPrice;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    _overlayView.hidden = !highlighted;
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
}

#pragma mark - IBAction
- (IBAction)pressedHeartButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tappedHeartButtonInProductCell:)]) {
        [self.delegate tappedHeartButtonInProductCell:self];
    }
}


//Currency
- (NSString *) currencyFormatDouble:(double) value {
    NSNumber *amount = @(value);
    return [[[OFFormatter sharedInstance] currencyFormatter] stringFromNumber:amount];
}

@end
