//
//  OFSkinInfo.h
//  Ofertas
//
//  Created by Marcelo Santos on 9/22/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFSkinInfo : NSObject {
    
    NSDictionary *skinDict;
}

- (void) assignSkinDictionary:(NSDictionary *) dict;
+ (NSDictionary *) getSkinDictionary;
+ (double)currentMemoryUsage;


@end
