//
//  UTMIModel.m
//  Walmart
//
//  Created by Bruno Delgado on 10/15/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "UTMIModel.h"

@implementation UTMIModel

- (void)setSection:(NSString *)section cleanOtherFields:(BOOL)clean {
    _section = section;
    if (clean)
    {
        self.department = nil;
        self.category = nil;
        self.subcategory = nil;
        self.module = nil;
        self.modulePosition = nil;
        self.internalPosition = nil;
        self.moduleLabel = nil;
        self.internalLabel = nil;
    }
}

- (void)setModule:(NSString *)module {
    _module = module;
    self.modulePosition = nil;
    self.internalPosition = nil;
    self.moduleLabel = nil;
    self.internalLabel = nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"iOS|%@|%@|%@|%@|%@|%@|%@|%@|%@",
            [self cleanString:_section],
            [self cleanString:_department],
            [self cleanString:_category],
            [self cleanString:_subcategory],
            [self cleanString:_module],
            [self cleanString:_modulePosition],
            [self cleanString:_internalPosition],
            [self cleanString:_moduleLabel],
            [self cleanString:_internalLabel]];
}

- (NSString *)cleanString:(NSString *)str {
    if (str.length > 0)
    {
        str = [str stringByReplacingOccurrencesOfString:@"|" withString:@""];
        NSData *strData = [str dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        return [[NSString alloc] initWithData:strData encoding:NSASCIIStringEncoding];
    }
    else
    {
        return @"vazio";
    }
}

- (NSString *)typeFormatted {
    switch (_type) {
        case UTMITypeNav:
            return @"utminav";
            break;
        
        case UTMITypeBan:
            return @"utmiban";
            break;
            
        default:
            return @"utminav";
            break;
    }
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_section forKey:@"section"];
    [encoder encodeObject:_department forKey:@"department"];
    [encoder encodeObject:_category forKey:@"category"];
    [encoder encodeObject:_subcategory forKey:@"subcategory"];
    [encoder encodeObject:_module forKey:@"module"];
    [encoder encodeObject:_modulePosition forKey:@"modulePosition"];
    [encoder encodeObject:_internalPosition forKey:@"internalPosition"];
    [encoder encodeObject:_moduleLabel forKey:@"moduleLabel"];
    [encoder encodeObject:_internalLabel forKey:@"internalLabel"];
    [encoder encodeInteger:_type forKey:@"type"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        _section = [decoder decodeObjectForKey:@"section"];
        _department = [decoder decodeObjectForKey:@"department"];
        _category = [decoder decodeObjectForKey:@"category"];
        _subcategory = [decoder decodeObjectForKey:@"subcategory"];
        _module = [decoder decodeObjectForKey:@"module"];
        _modulePosition = [decoder decodeObjectForKey:@"modulePosition"];
        _internalPosition = [decoder decodeObjectForKey:@"internalPosition"];
        _moduleLabel = [decoder decodeObjectForKey:@"moduleLabel"];
        _internalLabel = [decoder decodeObjectForKey:@"internalLabel"];
        _internalLabel = [decoder decodeObjectForKey:@"internalLabel"];
        _type = [decoder decodeIntegerForKey:@"type"];
    }
    return self;
}


@end
