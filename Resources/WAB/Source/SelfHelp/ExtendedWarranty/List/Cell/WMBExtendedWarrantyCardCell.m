//
//  WMBExtendedWarrantyCardCell.m
//  Walmart
//
//  Created by Bruno Delgado on 8/11/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBExtendedWarrantyCardCell.h"

#import "ExtendedWarrantyResumeModel.h"
#import "UIImageView+WebCache.h"
#import "NSDate+DateTools.h"

@implementation WMBExtendedWarrantyCardCell

- (WMBExtendedWarrantyCardCell *)initForTestCase
{
    Class class = [self class];
    NSString *nibName = NSStringFromClass(class);
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    self = [nibViews objectAtIndex:0];
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setupWithExtendedWarrantyResumeModel:(ExtendedWarrantyResumeModel *)warranty
{
    self.innerContentView.layer.borderColor = RGBA(230, 230, 230, 1).CGColor;
    self.innerContentView.layer.borderWidth = 1.0f;
    
    [self.productImage sd_setImageWithURL:[NSURL URLWithString:warranty.urlImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.imageLoader stopAnimating];
        self.productImage.contentMode = UIViewContentModeScaleAspectFit;
        if (!image) {
            self.productImage.contentMode = UIViewContentModeCenter;
            self.productImage.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME];
        }
    }];

    self.ticketNumberTitleLabel.text = EXTENDED_WARRANTY_TICKET_TITLE;
    self.ticketNumberLabel.text = warranty.ticketNumber;

    self.accessionDateTitleLabel.text = EXTENDED_WARRANTY_ACCESSION_DATE_TITLE;
    self.accessionDateLabel.text = [warranty.enrollmentDate formattedDateWithFormat:DATE_FORMAT];

    self.extendedWarrantyLabel.text = warranty.descriptionText;

    if (warranty.cancelled.boolValue)
    {
        NSString *cancelledDate = [warranty.rescissionDate formattedDateWithFormat:DATE_FORMAT];
        self.coverageLabel.text = [NSString stringWithFormat:@"%@ %@", EXTENDED_WARRANTY_CANCELLED_TITLE, cancelledDate];
    }
    else
    {
        NSString *startDate = [warranty.startDate formattedDateWithFormat:DATE_FORMAT];
        NSString *expirationDate = [warranty.expirationDate formattedDateWithFormat:DATE_FORMAT];
        self.coverageLabel.text = [NSString stringWithFormat:@"%@\n%@ %@ %@", EXTENDED_WARRANTY_COVERAGE_TITLE, startDate, EXTENDED_WARRANTY_LICENSE_COVERAGE_DATE_SEPARATOR, expirationDate];
    }
}

- (void)setupProductWithImage:(UIImage *)image
{
    self.productImage.contentMode = UIViewContentModeScaleAspectFit;
    if (!image)
    {
        self.productImage.contentMode = UIViewContentModeCenter;
        self.productImage.image = [UIImage imageNamed:@"ic_no_photo"];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.overlayView.hidden = !highlighted;
}


@end
