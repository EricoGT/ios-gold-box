//
//  VariationPopup.h
//  Walmart
//
//  Created by Renan Cargnin on 11/23/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WMPinnedView.h"

@class VariationNode;

@interface VariationPopup : WMPinnedView

- (VariationPopup *)initWithProductId:(NSString *)productId selectedSKUBlock:(void (^)(NSNumber *sku))selectedSKUBlock;

@end
