//
//  UnavailableProductView.h
//  Walmart
//
//  Created by Renan Cargnin on 1/26/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@protocol ProductUnavailableViewDelegate <NSObject>
@required
- (void)productUnavailablePressedSendWithInvalidFields:(NSString *) msg andMessageType:(FeedbackAlertKind)type;
@end

@interface ProductUnavailableView : WMView

@property (weak) id <ProductUnavailableViewDelegate> delegate;

@property (strong, nonatomic) NSNumber *sku;

- (ProductUnavailableView *)initWithSKU:(NSNumber *)sku delegate:(id <ProductUnavailableViewDelegate>)delegate;
@end
