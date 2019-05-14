//
//  HomeProductCollectionViewCell.m
//  Walmart
//
//  Created by Renan Cargnin on 7/23/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "HomeProductCollectionViewCell.h"

#import "ShowcaseProductModel.h"

#import "OFSetupCustomCheckout.h"
#import "OFColors.h"
#import "OFFormatter.h"
#import "WishlistConnection.h"

#import "NSString+HTML.h"
#import "UIImageView+WebCache.h"

#import "WMHeartButton.h"
#import "ProductTotalColorsView.h"

#import "WALFavoritesCache.h"

#import "WBRSetupManager.h"

#import "WBRCompleteRatingView.h"
#import "WBRCreditCardUtils.h"

#import "WBRInstallCampaign.h"

@interface HomeProductCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actInd;

@property (weak, nonatomic) IBOutlet UIImageView *imgStamp;
@property (weak, nonatomic) IBOutlet ProductTotalColorsView *colorsView;

@property (weak, nonatomic) IBOutlet UIImageView *installCampaignStamp;

@property (weak, nonatomic) IBOutlet UIView *installmentAmountStamp;
@property (weak, nonatomic) IBOutlet UILabel *installmentAmountStampLabel;

@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;

@property (weak, nonatomic) IBOutlet UILabel *lblDiscountPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblInstallments;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblBankingSlipLabel;

@property (weak, nonatomic) IBOutlet UIView *overlayView;

@property (strong, nonatomic) NSDictionary *dictProduct;
@property (strong, nonatomic) NSNumberFormatter *formatter;

@property (weak, nonatomic) IBOutlet WMHeartButton *heartButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *colorsViewTopAlignmentConstraint;

@property (strong, nonatomic) ShowcaseProductModel *product;

@property (weak, nonatomic) IBOutlet WBRCompleteRatingView *completeRating;

@end

@implementation HomeProductCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    _overlayView.layer.masksToBounds = NO;
    _overlayView.layer.shadowColor = RGBA(204, 204, 204, 1).CGColor;
    _overlayView.layer.shadowOpacity = 0.5;
    _overlayView.layer.shadowOffset = CGSizeMake(0, 1);
    _overlayView.layer.shadowRadius = 4;
    
    _overlayView.layer.cornerRadius = 2;
    
    _lblDiscount.layer.borderWidth = 1.0f;
    _lblDiscount.layer.borderColor = RGBA(211, 135, 1, 1).CGColor;
    _lblDiscount.layer.cornerRadius = 2.0f;
}

- (void)setupWithProduct:(ShowcaseProductModel *)product delegate:(id<HomeProductCollectionViewCellDelegate>)delegate {
    self.delegate = delegate;
    self.heartButton.hidden = ![OFSetup canAddProductsToTheWishlistOutsideProductDetail];
   
    [self setupCardBrandStamp:product];
    
    if (product.stampImage.length > 0) {
        [_imgStamp sd_setImageWithURL:[NSURL URLWithString:product.stampImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                self->_imgStamp.contentMode = UIViewContentModeScaleAspectFit;
            }
        }];
        _colorsViewTopAlignmentConstraint.constant = 64.0f;
    }
    else {
        [_imgStamp setImage:nil];
        _colorsViewTopAlignmentConstraint.constant = 0.0f;
    }
    
    if ([OFSetup enableShowcaseColorsCount]) {
        NSInteger totalColors = product.totalColors.integerValue;
        _colorsView.totalColors = totalColors;
        _colorsView.hidden = totalColors <= 1;
    }
    
    _lblTitle.text = [product.title kv_decodeHTMLCharacterEntities];

    [_actInd startAnimating];
    
    _imgProduct.image = nil;
    
    __weak HomeProductCollectionViewCell *weakSelf = self;
    [WBRSetupManager getBaseImages:^(ModelBaseImages *baseImagesModel) {
        
        NSString *pathImgShowcase = [NSString stringWithFormat:@"%@%@", baseImagesModel.products, product.imageId] ?: @"";
        pathImgShowcase = [pathImgShowcase stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [weakSelf.imgProduct sd_setImageWithURL:[NSURL URLWithString:pathImgShowcase] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                weakSelf.imgProduct.contentMode = UIViewContentModeScaleAspectFit;
            }
            else {
                weakSelf.imgProduct.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME_2];
            }
            [weakSelf.actInd stopAnimating];
        }];
    } failure:^(NSDictionary *dictError) {
        
        weakSelf.imgProduct.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME_2];
        [weakSelf.actInd stopAnimating];
    }];
    
    
    
    if (product.hasMoreOffers.boolValue || product.hasSkuOptions.boolValue) {
        _lblPriceDetail.text = PRODUCT_PRICE_START;
    }
    else {
        //Verify if price is different discountPrice
        
        double listPrice = product.price.listPrice.doubleValue;
        double sellPrice = product.price.sellPrice.doubleValue;
        
        if (!listPrice) {
            _lblPriceDetail.text = @"Por apenas";
        }
        else if (listPrice > sellPrice) {
            
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[self currencyFormatDouble:listPrice]];
            
            [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                    value:@1
                                    range:NSMakeRange(0, [attributeString length])];
            
            _lblPriceDetail.attributedText = attributeString;
        }
        else {
            _lblPriceDetail.text = @"";
        }
    }
    
    [self formatPriceLabel:[NSNumber numberWithDouble:product.price.sellPrice.doubleValue]];
    
    NSString *instalmentValue = [self currencyFormatDouble:product.instalmentValue.doubleValue];
    
    if ([instalmentValue isEqualToString:@"R$ 0.00"] || !instalmentValue) {
        instalmentValue = [self currencyFormatDouble:product.price.sellPrice.doubleValue];
    }
    
    NSString *instalment = product.instalment.stringValue;
    
    if (!instalment) {
        
        _lblPriceDetail.text = PRODUCT_PRICE_START;
        _lblInstallments.text = @"";
    }
    else if ([instalment isEqualToString:@"1"]) {
        _lblInstallments.text = @"";
    }
    else {
        UIColor *installmentDefaultColor = RGB(153, 153, 153);
        NSString *fontName = @"Roboto-Regular";
        int fontSize = 13;
       
        NSAttributedString *installmentValue = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ldx de ", (long)product.instalment.integerValue] attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : installmentDefaultColor}];
        
        NSAttributedString *intallmentPrice = [[NSAttributedString alloc] initWithString:instalmentValue attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size: fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : RGB(102,102,102)}];
        
        NSAttributedString *interestFree = [[NSAttributedString alloc] initWithString:@" sem juros" attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : installmentDefaultColor}];
        
        NSMutableAttributedString *installmentMutableAttString = [[NSMutableAttributedString alloc] init];
        
        [installmentMutableAttString appendAttributedString:installmentValue];
        [installmentMutableAttString appendAttributedString:intallmentPrice];
        [installmentMutableAttString appendAttributedString:interestFree];
        
        _lblInstallments.attributedText = installmentMutableAttString;
    }
    
    [self setupForPaymentSuggestion:product];
    
    self.product = product;
    [self updateHeartStatus];
    
    [self setupRatingViewWithRating:product.rating];
}

- (void)setupForPaymentSuggestion:(ShowcaseProductModel *)product {
    
    if (product.paymentSuggestion && product.paymentSuggestion.discountedPrice && [product.paymentSuggestion isBankSlip] && [OFSetup enableBankSlipDiscount]) {
        
        self.lblBankingSlipLabel.hidden = NO;
        self.lblBankingSlipLabel.text = product.paymentSuggestion.paymentMethodString;
        
        [self formatPriceLabel:[NSNumber numberWithDouble:product.paymentSuggestion.discountedPrice.doubleValue]];
        
        UIColor *installmentDefaultColor = RGB(153, 153, 153);
        NSString *fontName = @"Roboto-Regular";
        int fontSize = 13;
        
        NSAttributedString *orString = [[NSAttributedString alloc] initWithString:@"ou " attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : installmentDefaultColor}];
        
        NSString *totalPrice = [self currencyFormatDouble:[product.price.listPrice doubleValue]];
        NSAttributedString *totalPriceAttributedString = [[NSAttributedString alloc] initWithString:totalPrice attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size: fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : RGB(102,102,102)}];
        
        NSAttributedString *inString = [[NSAttributedString alloc] initWithString:@" em " attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : installmentDefaultColor}];
        
        NSAttributedString *installmentValue = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ldx ", (long)product.instalment.integerValue] attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : RGB(102,102,102)}];
        
        NSAttributedString *interestFree = [[NSAttributedString alloc] initWithString:@"sem juros" attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : installmentDefaultColor}];
        
        NSMutableAttributedString *installmentMutableAttString = [[NSMutableAttributedString alloc] init];
        
        [installmentMutableAttString appendAttributedString:orString];
        [installmentMutableAttString appendAttributedString:totalPriceAttributedString];
        [installmentMutableAttString appendAttributedString:inString];
        [installmentMutableAttString appendAttributedString:installmentValue];
        [installmentMutableAttString appendAttributedString:interestFree];
        
        self.lblInstallments.attributedText = installmentMutableAttString;
    }
    else {
        self.lblBankingSlipLabel.hidden = YES;
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

- (void) getImage:(NSString *) imgUrl {
    NSString *imgURLWithSuffix = [NSString stringWithFormat:@"%@-200-200", imgUrl];
    [_imgProduct sd_setImageWithURL:[NSURL URLWithString:imgURLWithSuffix] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self->_imgProduct.contentMode = UIViewContentModeScaleAspectFit;
        } else {
            self->_imgProduct.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME_2];
        }
        [self->_actInd stopAnimating];
    }];
}

//Currency
- (NSString *) currencyFormatDouble:(double) value {
    NSNumber *amount = @(value);
    return [[[OFFormatter sharedInstance] currencyFormatter] stringFromNumber:amount];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
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
    _lblDiscountPrice.attributedText = attributedPrice;
}

- (void)setupRatingViewWithRating:(WBRRatingModel *)rating {
    _completeRating.onlyRatingScore = YES;
    
    if (rating.totalOfRatings && rating) {
        _completeRating.hidden = NO;
        _completeRating.rating = rating;
    } else {
        _completeRating.hidden = YES;
    }
}

#pragma mark - Helper
- (void)setupCardBrandStamp:(ShowcaseProductModel *)product {
    BOOL isInstallCampaignEnabled = [WALMenuViewController singleton].services.installCampaign.boolValue;
    BOOL isStampCampaignEnabled = [WALMenuViewController singleton].services.masterCampaign.boolValue;

    if (isInstallCampaignEnabled){
        __weak HomeProductCollectionViewCell *weakSelf = self;
        [WBRSetupManager getInstallCampaign:^(WBRInstallCampaign *installCampaignModel) {
            if ((installCampaignModel) && (product.price.sellPrice.doubleValue > installCampaignModel.minValue.doubleValue)) {
                [weakSelf.installCampaignStamp sd_setImageWithURL:[NSURL URLWithString:installCampaignModel.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [weakSelf.installCampaignStamp setHidden:NO];
                }];
            } else {
                [weakSelf.installCampaignStamp setHidden:YES];
            }
        } failure:^(NSDictionary *dictError) {
            [weakSelf.installCampaignStamp setHidden:YES];
        }];
    } else if (isStampCampaignEnabled) {
        if ((product.paymentTypes.count == 1 || product.paymentTypes.count == 2) && [WBRCreditCardUtils isPaymentTypesEnableStamp:product.paymentTypes]){
            [self.installmentAmountStampLabel setText:[NSString stringWithFormat:@"%@x com", product.instalment]];
            [self.installmentAmountStamp setHidden:NO];
        } else {
            [self.installmentAmountStampLabel setText:@""];
            [self.installmentAmountStamp setHidden:YES];
        }
    } else {
        [self.installmentAmountStampLabel setText:@""];
        [self.installmentAmountStamp setHidden:YES];
    }
}

#pragma mark - IBAction
- (IBAction)pressedHeartButton {
    //We need to create this pointer because of the cell's reuse property.
    if (_delegate && [_delegate respondsToSelector:@selector(homeProductCellTappedHeartButton:)]) {
        [_delegate homeProductCellTappedHeartButton:self];
    }
}

@end
