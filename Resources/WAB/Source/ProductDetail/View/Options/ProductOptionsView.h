//
//  ProductOptionsView.h
//  Walmart
//
//  Created by Renan Cargnin on 1/12/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@protocol ProductOptionsViewDelegate <NSObject>
@required
- (void)productOptionsPressedPaymentForms;
- (void)productOptionsPressedCalculateFreight;
- (void)productOptionsPressedDescription;
- (void)productOptionsPressedFeatures;
@end

@interface ProductOptionsView : WMView

@property (weak) id <ProductOptionsViewDelegate> delegate;

- (ProductOptionsView *)initWithDelegate:(id <ProductOptionsViewDelegate>)delegate showPaymentMethods:(BOOL)showPaymentMethods;

@end
