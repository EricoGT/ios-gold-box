//
//  WMBCalculateShippingCostViewController.h
//  Walmart
//
//  Created by Rafael Valim on 13/07/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalculateShippingForCEPProtocol <NSObject>
@required
- (void)didCalculateShippingFeeForCEP;
- (void)didDismissShippingCostCalculationViewController;
@end

@interface WMBCalculateShippingCostViewController : UIViewController <UITextFieldDelegate>

@property (weak) id <CalculateShippingForCEPProtocol> delegate;
@property (nonatomic, copy) NSString *currentPostalCode;

@end
