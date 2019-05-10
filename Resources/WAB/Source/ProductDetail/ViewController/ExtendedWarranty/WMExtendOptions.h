//
//  WMExtendOptions.h
//  Walmart
//
//  Created by Marcelo Santos on 1/8/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@class WMExtendOptions, ExtendedWarranty;

@protocol WMExtendOptionsDelegate <NSObject>
@required
- (void)checkedWarrantyOption:(WMExtendOptions *)checkedOptionView;
@end

@interface WMExtendOptions : WMView

@property (weak) id <WMExtendOptionsDelegate> delegate;

//@property (strong, nonatomic) NSDictionary *dictWarr;

- (WMExtendOptions *)initWithWarrantyDictionary:(NSDictionary *)warrantyDictionary delegate:(id <WMExtendOptionsDelegate>)delegate;
- (WMExtendOptions *)initWithExtendedWarranty:(ExtendedWarranty *)extendedWarranty delegate:(id <WMExtendOptionsDelegate>)delegate;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
