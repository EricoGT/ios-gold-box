//
//  DeepLinkAction.h
//  Walmart
//
//  Created by Bruno Delgado on 10/2/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    DeepLinkTypeProductId,
    DeepLinkTypeProductSku,
    DeepLinkTypeSearch
} DeepLinkType;

@interface DeepLinkAction : NSObject

@property (nonatomic, assign) DeepLinkType type;
@property (nonatomic, strong) NSString *parameter;

@end
