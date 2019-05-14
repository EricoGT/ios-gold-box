//
//  WBRCreditCardCell.h
//  Walmart
//
//  Created by Diego Dias on 10/27/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WBRModelCreditCard.h"

@class WBRCreditCardCell;

static NSString *kCreditCardCellIdentifier = @"kPaymentCreditCardTableViewCellIdentifier";
static NSInteger kCreditCardCellCollapsedHeight = 89;
static NSInteger kCreditCardCellExpandedHeight = 276;
static NSInteger kCreditCardCellExpandedWithRateWarningHeight = 335;

@protocol WBRCreditCardCellProtocol <NSObject>
- (void)WBRCreditCardCellDidSelectRemoveCard:(NSIndexPath *)indexPath;
- (void)WBRCreditCardCellDidSelectSetDefaultCard:(NSIndexPath *)indexPath;
@end

@interface WBRCreditCardCell : UITableViewCell

@property (strong, nonatomic) WBRModelCreditCard *card;

@property (weak, nonatomic) id <WBRCreditCardCellProtocol> delegate;

+ (NSString *)reuseIdentifier;
- (void)setupCard:(WBRModelCreditCard *)card hasOnlyOneCard:(BOOL)hasOnlyOneCard indexPath:(NSIndexPath *)indexPath;
@end
