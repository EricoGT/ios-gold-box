//
//  WBRRemoveCreditCardViewController.h
//  Walmart
//
//  Created by Rafael Valim on 10/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBRModelCreditCard.h"

@protocol WBRRemoveCreditCardProtocol <NSObject>
@required
- (void)didRemoveCreditCard;
- (void)didFailToRemoveCreditCard;
- (void)didDismissRemoveCreditCardPopup;
@end

@interface WBRRemoveCreditCardViewController : UIViewController

@property (weak) id <WBRRemoveCreditCardProtocol> delegate;

- (instancetype)initWithCreditCard:(WBRModelCreditCard *)creditCard;

@end
