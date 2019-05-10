//
//  WishlistCell.m
//  Walmart
//
//  Created by Bruno Delgado on 12/4/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WishlistCell.h"
#import "WishlistSellerOption.h"
#import "OFFormatter.h"
#import "NSString+Additions.h"
#import "NSString+HTML.h"
#import "User.h"

#import "WBRCompleteRatingView.h"
#import "WBRProductManager.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface WishlistCell ()

@property (nonatomic, weak) IBOutlet UIImageView *selectedIndicatorImageView;
@property (nonatomic, weak) IBOutlet UIImageView *productImageView;
@property (nonatomic, weak) IBOutlet UILabel *addedDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *productNameLabel;

@property (nonatomic, weak) IBOutlet UIView *lowerPriceView;
@property (nonatomic, weak) IBOutlet UILabel *lowerPriceLabel;

@property (nonatomic, weak) IBOutlet UIView *priceView;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *installmentsLabel;

@property (nonatomic, weak) IBOutlet UILabel *selllerLabel;
@property (nonatomic, weak) IBOutlet WMButtonRounded *addToCartButton;
@property (nonatomic, weak) IBOutlet UIButton *optionsToBuyButton;

@property (nonatomic, weak) IBOutlet UIView *customBackgroundView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;

@property (nonatomic, weak) IBOutlet UIView *unavailableView;
@property (nonatomic, weak) IBOutlet UILabel *unavailableMessageLabel;
@property (nonatomic, weak) IBOutlet WMButtonRounded *warnMeButton;
@property (nonatomic, weak) IBOutlet UILabel *warnMeSuccessTitle;
@property (nonatomic, weak) IBOutlet UILabel *warnMeSuccessSubtitle;
@property (nonatomic, weak) IBOutlet UIImageView *warnMeSuccessIcon;

@property (nonatomic, strong) OFFormatter *formatter;
@property (nonatomic, strong) WishlistProduct *wishlistProduct;
@property (nonatomic, strong) UIView *sellerTapView;

@property (nonatomic, assign) CGFloat productNameLabelMaxWidth;
@property (nonatomic, assign) CGFloat productNameLabelMaxHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customBackgroundViewHeight;
@property (weak, nonatomic) IBOutlet UIView *optionsToByView;
@property (nonatomic, strong) IBOutlet UIButton *btSelect;
@property (weak, nonatomic) IBOutlet WBRCompleteRatingView *ratingView;

@end

@implementation WishlistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.formatter = [OFFormatter sharedInstance];
    self.contentView.clipsToBounds = YES;
    self.clipsToBounds = YES;
    
    self.productNameLabelMaxWidth = self.productNameLabel.frame.size.width;
    self.productNameLabelMaxHeight = self.productNameLabel.frame.size.height;
    
    _customBackgroundView.layer.masksToBounds = NO;
    _customBackgroundView.layer.shadowColor = RGBA(204, 204, 204, 1).CGColor;
    _customBackgroundView.layer.shadowOpacity = 0.5;
    _customBackgroundView.layer.shadowOffset = CGSizeMake(0, 2);
    _customBackgroundView.layer.shadowRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [_btSelect setImage:[UIImage imageNamed:selected ? @"ic_fav_selected" : @"ic_fav_selector"] forState:UIControlStateNormal];
}

- (CGFloat)heightForProduct:(WishlistProduct *)product
{
    CGFloat topAreaHeight = 115;
    CGFloat distance = 12   ;
    CGFloat lowerPriceViewHeight = 43;
    CGFloat priceViewHeight = 48;
    CGFloat addToCartButtonHeight = 44;
    CGFloat moreOptionsViewHeight = 41;
    CGFloat unavailableViewHeight = 114;
    
    if (product.sellerOptions.count > 0)
    {
        if (product.quantity <= 0)
        {
            return topAreaHeight + distance + unavailableViewHeight + distance;
        }
        else
        {
            WishlistSellerOption *productOption = product.sellerOptions[0];
            CGFloat height = 0;
            height += topAreaHeight;
            height += distance;
            
            if (product.statusPrice.integerValue == WishlistProductStatusPriceLow)
            {
                height += lowerPriceViewHeight;
                height += 16;
            }
            
            height += priceViewHeight;
            height += 8;
            
            if (productOption.seller.length > 0)
            {
                NSString *sellerNameStr = [NSString stringWithFormat:SELLER_SOLD_AND_DELIVERED_BY_FORMAT, productOption.seller];
                CGSize sellerLabelSize = [sellerNameStr sizeForTextWithFont:_selllerLabel.font constrainedToSize:CGSizeMake(_selllerLabel.frame.size.width, CGFLOAT_MAX)];
                height += sellerLabelSize.height;
                height += 16;
            }
            
            height += addToCartButtonHeight;
            height += 23.0f;
            
            if (product.sellerOptions.count > 1) {
                height += moreOptionsViewHeight;
            }
            
            height += distance;
            return height;
        }
    }
    else
    {
        LogInfo(@"height esgotado: %f",topAreaHeight + distance + unavailableViewHeight + distance);
        return topAreaHeight + distance + unavailableViewHeight + distance;
    }
}

- (void)setupWithProduct:(WishlistProduct *)product baseImagePath:(NSString *)baseImagePath {
    _lowerPriceView.hidden = YES;
    _priceView.hidden = NO;
    _selllerLabel.hidden = NO;
    _addToCartButton.hidden = NO;
    _optionsToByView.hidden = YES;
    _unavailableView.hidden = YES;
    _sellerTapView.hidden = YES;
    
    self.wishlistProduct = product;
    
    _customBackgroundView.layer.cornerRadius = 2.0f;
    
    CGFloat topAreaHeight = 115;
    CGFloat distance = 13;
    CGFloat unavailableViewHeight = 114;
    
    WishlistSellerOption *productOption = product.sellerOptions[0];
    //Product Name
    _productNameLabel.text = productOption.name.length > 0 ? [productOption.name kv_decodeHTMLCharacterEntities] : @"";
    
    CGSize productNameSize = [_productNameLabel.text sizeForTextWithFont:_productNameLabel.font constrainedToSize:CGSizeMake(_productNameLabelMaxWidth, CGFLOAT_MAX)];
    CGRect productNameFrame = _productNameLabel.frame;
    productNameFrame.size.height = (productNameSize.height > _productNameLabelMaxHeight) ? _productNameLabelMaxHeight : round(productNameSize.height);
    _productNameLabel.frame = productNameFrame;
    
    if (_productNameLabel.gestureRecognizers.count == 0) {
        UITapGestureRecognizer *productTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProductName)];
        _productNameLabel.userInteractionEnabled = YES;
        [_productNameLabel addGestureRecognizer:productTapGesture];
    }
    
    //Image
    NSString *imageId = productOption.imageIds.count > 0 ? productOption.imageIds[0] : @"";
    NSString *imagePath = [NSString stringWithFormat:@"%@%@",baseImagePath,imageId];
    
    [_indicator startAnimating];
    
    [_productImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self->_productImageView.contentMode = UIViewContentModeScaleAspectFit;
        } else {
            self->_productImageView.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME_2];
        }
        [self->_indicator stopAnimating];
    }];
    
    //Date added
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    _addedDateLabel.text = [NSString stringWithFormat:@"Adicionado em %@", [dateFormatter stringFromDate:product.date]];
    
    CGFloat position = 0.0f;
    position += topAreaHeight;
    position += distance;
    
    // setup rating
    LogInfo(@"Product Name: %@, rating: %@, total: %@", product.defaultName, productOption.rating.ratingValue, productOption.rating.totalOfRatings);
    [self setupRatingViewWithRating:productOption.rating];
    
    if (!product.sellerOptions || product.quantity <= 0) {
        [self setEmptyProduct];
        
        CGFloat position = 0.0f;
        position += topAreaHeight;
        position += distance;
        position += unavailableViewHeight;
        
        _customBackgroundViewHeight.constant = position;
        
        LogInfo(@"size sem conteudo: %f", position);
        
        return;
    }
    
    if (product.statusPrice.integerValue == WishlistProductStatusPriceLow)
    {
        //Discount
        [self setupDiscountForProduct:product];
        
        _lowerPriceView.hidden = NO;
        CGRect lowerPriceFrame = _lowerPriceView.frame;
        lowerPriceFrame.origin.y = position;
        _lowerPriceView.frame = lowerPriceFrame;
        
        position += _lowerPriceView.frame.size.height;
        LogInfo(@"low price height: %f", _lowerPriceView.frame.size.height);
        position += 16;
    }
    
    //Price
    [self setupPriceForProductOption:productOption];
    
    CGRect priceFrame = _priceView.frame;
    priceFrame.origin.y = position;
    _priceView.frame = priceFrame;
    
    position += _priceView.frame.size.height;
    LogInfo(@"price height: %f", _priceView.frame.size.height);
    position += 8;
    
    NSString *sellerNameStr = [NSString stringWithFormat:SELLER_SOLD_AND_DELIVERED_BY_FORMAT, productOption.seller ?: @""];
    CGSize sellerLabelSize = [sellerNameStr sizeForTextWithFont:_selllerLabel.font constrainedToSize:CGSizeMake(_selllerLabel.frame.size.width, CGFLOAT_MAX)];
    
    CGRect sellerFrame = _selllerLabel.frame;
    sellerFrame.origin.y = position;
    sellerFrame.size.height = sellerLabelSize.height;
    _selllerLabel.frame = sellerFrame;
    [self setupSellerForProductOption:productOption];
    
    position += _selllerLabel.frame.size.height;
    LogInfo(@"seller label: %f", _selllerLabel.frame.size.height);
    position += 15  ;
    
    CGRect addToCartFrame = _addToCartButton.frame;
    addToCartFrame.origin.y = position;
    _addToCartButton.frame = addToCartFrame;
    
    position += _addToCartButton.frame.size.height;
    LogInfo(@"add to cart button height: %f", _addToCartButton.frame.size.height);
    
    
    if (product.sellerOptions.count > 1)
    {
        //Options
        [self showSellerOptions:product.sellerOptions.count];
        
        position += 23;
        _optionsToByView.hidden = NO;
        CGRect optionsViewFrame = _optionsToByView.frame;
        optionsViewFrame.origin.y = position;
        _optionsToByView.frame = optionsViewFrame;
        
        position += _optionsToByView.frame.size.height;
        LogInfo(@"more option height: %f", _optionsToByView.frame.size.height);
        
        position += 23;
        
    }else{
        position += 24;
    }
    
    LogInfo(@">>> size: %f", position);
    _customBackgroundViewHeight.constant = position;
    
}

#pragma mark - Discount
- (void)setupDiscountForProduct:(WishlistProduct *)product
{
    if (product.statusPrice.integerValue == WishlistProductStatusPriceLow)
    {
        if (product.skuPrice)
        {
            _lowerPriceView.hidden = NO;
            NSString *discountPrice = [_formatter.currencyFormatter stringFromNumber:product.skuPrice];
            _lowerPriceLabel.text = discountPrice.length > 0 ? [NSString stringWithFormat:WISHLIST_DISCOUNT_MESSAGE,discountPrice] : @"";
            return;
        }
    }
    
    _lowerPriceView.hidden = YES;
    _lowerPriceLabel.text = @"";
}

#pragma mark - Price
- (void)setupPriceForProductOption:(WishlistSellerOption *)productOption
{
    NSString *productPrice = productOption.discountPrice ? [_formatter.currencyFormatter stringFromNumber:productOption.discountPrice] : @"";
    NSInteger productInstallmentsNumber = productOption.instalment ? productOption.instalment.integerValue : 1;
    NSString *productInstallment = [_formatter.currencyFormatter stringFromNumber:productOption.instalmentValue];
    
    NSString *productDiscountedPrice = ([OFSetup enableBankSlipDiscount] && productOption.paymentSuggestion.discountedPrice) ? [_formatter.currencyFormatter stringFromNumber:productOption.paymentSuggestion.discountedPrice] : @"";
    if (productDiscountedPrice.length > 0) {
        UIColor *numberColor = RGB(102,102,102);
        UIColor *textColor = RGB(153,153,153);
        
        NSString *fullPriceAndInstallmentString = [NSString stringWithFormat:@"ou %@ em %ldx", productDiscountedPrice, (long)productInstallmentsNumber];
        NSMutableAttributedString *fullPriceAndInstallmentAttributedString = [[NSMutableAttributedString alloc] initWithString:fullPriceAndInstallmentString
                                                                                                                    attributes:@{
                                                                                                                                 NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular" size:13],
                                                                                                                                 NSUnderlineStyleAttributeName : @0 ,
                                                                                                                                 NSForegroundColorAttributeName : numberColor
                                                                                                                                 }];
        NSRange orRange = [fullPriceAndInstallmentString rangeOfString:@"ou"];
        NSRange inRange = [fullPriceAndInstallmentString rangeOfString:@"em"];
        NSRange interestRange = [fullPriceAndInstallmentString rangeOfString:@""];
        
        [fullPriceAndInstallmentAttributedString addAttribute:NSForegroundColorAttributeName value:textColor range:orRange];
        [fullPriceAndInstallmentAttributedString addAttribute:NSForegroundColorAttributeName value:textColor range:inRange];
        [fullPriceAndInstallmentAttributedString addAttribute:NSForegroundColorAttributeName value:textColor range:interestRange];
        
        _installmentsLabel.attributedText = fullPriceAndInstallmentAttributedString;
    }
    else if (productInstallment.length > 0) {
        UIColor *installmentDefaultColor = RGB(153,153,153);
        
        NSAttributedString *installmentValue = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ldx de ", (long)productInstallmentsNumber] attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular" size:13], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : installmentDefaultColor}];
        
        NSAttributedString *intallmentPrice = [[NSAttributedString alloc] initWithString:productInstallment attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular" size:13], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : RGB(102,102,102)}];
        
        NSAttributedString *interestFree = [[NSAttributedString alloc] initWithString:@"" attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular" size:13], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : installmentDefaultColor}];
        NSMutableAttributedString *installmentMutableAttString = [[NSMutableAttributedString alloc] init];
        
        [installmentMutableAttString appendAttributedString:installmentValue];
        [installmentMutableAttString appendAttributedString:intallmentPrice];
        [installmentMutableAttString appendAttributedString:interestFree];
        
        _installmentsLabel.attributedText = installmentMutableAttString;
    }
    
    if (productOption.paymentSuggestion && productOption.paymentSuggestion.discountedPrice && [productOption.paymentSuggestion isBankSlip] && [OFSetup enableBankSlipDiscount]) {
        
        NSString *productPrice = productOption.paymentSuggestion.discountedPrice ? [_formatter.currencyFormatter stringFromNumber:productOption.paymentSuggestion.discountedPrice] : @"";

        UIFont *currencyFont = [UIFont fontWithName:@"Roboto-Bold" size:13];
        UIFont *valueFont = [UIFont fontWithName:@"Roboto-Bold" size:28];
        UIFont *centsFont = [UIFont fontWithName:@"Roboto-Bold" size:18];
        UIFont *paymentMethodFont = [UIFont fontWithName:@"Roboto-Medium" size:13];
        
        //TODO: Criar um Helper de paymentMethodStringForKey: productOption.paymentSuggestion.paymentMethod
        NSString *paymentMethod = productOption.paymentSuggestion.paymentMethodString;
        NSString *discountProductPrice = [NSString stringWithFormat:@"%@%@", productPrice, paymentMethod];
        NSMutableAttributedString *attributedPrice = [[NSMutableAttributedString alloc] initWithString:discountProductPrice];
        
        NSRange fullRange = NSMakeRange(0, productPrice.length);
        NSRange currencyRange = NSMakeRange(0, 3);
        NSRange centsRange = NSMakeRange(productPrice.length - 3, 3);
        NSRange paymentMethodRange = [discountProductPrice rangeOfString:paymentMethod];
        
        [attributedPrice addAttribute:NSFontAttributeName value:valueFont range:fullRange];
        [attributedPrice addAttribute:NSFontAttributeName value:currencyFont range:currencyRange];
        [attributedPrice addAttribute:NSFontAttributeName value:centsFont range:centsRange];
        [attributedPrice addAttribute:NSFontAttributeName value:paymentMethodFont range:paymentMethodRange];
        
        _priceLabel.attributedText = attributedPrice;
    }
    else if (productPrice.length > 0) {
        
        UIFont *currencyFont = [UIFont fontWithName:@"Roboto-Bold" size:13];
        UIFont *valueFont = [UIFont fontWithName:@"Roboto-Bold" size:28];
        UIFont *centsFont = [UIFont fontWithName:@"Roboto-Bold" size:18];
        
        NSMutableAttributedString *attributedPrice = [[NSMutableAttributedString alloc] initWithString:productPrice];
        
        NSRange fullRange = NSMakeRange(0, productPrice.length);
        NSRange currencyRange = NSMakeRange(0, 3);
        NSRange centsRange = NSMakeRange(productPrice.length - 3, 3);
        
        [attributedPrice addAttribute:NSFontAttributeName value:valueFont range:fullRange];
        [attributedPrice addAttribute:NSFontAttributeName value:currencyFont range:currencyRange];
        [attributedPrice addAttribute:NSFontAttributeName value:centsFont range:centsRange];
        _priceLabel.attributedText = attributedPrice;
    }
}

#pragma mark - Seller
- (void)setupSellerForProductOption:(WishlistSellerOption *)productOption
{
    if (productOption.seller.length > 0)
    {
        NSString *sellerNameStr = [NSString stringWithFormat:SELLER_SOLD_AND_DELIVERED_BY_FORMAT, productOption.seller];
        NSMutableAttributedString *attributedSellerName = [[NSMutableAttributedString alloc] initWithString:sellerNameStr];
        [attributedSellerName addAttribute:NSForegroundColorAttributeName value:RGBA(33, 150, 243, 1) range:[sellerNameStr rangeOfString:productOption.seller]];
        _selllerLabel.attributedText = attributedSellerName.copy;
        
        if (!_sellerTapView)
        {
            self.sellerTapView = [[UIView alloc] initWithFrame:_selllerLabel.frame];
            _sellerTapView.backgroundColor = [UIColor clearColor];
            [self addSubview:_sellerTapView];
            
            UITapGestureRecognizer *sellerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSellerName)];
            [_sellerTapView addGestureRecognizer:sellerTapGesture];
        }
        
        _sellerTapView.hidden = NO;
        return;
    }
    
    _selllerLabel.text = @"";
}

#pragma mark - Options
- (void)showSellerOptions:(NSInteger)quantity
{
    NSInteger otherSellers = quantity - 1;
    NSString *buttonTitle;
    
    if (otherSellers == 1) {
        buttonTitle = [NSString stringWithFormat:@"Outra loja no Walmart (%ld)", (long)otherSellers];
    } else {
        buttonTitle = [NSString stringWithFormat:@"Outras lojas no Walmart (%ld)", (long)otherSellers];
    }
    [_optionsToBuyButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (IBAction)moreOptionsToBuyPressed:(id)sender
{
    [self tapMoreOptionsToBuyForProductId:_wishlistProduct.productId];
}

- (IBAction)addToCartPressed:(id)sender
{
    [self addProductToCart];
}

#pragma mark - Empty product
- (void)setEmptyProduct
{
    _lowerPriceView.hidden = YES;
    _priceView.hidden = YES;
    _selllerLabel.hidden = YES;
    _addToCartButton.hidden = YES;
    _optionsToByView.hidden = YES;
    _unavailableView.hidden = NO;
}

- (IBAction)tapWarnMe:(id)sender
{
    _unavailableView.userInteractionEnabled = NO;
    _warnMeSuccessIcon.transform = CGAffineTransformIdentity;
    _warnMeSuccessIcon.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    _warnMeSuccessIcon.alpha = 1;
    
    _warnMeSuccessIcon.frame = CGRectMake((_unavailableView.frame.size.width - _warnMeSuccessIcon.frame.size.width)/2, _warnMeSuccessIcon.frame.origin.y, _warnMeSuccessIcon.frame.size.width, _warnMeSuccessIcon.frame.size.height);
    
    [self warnMeAction];
    
    [UIView animateWithDuration:.15 animations:^{
        self->_unavailableMessageLabel.alpha = 0;
        self->_warnMeButton.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self->_warnMeSuccessTitle.alpha = 1;
            self->_warnMeSuccessSubtitle.alpha = 1;
        }];
        
        [UIView animateWithDuration:.2 animations:^{
            self->_warnMeSuccessIcon.transform = CGAffineTransformMakeScale(1.15f, 1.15f);
        } completion:^(BOOL finished) {
            self->_unavailableView.userInteractionEnabled = YES;
            [UIView animateWithDuration:.1 animations:^{
                self->_warnMeSuccessIcon.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

- (void)warnMeAction
{
    WishlistSellerOption *product = _wishlistProduct.sellerOptions[0];
    
    User *user = [User sharedUser];
    NSString *name = user.firstName.length > 0 ? user.firstName : @"";
    NSString *email = user.email.length > 0 ? user.email : @"";
    NSString *sku = product.sku ? product.sku.stringValue : @"";
    
    [WBRProductManager notifyUser:name withEmail:email forProductSku:sku successBlock:^(BOOL success) {
    
        if (success) {
            [WMOmniture trackWarnMeFromWishlistForSellerId:self->_wishlistProduct.sellerId SKU:self->_wishlistProduct.skuId ? self->_wishlistProduct.skuId.stringValue : @""];
        }
    }];
}

#pragma mark - Delegate
- (void)tapSellerName {
    WishlistSellerOption *product = _wishlistProduct.sellerOptions[0];
    if (_delegate && [_delegate respondsToSelector:@selector(didTapSellerName:)]) {
        [_delegate didTapSellerName:product.sellerId];
    }
}

- (void)tapProductName {
    [self tapMoreOptionsToBuyForProductId:_wishlistProduct.productId];
}

- (void)tapMoreOptionsToBuyForProductId:(NSNumber *)productId {
    if (_delegate && [_delegate respondsToSelector:@selector(didTapWishlistProduct:)]) {
        [_delegate didTapWishlistProduct:productId.stringValue];
    }
}

- (void)addProductToCart {    
    if (_delegate && [_delegate respondsToSelector:@selector(didTapAddToCart:)]) {
        [_delegate didTapAddToCart:_wishlistProduct];
        
        //Facebook Analytics
        float value = _wishlistProduct.discountPrice.floatValue;
        LogInfo(@"[FACE] logAddedToCartEvent (wishlist) - Sku: %@ | Value: %f", _wishlistProduct.skuId.stringValue, (double) value);
        
        [self logAddedToCartEvent:_wishlistProduct.skuId.stringValue contentType:@"product" currency:@"BRL" valToSum:(double) value];
    }
}

#pragma mark - Facebook Analytics

- (void)logAddedToCartEvent:(NSString*)contentId
                contentType:(NSString*)contentType
                   currency:(NSString*)currency
                  valToSum :(double)price {
    NSDictionary *params =
    [[NSDictionary alloc] initWithObjectsAndKeys:
     contentId, FBSDKAppEventParameterNameContentID,
     contentType, FBSDKAppEventParameterNameContentType,
     currency, FBSDKAppEventParameterNameCurrency,
     nil];
    [FBSDKAppEvents logEvent: FBSDKAppEventNameAddedToCart
                  valueToSum: price
                  parameters: params];
}

#pragma mark - Load nib
+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
}

#pragma mark - Select Product
- (IBAction)tappedSelectButton:(id)sender {
    [self setSelected:!self.selected animated:YES];
    
    if (self.selected) {
        if (_delegate && [_delegate respondsToSelector:@selector(wishlistCellDidSelectProduct:)]) {
            [_delegate wishlistCellDidSelectProduct:_wishlistProduct];
        }
    }
    else {
        if (_delegate && [_delegate respondsToSelector:@selector(wishlistCellDidDeselectProduct:)]) {
            [_delegate wishlistCellDidDeselectProduct:_wishlistProduct];
        }
    }
}

- (void)setupRatingViewWithRating:(WBRRatingModel *)rating {
    
    if (rating.totalOfRatings && rating) {
        self.ratingView.onlyRatingScore = YES;
        self.ratingView.hidden = NO;
        self.ratingView.rating = rating;
    }
    else {
        self.ratingView.hidden = YES;
    }
    
}

@end
