//
//  UIUtils.m
//  Walmart
//
//  Created by Marcelo Santos on 3/15/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "UIUtils.h"

@implementation UIUtils

- (id) jsonMockLoginResponse {
    
    NSString *strLoginResponse = @"{\"token\":\"dc5cf315-6d39-4f28-983f-87b49196036b\",\"user\":{\"name\":\"Walmart Brasil Zil\",\"user\":\"wmteste@mobile.com\",\"has_document\":true,\"has_phone\":true}}";
    
    NSData *jsonData = [strLoginResponse dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    return jsonObjects;
}

@end
