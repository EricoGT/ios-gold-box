//
//  WBRContactOrdersTableViewCell.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 3/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactOrdersTableViewCell.h"

#import "WBROrderProductImageView.h"

@interface WBRContactOrdersTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *orderView;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet WBROrderProductImageView *firstProductImageView;
@property (weak, nonatomic) IBOutlet WBROrderProductImageView *secondProductImageView;
@property (weak, nonatomic) IBOutlet WBROrderProductImageView *thirdProductImageView;
@property (weak, nonatomic) IBOutlet UILabel *productsQuantityLabel;

@end

@implementation WBRContactOrdersTableViewCell

+ (NSString *)reusableIdentifier {
    return NSStringFromClass([WBRContactOrdersTableViewCell class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupOrderView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {

    if (highlighted) {
        [self setBlueBorderColor];
    }
    else {
        [self setGrayBorderColor];
    }
}

#pragma mark - Custom setter

- (void)setOrder:(WBRContactRequestOrderModel *)order {
    
    _order = order;
    
    [self setupLayoutWithOrder];
}

#pragma mark - Layout

- (void)setupOrderView {
    
    self.orderView.layer.cornerRadius = 4;
    self.orderView.layer.masksToBounds = YES;
    [self setGrayBorderColor];
}

- (void)setGrayBorderColor {
    self.orderView.layer.borderWidth = 1;
    self.orderView.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
}

- (void)setBlueBorderColor {
    self.orderView.layer.borderWidth = 2;
    self.orderView.layer.borderColor = RGBA(33, 150, 243, 1).CGColor;
}

- (void)setupLayoutWithOrder {
    
    self.orderNumberLabel.text = [NSString stringWithFormat:@"Nº %@", self.order.orderId];
    [self setProductsImages];
}

- (void)setProductsImages {
    
    if ([self.order.quantity integerValue] == 1) {
        [self showOneProductImage:[self.order.imagesIds firstObject]];
    }
    else if ([self.order.quantity integerValue] == 2) {
        [self showTwoProductsImages:self.order.imagesIds];
    }
    else if ([self.order.quantity integerValue] == 3) {
        [self showThreeProductsImages:self.order.imagesIds];
    }
    else if ([self.order.quantity integerValue] > 3) {
        [self showMoreThanThreeProductsImages:self.order.imagesIds];
    }
}

- (void)showOneProductImage:(NSString *)image {
    
    self.firstProductImageView.hidden = YES;
    self.secondProductImageView.hidden = YES;
    self.productsQuantityLabel.hidden = YES;
    
    self.thirdProductImageView.hidden = NO;
    self.thirdProductImageView.imageId = image;
}

- (void)showTwoProductsImages:(NSArray<NSString *> *)images {
    
    self.firstProductImageView.hidden = YES;
    self.productsQuantityLabel.hidden = YES;
    
    self.secondProductImageView.hidden = NO;
    self.secondProductImageView.imageId = [images firstObject];
    
    self.thirdProductImageView.hidden = NO;
    if (images.count == 2) {
        self.thirdProductImageView.imageId = [images objectAtIndex:1];
    }
    else {
        self.thirdProductImageView.imageId = nil;
    }
}

- (void)showThreeProductsImages:(NSArray<NSString *> *)images {
    
    self.productsQuantityLabel.hidden = YES;
    
    self.firstProductImageView.hidden = NO;
    self.firstProductImageView.imageId = [images firstObject];
    
    self.secondProductImageView.hidden = NO;
    if (images.count == 2) {
        self.secondProductImageView.imageId = [images objectAtIndex:1];
    }
    else {
        self.secondProductImageView.imageId = nil;
    }
    
    
    self.thirdProductImageView.hidden = NO;
    if (images.count == 3) {
        self.thirdProductImageView.imageId = [images objectAtIndex:2];
    }
    else {
        self.thirdProductImageView.imageId = nil;
    }
}

- (void)showMoreThanThreeProductsImages:(NSArray<NSString *> *)images {
    
    self.thirdProductImageView.hidden = YES;
    
    self.firstProductImageView.hidden = NO;
    self.firstProductImageView.imageId = [images firstObject];
    
    self.secondProductImageView.hidden = NO;
    if (images.count == 2) {
        self.secondProductImageView.imageId = [images objectAtIndex:2];
    }
    else {
        self.secondProductImageView.imageId = nil;
    }
    
    
    self.productsQuantityLabel.hidden = NO;
    self.productsQuantityLabel.text = [NSString stringWithFormat:@"+%ld", (long)(self.order.quantity.integerValue - 2)];
}

@end

