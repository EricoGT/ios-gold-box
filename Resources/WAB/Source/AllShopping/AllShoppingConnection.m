//
//  AllShoppingConnection.m
//  Walmart
//
//  Created by Renan on 7/21/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "AllShoppingConnection.h"

#import "DepartmentMenuItem.h"
#import "ShoppingMenuItem.h"

@implementation AllShoppingConnection

- (void)loadAllShoppingWithCompletionBlock:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    OFUrls *urls = [OFUrls new];
    NSURL *url = [NSURL URLWithString:[[urls getURLMenu] stringByAppendingString:@"?showAllDepartments=true"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self run:request authenticate:NO completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        NSString *baseImagesString = [json objectForKey:@"baseImageUrl"];
        NSDictionary *allDepartmentsDict = json[@"allDepartments"];
        
        NSArray *allDepartments;
        if (allDepartmentsDict)
        {
            DepartmentMenuItem *allDepartmentsMenuItem = [DepartmentMenuItem new];
            allDepartmentsMenuItem.name = allDepartmentsDict[@"text"];
            allDepartmentsMenuItem.imageName = @"ico_allshopping";
            allDepartmentsMenuItem.isAllDepartments = @(YES);
            allDepartmentsMenuItem.useHub = @NO;
            
            NSError *mainDepartmentsError;
            NSArray *resultDepartments = allDepartmentsDict[@"result"];
            allDepartments = [ShoppingMenuItem arrayOfModelsFromDictionaries:resultDepartments error:&mainDepartmentsError];
            
            if (allDepartments) {
                for (ShoppingMenuItem *shoppingItem in allDepartments)
                {
                    for (DepartmentMenuItem *item in shoppingItem.departments)
                    {
                        item.isAllDepartments = @NO;
                        if (item.image)
                        {
                            item.image = [NSString stringWithFormat:@"%@%@", baseImagesString, item.image];
                        }
                    }
                }
                
                if (allDepartments.count > 0) {
                    if (success) success(allDepartments);
                }
                else {
                    if (failure) failure([WMBaseConnection errorWithMessage:ERROR_CONNECTION_DATA_ERROR_JSON]);
                }
            }
            else {
                LogError *log = [LogError new];
                log.absolutRequest = url.absoluteString;
                log.code = [NSString stringWithFormat:@"%li", (long)response.statusCode];
                log.data = [NSKeyedArchiver archivedDataWithRootObject:json];
                log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
                log.screen = @"All Shopping";
                log.fragment = @"loadAllShoppingWithCompletionBlock:";
                [[OFLogService new] sendLog:log];
                
                if (failure) failure([WMBaseConnection errorWithMessage:ERROR_CONNECTION_DATA_ERROR_JSON]);
            }
        }
        else {
            LogError *log = [LogError new];
            log.absolutRequest = url.absoluteString;
            log.code = [NSString stringWithFormat:@"%li", (long)response.statusCode];
            log.data = [NSKeyedArchiver archivedDataWithRootObject:json];
            log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
            log.screen = @"All Shopping";
            log.fragment = @"loadAllShoppingWithCompletionBlock:";
            [[OFLogService new] sendLog:log];
            
            if (failure) failure([WMBaseConnection errorWithMessage:ERROR_CONNECTION_DATA_ERROR_JSON]);
        }
        
    } failure:^(NSError *error, NSData *data) {
        LogError *log = [LogError new];
        log.absolutRequest = url.absoluteString;
        log.code = [NSString stringWithFormat:@"%li", (long)error.code];
        log.data = data;
        log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
        log.screen = @"All Shopping";
        log.fragment = @"loadAllShoppingWithCompletionBlock:";
        [[OFLogService new] sendLog:log];
        
        if (failure) failure([WMBaseConnection errorWithMessage:ERROR_CONNECTION_DATA_ERROR_JSON]);
    }];
}

@end
