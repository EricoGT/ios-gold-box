//
//  Bank.h
//  Walmart
//
//  Created by Bruno on 6/15/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol Bank
@end

@interface Bank : JSONModel

@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, strong) NSString *name;

@end
