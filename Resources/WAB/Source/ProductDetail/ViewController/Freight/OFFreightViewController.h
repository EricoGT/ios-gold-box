//
//  OFFreightViewController.h
//  Walmart
//
//  Created by Bruno Delgado on 8/12/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "WMBaseViewController.h"
#import "ProductDetailModel.h"
#import "Freight.h"

@protocol freightViewDelegate <NSObject>
@optional
- (void) closeFreightFromContinueShopping;
- (void) closeFreightFromProductDetail:(NSArray<Freight *>*)freights andZipCode:(NSString *)zipCodeSearched;
@end

@interface OFFreightViewController : WMBaseViewController

@property(nonatomic, strong) NSString *price;
@property(nonatomic, weak) IBOutlet UIView *failView;
@property(nonatomic, weak) IBOutlet UILabel *errorLabel;
@property (weak) id <freightViewDelegate> delegate;

- (OFFreightViewController *)initWithStandardSKU:(NSString *)standartSku andSearchedZipcode:(NSString *)zipCodeSearched delegate:(id<freightViewDelegate>)delegate;

@end
