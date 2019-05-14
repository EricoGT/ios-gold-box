//
//  CardProductsView.h
//  CustomComponents
//
//  Created by Marcelo Santos on 3/2/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol delegateProductsCard <NSObject>
@required
- (void) backToSelectDeliveryFromCardProducts;
@end


@interface CardProductsView : WMBaseViewController {
    
    __weak id <delegateProductsCard> delegate;
}

@property (weak) id delegate;

- (void) fillContentWithProduct:(NSDictionary *) dictProduct;
- (void) removeEdition;

@end
