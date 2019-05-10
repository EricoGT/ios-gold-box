//
//  ProductCustomView.m
//  Walmart
//
//  Created by Bruno Delgado on 5/6/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ProductCustomView.h"
#import "NSString+HTML.h"
#import "UIImageView+WebCache.h"
#import "NSString+Additions.h"
#import "Kit.h"
#import "OFFormatter.h"

@interface ProductCustomView ()

@property (nonatomic, weak) IBOutlet UIView *productView;
@property (nonatomic, weak) IBOutlet UIView *invoiceView;
@property (nonatomic, weak) IBOutlet UIView *dividerView;

@property (nonatomic, weak) IBOutlet UILabel *productDescriptionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *productPicture;
@property (nonatomic, weak) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *optionalDescriptionLabel;

@end

@implementation ProductCustomView

- (void)setupWithDeliveryItem:(TrackingDeliveryDetailItem *)detail kits:(NSArray *)kits
{
    self.unitPriceTitleLabel.hidden = YES;
    self.unitPriceLabel.hidden = YES;
    self.totalPriceLabel.hidden = YES;
    self.totalTitleLabel.hidden = YES;
    self.optionalDescriptionLabel.hidden = YES;
    //
    // ---------------- PRODUCT ----------------
    //
    CGFloat total = 0;
    [self.productPicture sd_setImageWithURL:[NSURL URLWithString:detail.urlImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            self.productPicture.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME];
        }
    }];
    
    NSString *cleanedDescription = [detail.itemDescription kv_decodeHTMLCharacterEntities];
    self.productDescriptionLabel.text = cleanedDescription;
    CGSize newDescriptionSize = [cleanedDescription sizeForTextWithFont:self.productDescriptionLabel.font
                                                                     constrainedToSize:CGSizeMake(self.productDescriptionLabel.frame.size.width, CGFLOAT_MAX)];
    CGFloat defaultDescriptionSize = self.productDescriptionLabel.frame.size.height;
    
    CGRect invoiceFrame = self.invoiceView.frame;
    if (newDescriptionSize.height > defaultDescriptionSize)
    {
        CGRect newProductViewFrame = self.productView.frame;
        CGRect newDescriptionFrame = self.productDescriptionLabel.frame;
        
        newDescriptionFrame.size.height = newDescriptionSize.height;
        newProductViewFrame.size.height = (self.productDescriptionLabel.frame.origin.y + newDescriptionSize.height);
        self.productView.frame = newProductViewFrame;
        invoiceFrame.origin.y = self.productView.frame.origin.y + self.productView.frame.size.height + 15;
    }
    
    //
    // ---------------- QUANTITY ----------------
    //
    self.quantityLabel.text = (detail.acquiredQuantity) ? detail.acquiredQuantity.stringValue : @"";
    
    CGFloat lastY = self.quantityLabel.frame.origin.y + self.quantityLabel.frame.size.height;
    
    NSNumberFormatter *formatter = [[OFFormatter sharedInstance] currencyFormatter];
    
    //
    // ---------------- UNIT PRICE ----------------
    //
    if (detail.value.floatValue > 0) {
        self.unitPriceTitleLabel.hidden = self.unitPriceLabel.hidden = NO;
        self.unitPriceLabel.text = [formatter stringFromNumber:detail.value];
        lastY = self.unitPriceLabel.frame.origin.y + self.unitPriceLabel.frame.size.height;
    }
    
    //
    // ---------------- TOTAL PRICE ----------------
    //
    if (detail.totalAmount.floatValue > 0) {
        self.totalPriceLabel.hidden = self.totalTitleLabel.hidden = NO;
        self.totalPriceLabel.text = [formatter stringFromNumber:detail.totalAmount];
        
        CGRect totalPriceFrame = self.totalPriceLabel.frame;
        totalPriceFrame.origin.y = lastY;
        self.totalPriceLabel.frame = totalPriceFrame;
        
        CGRect totalPriceTitleFrame = self.totalTitleLabel.frame;
        totalPriceTitleFrame.origin.y = lastY;
        self.totalTitleLabel.frame = totalPriceTitleFrame;
        
        lastY = self.totalPriceLabel.frame.origin.y + self.totalPriceLabel.frame.size.height;
    }
    
    //
    // ---------------- OPTIONAL DESCRIPTION ----------------
    //
    
    NSString *options;
    if (detail.parentId.length > 0)
    {
        for (Kit *kit in kits)
        {
            if ([kit.kitID isEqualToString:detail.parentId])
            {
                options = kit.descriptionText;
                break;
            }
        }
    }
    
    if (options.length > 0)
    {
        self.optionalDescriptionLabel.text = options;
        self.optionalDescriptionLabel.hidden = NO;
        CGSize optionsSize = [self.optionalDescriptionLabel.text sizeForTextWithFont:self.optionalDescriptionLabel.font
                                                                         constrainedToSize:CGSizeMake(self.optionalDescriptionLabel.frame.size.width, CGFLOAT_MAX)];
        CGRect optionsFrame = self.optionalDescriptionLabel.frame;
        optionsFrame.origin.y = lastY + 5.0f;
        optionsFrame.size.height = optionsSize.height;
        self.optionalDescriptionLabel.frame = optionsFrame;
        lastY = self.optionalDescriptionLabel.frame.origin.y + self.optionalDescriptionLabel.frame.size.height;
    }
    
    invoiceFrame.size.height = lastY;
    
    self.invoiceView.frame = invoiceFrame;
    total = invoiceFrame.origin.y + invoiceFrame.size.height;
    total += 15.0f;
    
    CGRect viewFrame = self.frame;
    viewFrame.size.height = total;
    self.frame = viewFrame;
    
    self.dividerView.frame = CGRectMake(15, total - 1, self.frame.size.width - 30, 1);
}

- (void)hideProductDivider:(BOOL)hide
{
    self.dividerView.hidden = hide;
}


@end
