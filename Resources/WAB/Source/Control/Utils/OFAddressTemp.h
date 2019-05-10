//
//  OFAddressTemp.h
//  Ofertas
//
//  Created by Marcelo Santos on 27/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFAddressTemp : NSObject

- (void) assignAddressDictionary:(NSDictionary *) dict;
- (NSDictionary *) getAddressDictionary;

@property (nonatomic, strong) NSString *street;

@end
