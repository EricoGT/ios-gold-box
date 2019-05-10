//
//  AddressModel.m
//  Walmart
//
//  Created by Renan on 5/14/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "AddressModel.h"

#import "NSString+HTML.h"

NSString * const kAddressNoNumberDefaultValue  = @"0";
NSString * const kAddressNoNumberDefaultString = @"S/N";

@implementation AddressModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"addressId"         : @"id",
                                                                  @"state"             : @"state.id",
                                                                  @"country"           : @"country.name",
                                                                  @"addressDescription": @"addressName"}];
}

- (void)setTypeWithNSString:(NSString *)typeStr {
    if ([[typeStr lowercaseString] isEqualToString:@"business"]) {
        self.type = @"Comercial";
    }
    else if ([[typeStr lowercaseString] isEqualToString:@"residential"]) {
        self.type = @"Residencial";
    }
    else {
        self.type = @"";
    }
}

- (NSString *)JSONObjectForType {
    if ([[self.type lowercaseString] isEqualToString:@"comercial"]) {
        return @"Business";
    }
    else if ([[self.type lowercaseString] isEqualToString:@"residencial"]) {
        return @"Residential";
    }
    else {
        return @"";
    }
}

- (void)setZipcodeWithNSString:(NSString *)zipcodeStr {
    self.zipcode = zipcodeStr;
    if (zipcodeStr.length == 8) {
        self.zipcode = [NSString stringWithFormat:@"%@-%@", [zipcodeStr substringToIndex:5], [zipcodeStr substringWithRange:NSMakeRange(5, 3)]];
    }
}

- (NSString *)JSONObjectForZipcode {
    return [self.zipcode stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (NSString *)fullAddress {
    NSMutableString *addressStr = [NSMutableString new];
    [addressStr appendString:self.street];
    
    if (self.number && ![self.number isEqualToString:@""] && ![self.number isEqualToString:kAddressNoNumberDefaultValue]) {
        [addressStr appendString:[NSString stringWithFormat:@", %@",self.number]];
    }
    else {
        [addressStr appendString:[NSString stringWithFormat:@", %@", kAddressNoNumberDefaultString]];
    }
    
    if (![self.complement isEqualToString:@""]) {
        [addressStr appendString:[NSString stringWithFormat:@" - %@", self.complement ]];
    }

    NSMutableArray *secondLineTerms = [NSMutableArray new];
    self.neighborhood.length == 0 ?: [secondLineTerms addObject:self.neighborhood];
    self.city.length == 0 ?: [secondLineTerms addObject:self.city];
    self.state.length == 0 ?: [secondLineTerms addObject:self.state];
    
    if (secondLineTerms.count > 0) [addressStr appendString:@"\n"];
    
    for (NSString *term in secondLineTerms) {
        [addressStr appendString:term];
        if (term != secondLineTerms.lastObject) {
            [addressStr appendString:@" - "];
        }
    }
    
    if (self.zipcode.length > 0) {
        [addressStr appendFormat:@"\nCEP: %@", self.zipcode];
    }
    
    return addressStr.copy;
}

- (NSString *)streetNameWithComplement {
        
    NSString *address = @"";
    
    LogInfo(@"Street i18n Old: %@", self.street);
    NSString *decodedStreetName = [self.street kv_decodeHTMLCharacterEntities];
    
    address = decodedStreetName;
    
    if (self.number && ![self.number isEqualToString:@""] && ![self.number isEqualToString:kAddressNoNumberDefaultValue]) {
        address = [NSString stringWithFormat:@"%@, %@", address, self.number];
    }
    else {
        address = [NSString stringWithFormat:@"%@, %@", address, kAddressNoNumberDefaultString];
    }
    
    if (![self.complement isEqualToString:@""]) {
        address = [NSString stringWithFormat:@"%@ - %@", address, self.complement];
    }
    
    return address;
}

- (NSString *)additionalInformation {
    NSString *addressComplement = [NSString stringWithFormat:@"%@ - %@ - %@", self.neighborhood, self.city, self.state];
    return addressComplement;
}

- (NSString *)formattedZipCode
{
    NSString *zipcode = @"";
    zipcode = self.zipcode;
    zipcode = [zipcode stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (zipcode.length == 8)
    {
        NSMutableString *mutableZipCode = [NSMutableString stringWithString:zipcode];
        [mutableZipCode insertString:@"-" atIndex:5];
        zipcode = mutableZipCode.copy;
    }
    
    return zipcode;
}

@end
