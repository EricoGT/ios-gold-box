//
//  WMBaseModel.h
//  Walmart
//
//  Created by Renan Cargnin on 3/14/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@interface WMBaseModel : JSONModel

+ (id)mock;
+ (NSArray *)arrayOfMocks;

@end
