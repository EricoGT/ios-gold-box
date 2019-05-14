//
//  ShippingCell.m
//  Walmart
//
//  Created by Renan on 5/2/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ShippingCell.h"

#import "ShippingDelivery.h"

#import "ShippingDeliveryCell.h"
#import "ShippingProductCell.h"

#import "OFShipmentTemp.h"

@interface ShippingCell () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *sellerLabel;

@property (weak, nonatomic) IBOutlet UITableView *productsTableView;
@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *productsTableViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *optionsTableViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *shipmentDividerView;

@end

@implementation ShippingCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([ShippingCell class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSellerLabelTap:)];
    [_sellerLabel addGestureRecognizer:tapGesture];
    [_sellerLabel setUserInteractionEnabled:YES];
    
    [_productsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShippingProductCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ShippingProductCell class])];
    [_productsTableView setDataSource:self];
    [_productsTableView setDelegate:self];
    
    [_optionsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShippingDeliveryCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ShippingDeliveryCell class])];
    [_optionsTableView setDataSource:self];
    [_optionsTableView setDelegate:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDeliveryIndex:(NSInteger)index total:(NSInteger)total {
    self.deliveryIndexLabel.text = [NSString stringWithFormat:@"Entrega %li de %li", (long) index + 1, (long) total];
    
    if ((index + 1) == total) {
        self.shipmentDividerView.hidden = YES;
    }
    else {
        self.shipmentDividerView.hidden = NO;
    }
    
    if (total == 1) {
        self.deleteButton.hidden = YES;
    }
    else {
        self.deleteButton.hidden = NO;
    }
}

- (void)setShippingDelivery:(ShippingDelivery *)shippingDelivery {
    _shippingDelivery = shippingDelivery;
    
    NSMutableAttributedString *attributedSeller = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Entregue por %@", shippingDelivery.sellerName]];
    [attributedSeller addAttribute:NSForegroundColorAttributeName value:RGBA(33, 150, 243, 1) range:[attributedSeller.string rangeOfString:shippingDelivery.sellerName]];
    UIFont *robottoMediumFont = [UIFont fontWithName:@"Roboto-Medium" size:11.0f];
    [attributedSeller addAttribute:NSFontAttributeName value:robottoMediumFont range:[attributedSeller.string rangeOfString:shippingDelivery.sellerName]];
    _sellerLabel.attributedText = attributedSeller.copy;
    
    [_productsTableView reloadData];
    [_optionsTableView reloadData];
    
    if (!shippingDelivery.selectedDelivery) {
        _shippingDelivery.selectedDelivery = [_shippingDelivery cheapestDelivery];
    }
    [_optionsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[shippingDelivery.deliveryTypes indexOfObject:shippingDelivery.selectedDelivery] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    _productsTableViewHeightConstraint.constant = _productsTableView.contentSize.height;
    _optionsTableViewHeightConstraint.constant = _optionsTableView.contentSize.height;
}

- (void)scheduleDelivery {
    if ([_delegate respondsToSelector:@selector(shippingCellPressedScheduledDeliveryButton:)]) {
        [_delegate shippingCellPressedScheduledDeliveryButton:self];
    }
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _optionsTableView) {
        return _shippingDelivery.deliveryTypes.count;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _productsTableView) {
        return _shippingDelivery.cartItems.count;
    }
    else if (tableView == _optionsTableView) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.productsTableView) {
        ShippingProductCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShippingProductCell class]) forIndexPath:indexPath];
        [cell setupWithCartItem:self.shippingDelivery.cartItems[indexPath.row]];
        return cell;
    }
    else if (tableView == _optionsTableView) {
        ShippingDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShippingDeliveryCell class]) forIndexPath:indexPath];
        [cell setupWithDeliveryType:self.shippingDelivery.deliveryTypes[indexPath.section]];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.optionsTableView) {
        
        if (indexPath.section < self.shippingDelivery.deliveryTypes.count) {

            DeliveryType *selectedDelivery = self.shippingDelivery.deliveryTypes[indexPath.section];
            self.shippingDelivery.selectedDelivery = selectedDelivery;
            if ([selectedDelivery isScheduledShipping]) {
                [self scheduleDelivery];
            } else {
                [self.shippingDelivery.scheduledDelivery setSelectedScheduledDeliveryPeriod:nil];
            }
        }
    }
}

#pragma mark - ScheduledDeliveryDateViewDelegate
- (void)scheduledDeliveryView:(ScheduleDeliveryDateViewController *)scheduledDeliveryView selectedDate:(NSDate *)date periodDictionary:(NSDictionary *)periodDictionary {

    if (periodDictionary != nil) {
        [[OFShipmentTemp new] assignSelectedShipmentDetails:periodDictionary];
        [self.shippingDelivery.scheduledDelivery setSelectedScheduledDeliveryPeriod:periodDictionary];
        _shippingDelivery.selectedDelivery = _shippingDelivery.scheduledDelivery;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.optionsTableView reloadData];
            
            [self->_optionsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self->_shippingDelivery.deliveryTypes indexOfObject:self->_shippingDelivery.scheduledDelivery]] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
    } else {
        if (!self.shippingDelivery.scheduledDelivery.selectedScheduledDeliveryPeriod) {
            [self.optionsTableView reloadData];
            [_optionsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[_shippingDelivery.deliveryTypes indexOfObject:_shippingDelivery.cheapestDelivery]] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
}

#pragma mark - UIGestureRecognizer
- (void)handleSellerLabelTap:(UITapGestureRecognizer *)tapGesture {
    if ([_delegate respondsToSelector:@selector(shippingCellTappedSellerLabel:)]) {
        [_delegate shippingCellTappedSellerLabel:self];
    }
}

#pragma mark - IBAction 

- (IBAction)deleteDelivery:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shippingCellPressedDeleteDeliveryButton:)]) {
        [self.delegate shippingCellPressedDeleteDeliveryButton:self];
    }
}

@end
