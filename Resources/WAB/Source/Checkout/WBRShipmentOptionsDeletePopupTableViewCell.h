//
//  WBRShipmentOptionsDeletePopupTableViewCell.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 8/25/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const kShipmentOptionsDeleteTableViewCellReuseIdentifier;

@interface WBRShipmentOptionsDeletePopupTableViewCell : UITableViewCell

- (void)setUpCellWithItemQuantity:(NSNumber *)quantity andItemDescription:(NSString *)itemDescription;

+ (UINib *)getNib;

@end
