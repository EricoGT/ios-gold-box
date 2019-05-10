//
//  WBRCheckoutAddressModel.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 6/18/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@interface WBRCheckoutAddressModel : JSONModel

@property (strong, nonatomic) NSString *receiverName;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *neighborhood;
@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *complement;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *referencePoint;
@property (strong, nonatomic) NSString *descriptionAddress;
@property (strong, nonatomic) NSNumber *defaultAddress;

@end
