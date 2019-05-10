//
//  Zipcode.h
//  Walmart
//
//  Created by Renan Cargnin on 29/12/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@interface Zipcode : JSONModel

@property (strong, nonatomic) NSString *zipcodeId;
@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *streetType;
@property (strong, nonatomic) NSString *neighborhood;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *stateAcronym;

@end
