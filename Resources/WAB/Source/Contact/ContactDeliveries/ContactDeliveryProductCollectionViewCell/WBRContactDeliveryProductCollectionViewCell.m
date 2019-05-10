//
//  WBRContactDeliveryProductCollectionViewCell.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 3/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactDeliveryProductCollectionViewCell.h"
#import "WMImageView.h"

@interface WBRContactDeliveryProductCollectionViewCell ()

@property (weak, nonatomic) IBOutlet WMImageView *product;

@end

@implementation WBRContactDeliveryProductCollectionViewCell

+ (NSString *)reusableIdentifier {
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupLayoutCell];
}

- (void)setupLayoutCell {
    [self.layer setCornerRadius:1];
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderWidth:1.f];
    [self.layer setBorderColor:RGBA(204, 204, 204, 1).CGColor];
}

- (void)setUpCellWithImage:(NSString *)urlImage {
    if (urlImage != nil && urlImage.length > 0) {
        [self.product setImageWithURLStr:urlImage failureImageName:IMAGE_UNAVAILABLE_NAME_2];
    }
}

@end
