//
//  ExtendedWarrantyCancelData.h
//  Walmart
//
//  Created by Bruno on 6/15/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "CancelOption.h"
#import "Bank.h"

@interface ExtendedWarrantyCancelData : JSONModel

@property (nonatomic, strong) NSArray *reason;
@property (nonatomic, strong) NSArray<CancelOption> *option;
@property (nonatomic, strong) NSArray<Bank> *banks;

@end
