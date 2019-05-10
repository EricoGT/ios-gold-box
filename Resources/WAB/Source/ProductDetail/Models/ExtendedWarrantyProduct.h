//
//  ExtendedWarrantyProduct.h
//  Walmart
//
//  Created by Renan Cargnin on 1/27/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

#import "ExtendedWarranty.h"

@protocol ExtendedWarrantyProduct
@end

@interface ExtendedWarrantyProduct : JSONModel

//@property (assign, nonatomic) BOOL isActive;
//@property (strong, nonatomic) NSNumber *sku;
//@property (strong, nonatomic) NSNumber *productId;
//@property (assign, nonatomic) BOOL isKit;
@property (strong, nonatomic) NSArray<ExtendedWarranty, Optional> *warranties;
//@property (strong, nonatomic) NSArray<ExtendedWarrantyProduct, Optional> *kitItems;
//@property (strong, nonatomic) NSString<Optional> *title;

@end
