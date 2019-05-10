//
//  WBRShipmentOptionsDeletePopupTableViewCell.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 8/25/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRShipmentOptionsDeletePopupTableViewCell.h"

NSString * const kShipmentOptionsDeleteTableViewCellReuseIdentifier = @"ShipmentOptionsDeletePopupTableViewCell";

@interface WBRShipmentOptionsDeletePopupTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;

@end

@implementation WBRShipmentOptionsDeletePopupTableViewCell

- (void)setUpCellWithItemQuantity:(NSNumber *)quantity andItemDescription:(NSString *)itemDescription {

    NSMutableAttributedString *attributedCartItem = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@x - %@", quantity, itemDescription]];
    
    [attributedCartItem addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:102.0f / 255.0f alpha:1.0f] range:NSMakeRange(0, quantity.stringValue.length+1)];
    
    self.itemLabel.attributedText = attributedCartItem.copy;
}

+ (UINib *)getNib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

@end
