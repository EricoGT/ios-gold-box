//
//  ExtendedWarrantySuccessView.h
//  Walmart
//
//  Created by Bruno Delgado on 1/14/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtendedWarrantySuccessView : UIView

@property (nonatomic, strong) NSString *protocolNumber;

+ (UIView *)setup;
- (void)setLayout;

@end
