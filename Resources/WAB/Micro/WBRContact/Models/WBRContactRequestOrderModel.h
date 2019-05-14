//
//  WBRContactRequestOrderModel.h
//  Walmart
//
//  Created by Renan on 6/17/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol WBRContactRequestOrderModel
@end

@interface WBRContactRequestOrderModel : JSONModel

@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) NSNumber<Optional> *returnable;
@property (strong, nonatomic) NSArray<NSString *> *imagesIds;
@property (strong, nonatomic) NSNumber *quantity;

@property (strong, nonatomic) NSNumber<Optional> *canceled;
@property (strong, nonatomic) NSNumber<Optional> *hasWarranty;


@end
