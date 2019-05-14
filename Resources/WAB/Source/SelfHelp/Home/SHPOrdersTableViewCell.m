//
//  OrdersTableViewCell.m
//  Tracking
//
//  Created by Bruno Delgado on 4/16/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "SHPOrdersTableViewCell.h"
#import "NSDate+DateTools.h"
#import "NSString+Additions.h"

#import "OrderGalleryItemCell.h"
#import "OrderGalleryLabelCell.h"
#import "ConciergeDeliveryButton.h"

#import "TrackingOrder.h"

@interface SHPOrdersTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *galleryCollectionView;

@property (strong, nonatomic) TrackingOrder *order;

@end

@implementation SHPOrdersTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [_galleryCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderGalleryItemCell class]) bundle:nil] forCellWithReuseIdentifier:[OrderGalleryItemCell reuseIdentifier]];
    [_galleryCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderGalleryLabelCell class]) bundle:nil] forCellWithReuseIdentifier:[OrderGalleryLabelCell reuseIdentifier]];
    [_galleryCollectionView setDataSource:self];
    [_galleryCollectionView setDelegate:self];
    
    [self setLayout];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    _bottomView.backgroundColor = highlighted ? RGBA(244, 123, 32, 1) : RGBA(230, 230, 230, 1);
}

#pragma mark - Layout
- (void)setLayout {
    self.backgroundColor = [UIColor clearColor];
    
    self.cardView.layer.borderWidth = 1.0f;
    self.cardView.layer.borderColor = RGBA(230, 230, 230, 1).CGColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureWithOrder:(TrackingOrder *)order
{
    [self setOrderInfos:order];
    [self setStatusForOrder:order];
    
    self.order = order;
    [_galleryCollectionView reloadData];
}

#pragma mark - Setup
- (void)setStatusForOrder:(TrackingOrder *)order
{
    DeliveryTrackingItem *tracking = order.tracking;
    if (tracking)
    {
        self.orderStatusLabel.text = tracking.itemDescription;
        
        if (tracking.expectedDeliveryDate)
        {
            if (tracking.messageDate.length > 0)
            {
                self.orderPrevisionLabel.text = [NSString stringWithFormat:@"%@%@", tracking.messageDate, [tracking.expectedDeliveryDate formattedDateWithFormat:@"dd/MM/yyyy"]];
            }
            else
            {
                NSString *deliveryMessage = [[OFMessages new] expectedOrderDeliveryDate];
                self.orderPrevisionLabel.text = [NSString stringWithFormat:deliveryMessage,[tracking.expectedDeliveryDate formattedDateWithFormat:@"dd/MM/yyyy"]];
            }
        }
        else
        {
            self.orderPrevisionLabel.text = @"";
        }
        
        //Concierge
        self.conciergeButton.hidden = !order.conciergeDelayed || _orderPrevisionLabel.text.length == 0;
        
        UIImage *image = nil;
        if (tracking.status)
        {
            image = [UIImage imageNamed:tracking.status];
        }
        
        self.orderStatusImageView.image = image;
        return;
    }
    
    self.orderStatusLabel.text = @"";
    self.orderPrevisionLabel.text = @"";
    self.orderStatusImageView.image = nil;
}

- (void)setOrderInfos:(TrackingOrder *)order
{
    //Order number
    self.orderNumberLabel.text = order.orderId;
    
    //Order date
    self.orderDateLabel.text = @"";
    if (order.creationDate) {
        self.orderDateLabel.hidden = NO;
        self.orderDateLabel.text = [order.creationDate formattedDateWithFormat:@"dd/MM/YYYY"];
    }
    else {
        self.orderDateLabel.hidden = YES;
    }
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_order.items.count > 3) {
        return 3;
    }
    else {
        return _order.items.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_order.items.count > 3 && indexPath.row == 2) {
        OrderGalleryLabelCell *cell = [_galleryCollectionView dequeueReusableCellWithReuseIdentifier:[OrderGalleryLabelCell reuseIdentifier] forIndexPath:indexPath];
        [cell setCount:_order.items.count - 2];
        return cell;
    }
    else {
        TrackingOrderItem *item = _order.items[indexPath.row];
        
        OrderGalleryItemCell *cell = [_galleryCollectionView dequeueReusableCellWithReuseIdentifier:[OrderGalleryItemCell reuseIdentifier] forIndexPath:indexPath];
        [cell setProductImageURL:item.urlImage];
        cell.extendedWarrantyImageView.hidden = YES;
        cell.globalStampImageView.hidden = [item.originCountry isEqualToString:@"pt-BR"];
        
        return cell;
    }
}

#pragma mark - UICollctionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSInteger cellCount = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:section];
    CGFloat cellWidth = ((UICollectionViewFlowLayout *)collectionViewLayout).itemSize.width + ((UICollectionViewFlowLayout*)collectionViewLayout).minimumLineSpacing;
    CGFloat totalCellWidth = cellWidth * cellCount - ((UICollectionViewFlowLayout*)collectionViewLayout).minimumLineSpacing;
    CGFloat contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right;
    
    if (totalCellWidth < contentWidth) {
        CGFloat padding = (contentWidth - totalCellWidth) / 2;
        return UIEdgeInsetsMake(0, padding, 0, padding);
    }
    else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

@end
