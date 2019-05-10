//
//  ProductBlock.m
//  Tracking
//
//  Created by Bruno Delgado on 4/28/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "ProductBlock.h"
#import "NSString+Additions.h"
#import "UIImageView+WebCache.h"
#import "OFFormatter.h"
#import "NSString+HTML.h"

@interface ProductBlock ()

@property (nonatomic, weak) IBOutlet UIView *productView;
@property (nonatomic, weak) IBOutlet UIView *invoiceView;
@property (nonatomic, weak) IBOutlet UIView *dividerView;
@property (nonatomic, weak) IBOutlet UIView *warrantyView;

@property (nonatomic, weak) IBOutlet UILabel *productDescriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *sellerLabel;
@property (nonatomic, weak) IBOutlet UIImageView *productPicture;

@property (nonatomic, weak) IBOutlet UILabel *quantityLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;

@property (nonatomic, weak) IBOutlet UILabel *warrantyTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *warrantyLabel;
@property (nonatomic, weak) IBOutlet UILabel *warrantyValue;

@property (nonatomic, weak) IBOutlet UIImageView *globalIcon;



@end

@implementation ProductBlock

- (void)setupWithDeliveryItem:(TrackingDeliveryDetailItem *)detail imagePath:(NSString *)imagePath seller:(NSString *)sellerName
{
    [self setLayout];
    CGFloat total = 0;
    
    OFFormatter *formatter = [OFFormatter sharedInstance];
    
    self.globalIcon.hidden = (![detail.originCountry isEqualToString:@"pt-BR"]) ? NO : YES;
    
    //---------------- Product ----------------
    NSString *strDescription = [detail.itemDescription kv_decodeHTMLCharacterEntities];
    self.productDescriptionLabel.text = strDescription;
//    self.productDescriptionLabel.text = detail.itemDescription;
    
    [self.productPicture sd_setImageWithURL:[NSURL URLWithString:detail.urlImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            self.productPicture.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME];
        }
    }];
    
    CGSize newDescriptionSize = [self.productDescriptionLabel.text sizeForTextWithFont:self.productDescriptionLabel.font
                                                                  constrainedToSize:CGSizeMake(self.productDescriptionLabel.frame.size.width, CGFLOAT_MAX)];
    CGFloat defaultDescriptionSize = self.productDescriptionLabel.frame.size.height;
    
    if (newDescriptionSize.height > defaultDescriptionSize)
    {
        CGRect newProductViewFrame = self.productView.frame;
        CGRect newDescriptionFrame = self.productDescriptionLabel.frame;
        
        newDescriptionFrame.size.height = newDescriptionSize.height;
        newProductViewFrame.size.height = (self.productDescriptionLabel.frame.origin.y + newDescriptionSize.height + self.sellerLabel.frame.size.height);
        
        self.productView.frame = newProductViewFrame;
    }
    [self.productDescriptionLabel sizeToFit];
    total += self.productView.frame.size.height;
    
    //---------------- Seller ----------------
    CGRect sellerFrame = self.sellerLabel.frame;
    sellerFrame.origin.y = self.productDescriptionLabel.frame.origin.y + self.productDescriptionLabel.frame.size.height;
    //self.sellerLabel.frame = sellerFrame;
    if ((sellerName != nil) || (![sellerName isEqualToString:@""]))
    {
        self.sellerLabel.text = [NSString stringWithFormat:@"Entrega realizada por %@", sellerName];
    }
    else
    {
        self.sellerLabel.text = @"";
    }
    
    //---------------- Invoice ----------------
    CGRect invoiceFrame = self.invoiceView.frame;
    invoiceFrame.origin.y = total;
    self.invoiceView.frame = invoiceFrame;
    
    if (detail.acquiredQuantity && detail.value)
    {
        NSString *quantityTitle = @"Quantidade: ";
        NSString *quantity = [NSString stringWithFormat:@"%@%@",quantityTitle, detail.acquiredQuantity];
        
        NSRange quantityRange = [quantity rangeOfString:quantityTitle];
        NSRange quantityValueRange = [quantity rangeOfString:detail.acquiredQuantity.stringValue];
        
        NSMutableAttributedString *quantityString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Quantidade: %@", detail.acquiredQuantity.stringValue]];
        
        [quantityString addAttribute:NSForegroundColorAttributeName value:RGBA(153, 153, 153, 1) range:quantityRange];
        [quantityString addAttribute:NSForegroundColorAttributeName value:RGBA( 93, 158,  14, 1) range:quantityValueRange];
        [quantityString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:13] range:NSMakeRange(0, quantityString.length)];
        
        self.quantityLabel.attributedText = quantityString;
        
        NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Preço: %@", [formatter.currencyFormatter stringFromNumber: detail.value]]];
        
        [priceString addAttribute:NSForegroundColorAttributeName value:RGBA(153, 153, 153, 1) range:NSMakeRange(0,7)];
        self.valueLabel.attributedText = priceString;
        
        self.subtotalLabel.text = [NSString stringWithFormat:@"%@",[formatter.currencyFormatter stringFromNumber:detail.totalAmount]];
        total += self.invoiceView.frame.size.height;
    }
    
    //---------------- Warranty ----------------
    //TODO: Mapear os tipos de services
    //NSMutableArray *warranties = [NSMutableArray new];
    
    self.warrantyView.hidden = YES;
    
    CGRect dividerFrame = self.dividerView.frame;
    dividerFrame.origin.y = total;
    self.dividerView.frame = dividerFrame;
    total += self.dividerView.frame.size.height;
    
    CGRect viewFrame = self.frame;
    viewFrame.size.height = total;
    self.frame = viewFrame;
}

- (void)hideProductDivider:(BOOL)hide
{
    self.dividerView.hidden = hide;
}

- (void)setLayout
{
    UIColor *customTextColor = RGBA(102, 102, 102, 1);
    
    self.productDescriptionLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:12];
    self.productDescriptionLabel.textColor = customTextColor;
    
    self.sellerLabel.font = [UIFont fontWithName:@"OpenSans" size:12];
    self.sellerLabel.textColor = RGBA(153, 153, 153, 1);
    
    self.valueLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13];
    self.valueLabel.textColor = RGBA(93, 158, 14, 1);
    
    self.warrantyTitleLabel.font = [UIFont fontWithName:@"OpenSans" size:12];
    self.warrantyTitleLabel.textColor = RGBA(26, 117, 207, 1);
    
    self.warrantyLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:17];
    self.warrantyLabel.textColor = RGBA(26, 117, 207, 1);
    
    self.warrantyValue.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    self.warrantyValue.textColor = customTextColor;
    
    self.subtotalLabel.font = [UIFont fontWithName:@"OpenSans" size:18];
    self.subtotalLabel.textColor = customTextColor;
    self.subtotalLabel.textColor = RGBA(93, 158, 14, 1);
    
}

@end
