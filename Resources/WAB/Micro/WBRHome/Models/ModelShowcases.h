//
//  ModelShowcases.h
//  Walmart
//
//  Created by Marcelo Santos on 3/23/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "ModelShelfItems.h"

@protocol ModelShowcases
@end

@interface ModelShowcases : JSONModel

@property (strong, nonatomic) NSString *idShowcase;
@property (strong, nonatomic) NSNumber *orderId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSArray <Optional, ModelShelfItems> *shelfItems;

@end
