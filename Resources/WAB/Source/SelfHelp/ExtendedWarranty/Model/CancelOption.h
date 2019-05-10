//
//  CancelOption.h
//  Walmart
//
//  Created by Bruno on 6/15/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol CancelOption
@end

@interface CancelOption : JSONModel

@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSNumber *refund;

@end
