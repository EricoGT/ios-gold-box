//
//  WBRContactRequestProductModel.h
//  Walmart
//
//  Created by Renan on 6/17/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol WBRContactRequestProductModel
@end

@interface WBRContactRequestProductModel : JSONModel

@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSString *urlImage;
@property (strong, nonatomic) NSNumber *acquiredQuantity;
@property (strong, nonatomic) NSNumber *value;
@property (strong, nonatomic) NSNumber *totalAmount;
@property (strong, nonatomic) NSNumber *returnable;

@end
