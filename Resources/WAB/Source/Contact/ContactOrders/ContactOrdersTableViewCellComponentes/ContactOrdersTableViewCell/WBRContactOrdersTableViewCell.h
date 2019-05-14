//
//  WBRContactOrdersTableViewCell.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 3/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WBRContactRequestOrderModel.h"

@interface WBRContactOrdersTableViewCell : UITableViewCell

+ (NSString *)reusableIdentifier;

@property (strong, nonatomic) WBRContactRequestOrderModel *order;

@end
