//
//  WMExtendProduct.h
//  Walmart
//
//  Created by Marcelo Santos on 1/16/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@interface WMExtendProduct : WMView {
    
    IBOutlet UILabel *lblProduct;
    IBOutlet UIImageView *imgProd;
}

@property (weak, nonatomic) IBOutlet UIView *warrantiesOptionsContainerView;

@property (strong, nonatomic) NSString *selectedWarrantyId;

- (WMExtendProduct *)initWithProductName:(NSString *)productName image:(NSString *)image extendedOptions:(NSArray *)extendedOptions;
- (WMExtendProduct *)initWithProductName:(NSString *)productName image:(NSString *)image extendedWarranties:(NSArray *)extendedWarranties;

@end
