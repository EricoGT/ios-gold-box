//
//  WBRAddCreditCardViewController.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 26/10/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBRAddCreditCardProtocol <NSObject>
@required
- (void)didAddCreditCard;
@end

@interface WBRAddCreditCardViewController : UIViewController

@property (weak) id <WBRAddCreditCardProtocol> delegate;

@end
