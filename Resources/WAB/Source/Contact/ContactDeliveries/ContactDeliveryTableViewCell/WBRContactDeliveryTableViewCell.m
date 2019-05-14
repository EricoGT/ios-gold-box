//
//  WBRContactDeliveryTableViewCell.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 3/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactDeliveryTableViewCell.h"
#import "WBRContactDeliveryProductCollectionViewCell.h"

@interface WBRContactDeliveryTableViewCell ()<UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *deliveryNumber;
@property (weak, nonatomic) IBOutlet UILabel *sellerName;
@property (weak, nonatomic) IBOutlet UICollectionView *productsCollection;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property (strong, nonatomic) WBRContactRequestDeliveryModel *delivery;

@end

@implementation WBRContactDeliveryTableViewCell

+ (NSString *)reusableIdentifier {
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupLayoutCell];
    [self setupProductsTableView];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.containerView.layer.borderWidth = 2;
        self.containerView.layer.borderColor = RGBA(33, 150, 243, 1).CGColor;
    }
}

- (void)setupLayoutCell {
    [self.containerView.layer setCornerRadius:4];
    [self.containerView.layer setMasksToBounds:YES];
    [self.containerView.layer setBorderWidth:1.f];
    [self.containerView.layer setBorderColor:RGBA(204, 204, 204, 1).CGColor];
}

- (void)setupProductsTableView {
    [self.productsCollection setScrollEnabled:NO];
    [self.productsCollection setDataSource:self];
    [self.productsCollection registerNib:[UINib nibWithNibName:[WBRContactDeliveryProductCollectionViewCell reusableIdentifier] bundle:nil] forCellWithReuseIdentifier:[WBRContactDeliveryProductCollectionViewCell reusableIdentifier]];
}

- (void)setupCellWithDelivery:(WBRContactRequestDeliveryModel *)delivery andDeliveryNumber:(NSInteger)deliveryNumber {
    
    self.delivery = delivery;
    self.deliveryNumber.text = [NSString stringWithFormat:@"Entrega %ld", (long)deliveryNumber];
    self.sellerName.text = self.delivery.seller.sellerName;
    
    [self.productsCollection reloadData];
    
    [self layoutIfNeeded];
    [self.productsCollection reloadData];
    self.collectionViewHeight.constant = self.productsCollection.collectionViewLayout.collectionViewContentSize.height;
}


#pragma mark - Collection View DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.delivery.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WBRContactDeliveryProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WBRContactDeliveryProductCollectionViewCell reusableIdentifier] forIndexPath:indexPath];

    WBRContactRequestProductModel *product = self.delivery.products[indexPath.row];

    [cell setUpCellWithImage:product.urlImage];
    
    return cell;
    
}

@end
