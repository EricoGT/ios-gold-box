//
//  Freight.h
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/15/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "FreightItem.h"

@interface Freight : JSONModel
@property (nonatomic, strong) NSString *sellerId;
@property (nonatomic, strong) NSString *sellerName;
@property (nonatomic, strong) NSArray<FreightItem>*items;
@end
