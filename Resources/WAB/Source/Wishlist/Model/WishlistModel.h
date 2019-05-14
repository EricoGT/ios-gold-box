//
//  WishlistModel.h
//  Walmart
//
//  Created by Bruno on 12/3/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "WishlistProduct.h"

@interface WishlistModel : JSONModel

//@property (nonatomic, strong) NSString *baseImageUrl;
@property (nonatomic, strong) NSArray<WishlistProduct> *products;

@end
