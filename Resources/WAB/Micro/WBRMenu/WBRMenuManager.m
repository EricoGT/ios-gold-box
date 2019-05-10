//
//  WBRMenuManager.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 21/06/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRMenuManager.h"
#import "WBRConnection.h"
#import "DepartmentMenuItem.h"
#import "ShoppingMenuItem.h"
#import "CategoryMenuItemCount.h"

@implementation WBRMenuManager

+ (void)getAndUpdateMenuItemsWithSuccessBlock:(kMenuManagerSuccessBlock)successBlock failureBlock:(kMenuManagerFailure)failureBlock {
    
    NSString *menuURL = [OFUrls urlWithAppVersion:2 pathComponents:@[@"menu"]].absoluteString;
    NSString *urlString = [menuURL stringByAppendingString:@"?showAllDepartments=true"];

    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    NSDictionary <NSString *, NSString *> *headersDictionary = @{
                                                                 @"Content-Type": @"application/json",
                                                                 @"Accept": @"application/json",
                                                                 @"system": [dictInfo objectForKey:@"system"],
                                                                 @"version": [dictInfo objectForKey:@"version"]
                                                                 };
    
    LogInfo(@"[WBRMenuManager] getAndUpdateMenuItemsWithSuccessBlock:successBlock:failureBlock:");
    
    [[WBRConnection sharedInstance] GET:urlString headers:headersDictionary authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
        
        NSError *parserError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parserError];
        
        BOOL parseResultSuccess = NO;
        if (!parserError)
        {
            NSString *baseImagesString = [json objectForKey:@"baseImageUrl"];
            NSArray *mainDepartments = [json objectForKey:@"mainDepartments"];
            NSDictionary *baseShoppingDictionary = [json objectForKey:@"allDepartments"];
            
            NSError *mainDepartmentsError;
            NSArray *departments = [DepartmentMenuItem arrayOfModelsFromDictionaries:mainDepartments error:&mainDepartmentsError];
            
            if (!mainDepartmentsError) parseResultSuccess = YES;
            if (parseResultSuccess)
            {
                for (DepartmentMenuItem *item in departments)
                {
                    item.isAllDepartments = @(NO);
                    if (item.image)
                    {
                        item.image = [NSString stringWithFormat:@"%@%@", baseImagesString, item.image];
                    }
                    
                    if (item.imageSelected)
                    {
                        item.imageSelected = [NSString stringWithFormat:@"%@%@", baseImagesString, item.imageSelected];
                    }
                }
                
                NSArray *allDepartments = [NSArray new];
                if (baseShoppingDictionary)
                {
                    DepartmentMenuItem *allDepartmentsMenuItem = [DepartmentMenuItem new];
                    allDepartmentsMenuItem.name = baseShoppingDictionary[@"text"];
                    allDepartmentsMenuItem.imageName = @"ico_allshopping";
                    allDepartmentsMenuItem.isAllDepartments = @(YES);
                    allDepartmentsMenuItem.useHub = @NO;
                    
                    NSMutableArray *mutableDepartments = [[NSMutableArray alloc] initWithArray:departments];
                    [mutableDepartments addObject:allDepartmentsMenuItem];
                    
                    departments = mutableDepartments.copy;
                    NSArray *resultDepartments = baseShoppingDictionary[@"result"];
                    allDepartments = [ShoppingMenuItem arrayOfModelsFromDictionaries:resultDepartments error:&mainDepartmentsError];
                    
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
                }
                
                NSDictionary *userInfo = @{@"mainDepartments" : departments ?: @[], @"allDepartments" : allDepartments ?: @[]};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDepartments" object:nil userInfo:userInfo];
                
                WALMenuViewController *menu = [WALMenuViewController singleton];
                [menu refreshWithNewDepartments:userInfo];
            }
        }
    } failureBlock:^(NSError *error, NSData *failureData) {
        if (failureBlock)
            failureBlock(error);
    }];
}

+ (void)getMenuCategoriesWithCategoryId:(NSNumber *)categoryID successBlock:(kMenuManagerSuccessDataBlock)successBlock failureBlock:(kMenuManagerFailure)failureBlock {

    if (!categoryID) {
        if (failureBlock) {
            //Error Reason: Invalid category ID
            NSError *error = [WBRMenuManager errorWithCode:999 message:@"Invalid category ID"];
            failureBlock(error);
        }
    } else {
        NSString *menuURL = [[OFUrls new] getURLMenu];
        NSString *stringUrl = [menuURL stringByAppendingFormat:@"/%ld", (long)categoryID.integerValue];

        LogInfo(@"[WBRMenuManager] getMenuCategoriesWithCategoryId:catoryId:successBlock:failureBlock:");

        [[WBRConnection sharedInstance] GET:stringUrl headers:[WBRMenuManager headersDict] authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
            
            NSError *parserError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parserError];
            
            if (!parserError) {
                NSArray *categoryDicts = json[@"items"];
                NSArray *totalDicts = json[@"totais"];
                
                NSMutableArray *itemsMutable = [NSMutableArray new];
                NSMutableArray *totalsMutable = [NSMutableArray new];
                
                for (NSDictionary *categoryDict in categoryDicts) {
                    NSError *itemsParserError;
                    CategoryMenuItem *item = [[CategoryMenuItem alloc] initWithDictionary:categoryDict error:&itemsParserError];
                    
                    if (itemsParserError) {
                        LogInfo(@"%@", itemsParserError.localizedDescription);
                    } else if (item.url.length > 0) {
                        [itemsMutable addObject:item];
                    }
                }
                
                for (NSDictionary *totalDict in totalDicts)  {
                    NSError *totalParserError;
                    CategoryMenuItemCount *total = [[CategoryMenuItemCount alloc] initWithDictionary:totalDict error:&totalParserError];
                    
                    if (totalParserError) {
                        LogInfo(@"%@", totalParserError.localizedDescription);
                    } else {
                        [totalsMutable addObject:total];
                    }
                }
                
                if (itemsMutable.count > 0) {
                    if (successBlock) {
                        successBlock(itemsMutable.copy, totalsMutable.copy);
                    }
                } else if (itemsMutable.count == 0) {
                    //Error Reason: Items parser error
                    NSError *error = [WBRMenuManager errorWithCode:999 message:REQUEST_ERROR];
                    failureBlock(error);
                } else {
                    //Error Reason: Items parser error
                    NSError *error = [WBRMenuManager errorWithCode:999 message:@"Error parsing 'items' node from menu"];
                    failureBlock(error);
                }
            
            } else {
                //Error Reason:Root JSON parser error
                NSError *error = [WBRMenuManager errorWithCode:999 message:@"Error parsing root json categories from menu"];
                failureBlock(error);
            }
            
        } failureBlock:^(NSError *error, NSData *failureData) {
            NSError *errorMessage;
            if (error) {
                errorMessage = [WBRMenuManager errorWithCode:error.code message:error.localizedDescription];
            } else {
                errorMessage = [WBRMenuManager errorWithCode:error.code message:@"Request error"];
            }
            failureBlock(errorMessage);
        }];
        
    }
            
}

+ (NSDictionary *)headersDict {
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    NSDictionary <NSString *, NSString *> *headersDictionary = @{
                                                                 @"Content-Type": @"application/json",
                                                                 @"Accept": @"application/json",
                                                                 @"system": [dictInfo objectForKey:@"system"],
                                                                 @"version": [dictInfo objectForKey:@"version"]
                                                                 };
    return headersDictionary;
}

+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:@"Walmart.Menu" code:code userInfo:@{NSLocalizedDescriptionKey : message}];
}


@end
