//
//  ExtendedWarranty.h
//  Walmart
//
//  Created by Renan Cargnin on 1/27/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol ExtendedWarranty
@end

@interface ExtendedWarranty : JSONModel

@property (strong, nonatomic) NSNumber *extendedWarrantyId;
//@property (assign, nonatomic) BOOL isActive;
@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSNumber *price;

@property (strong, nonatomic) NSNumber <Optional> *instalment;
@property (strong, nonatomic) NSNumber <Optional> *instalmentValue;

@property (strong, nonatomic) NSNumber *period;

//@property (strong, nonatomic) NSString *warrantyType;
//@property (strong, nonatomic) NSNumber *sku;

@property (strong, nonatomic) NSString *name;

@property (assign, nonatomic) BOOL showRecommended;

@end
