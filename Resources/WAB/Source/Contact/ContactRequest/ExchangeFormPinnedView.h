//
//  ExchangeFormPinnedView.h
//  Walmart
//
//  Created by Renan Cargnin on 6/18/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMPinnedView.h"

#import "ContactRequestExchangeFieldModel.h"

@class WMPickerTextField;

@interface ExchangeFormPinnedView : UIView

@property (strong, nonatomic) UIView *bottomContainer;

@property (strong, nonatomic) NSArray<ContactRequestExchangeFieldModel> *fields;
@property (strong, nonatomic) NSArray *textFields;
@property (strong, nonatomic) WMPickerTextField *refundPickerTextField;
@property (strong, nonatomic) ContactRequestExchangeFieldModel *refundFieldModel;

- (ExchangeFormPinnedView *)init;
- (void)setupWithFields:(NSArray<ContactRequestExchangeFieldModel> *)fields;

@end
