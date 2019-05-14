//
//  ZipCodeModel.h
//  Walmart
//
//  Created by Renan on 5/25/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@interface ZipCodeModel : JSONModel

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *stateAcronym;
@property (nonatomic, strong) NSString<Optional> *streetType;
@property (nonatomic, strong) NSString<Optional> *street;
@property (nonatomic, strong) NSString<Optional> *neighborhood;

- (NSString *)completeStreetName;

@end
