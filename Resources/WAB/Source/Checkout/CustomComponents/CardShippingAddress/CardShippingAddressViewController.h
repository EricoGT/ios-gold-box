//
//  CardShippingAddressViewController.h
//  CustomComponents
//
//  Created by Marcelo Santos on 2/26/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol delegateShippingAddress <NSObject>
@required
- (void) backToSelectShippingAddress;
@end

@interface CardShippingAddressViewController : WMBaseViewController
{
    __weak id <delegateShippingAddress> delegate;
}

@property (weak) id delegate;
@property (nonatomic, strong) NSDictionary *address;

- (void)updateAddressWithDictionary:(NSDictionary *)addressDictionary;
- (NSDictionary *)addressContent;

@end
