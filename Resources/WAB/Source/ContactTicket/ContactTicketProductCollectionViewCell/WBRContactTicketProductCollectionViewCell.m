//
//  WBRContactTicketProductCollectionViewCell.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 3/15/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactTicketProductCollectionViewCell.h"
#import "WMImageView.h"

@interface WBRContactTicketProductCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet WMImageView *productImage;

@property (weak, nonatomic) IBOutlet UIView *containerViewMoreProducts;
@property (weak, nonatomic) IBOutlet UILabel *numberProducts;

@end

@implementation WBRContactTicketProductCollectionViewCell

+ (NSString *)reusableIdentifier {
    return NSStringFromClass([self class]);
}

- (void)setupLayoutCellBorder {
    [self.layer setCornerRadius:1];
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderWidth:1.f];
    [self.layer setBorderColor:RGBA(204, 204, 204, 1).CGColor];
}

- (void)setupProductCellWithImage:(NSString *)imageUrl {
    NSString *newStringUrl = imageUrl;
    
    if ([newStringUrl rangeOfString:@"http"].location == NSNotFound) {
        newStringUrl = [NSString stringWithFormat:@"https:%@", imageUrl];
    }
    
    [self.productImage setImageWithURLStr:newStringUrl failureImageName:IMAGE_UNAVAILABLE_NAME_2];
    
    [self setupLayoutCellBorder];
    [self.containerViewMoreProducts setHidden:YES];
    [self.containerView setHidden:NO];
}

- (void)setupProdutCellWithNumberOfMoreProducts:(NSNumber *)numberProducts {
    
    self.numberProducts.text = [NSString stringWithFormat:@"+%@", numberProducts.stringValue];
    [self.containerView setHidden:YES];
    [self.containerViewMoreProducts setHidden:NO];
}

- (void)resetLayout {
    [self.productImage setImage:nil];
    [self.layer setBorderWidth:0.f];
    [self.containerViewMoreProducts setHidden:YES];
    [self.containerView setHidden:YES];
}

@end
