//
//  WBRURLHelper.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 10/24/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBRURLHelper : NSObject

+ (NSDictionary *)getParameterFromDeepLinkURL:(NSString *)deepLinkURL;

@end
