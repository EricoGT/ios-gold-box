//
//  WBRContactRequestFormModel.h
//  Walmart
//
//  Created by Renan on 6/17/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

#import "WBRContactRequestTypeModel.h"
#import "WBRContactRequestOrderModel.h"
#import "Bank.h"

@interface WBRContactRequestFormModel : JSONModel

@property (strong, nonatomic) NSArray<WBRContactRequestTypeModel> *requestTypes;

@end
