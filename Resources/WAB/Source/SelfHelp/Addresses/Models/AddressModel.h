//
//  AddressModel.h
//  Walmart
//
//  Created by Renan on 5/14/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

extern NSString* const kAddressNoNumberDefaultValue;
extern NSString* const kAddressNoNumberDefaultString;

@interface AddressModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *addressId;
@property (nonatomic, strong) NSString<Optional> *receiverName;
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString<Optional> *number;
@property (nonatomic, strong) NSString<Optional> *complement;
@property (nonatomic, strong) NSString *neighborhood;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSNumber<Optional> *defaultAddress;
@property (nonatomic, strong) NSString<Optional> *referencePoint;
@property (nonatomic, strong) NSNumber<Optional> *notReceiver;
@property (nonatomic, strong) NSString<Optional> *addressDescription;

- (NSString *)fullAddress;
- (NSString *)formattedZipCode;
- (NSString *)JSONObjectForType;


/**
 Method to get street name with complement

 @return concatened street name, venue number, and complement
 */
- (NSString *)streetNameWithComplement;


/**
 Method to get aditional information

 @return concatened neighborhood, city and state
 */
- (NSString *)additionalInformation;

@end
