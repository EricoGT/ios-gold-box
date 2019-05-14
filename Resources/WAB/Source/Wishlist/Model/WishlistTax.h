//
//  WishlistTax.h
//  Walmart
//
//  Created by Bruno on 12/3/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol WishlistTax
@end

@interface WishlistTax : JSONModel

@property (nonatomic, strong) NSNumber *tax;
@property (nonatomic, strong) NSNumber *importTax;

@end
