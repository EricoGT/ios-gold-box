//
//  OFCartTemp.m
//  Ofertas
//
//  Created by Marcelo Santos on 15/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFCartTemp.h"
#import "OFAddressTemp.h"
#import "OFCartUpdated.h"

@implementation OFCartTemp

static NSDictionary *dictProduct;
static float lastValueUpdated;
static float lastValueWithShipmentUpdated;
static CardProductsResume *viewCardProducts;

- (void) assignCardProducts:(CardProductsResume *) viewProducts {
    
    viewCardProducts = viewProducts;
}

- (CardProductsResume *) getViewCardProducts {
    
    return viewCardProducts;
}

- (void) assignProductDictionary:(NSDictionary *) dict {
    
    dictProduct = [[NSDictionary alloc] initWithDictionary:dict];
}

- (NSDictionary *) getProductDictionary {
    
    return dictProduct;
}

- (void) lastUpdatedTotal:(float)valueUpdated {
    
    lastValueUpdated = valueUpdated;
}

- (float) getLastUpdatedTotal {
    
    return lastValueUpdated;
}

- (void) lastUpdatedTotalWithShipments:(float)valueWithShipment {
    
    lastValueWithShipmentUpdated = valueWithShipment;
}

- (float) getLastUpdatedTotalWithShipment {
    
    return lastValueWithShipmentUpdated;
}


+ (NSArray *) getAllProductsFromCartApp {
    
    MDSSqlite *mds = [[MDSSqlite alloc] init];
    NSArray *arrProducts = [mds getCart];
    LogInfo(@"Products in Cart: %@", arrProducts);
    
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
    
    for (int i=0;i<[arrProducts count];i++) {
        
        NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
        
        NSDictionary *dictProd = [arrProducts objectAtIndex:i];
        
        NSString *descProduct = [dictProd objectForKey:@"descProduct"];
        LogInfo(@"Desc. product [%i]: %@", i+1, descProduct);
        BOOL extendProduct = [[dictProd objectForKey:@"extendProduct"] boolValue];
        LogInfo(@"Extended Warranty: %i", extendProduct);
        NSString *extendTime = [dictProd objectForKey:@"extendTime"];
        LogInfo(@"Extende Time: %@", extendTime);
        NSString *extendedValue = [dictProd objectForKey:@"extendedValue"];
        LogInfo(@"Extended Value: %@", extendedValue);
        NSString *idProduct = [dictProd objectForKey:@"idProduct"];
        LogInfo(@"Id Product: %@", idProduct);
        NSString *imgProduct = [dictProd objectForKey:@"imgProduct"];
        LogInfo(@"Image Product: %@", imgProduct);
        NSString *qtyProduct = [dictProd objectForKey:@"qtyProduct"];
        LogInfo(@"Qty Product: %@", qtyProduct);
        NSString *savePercentage = [dictProd objectForKey:@"savePercentage"];
        LogInfo(@"Save Percentage: %@", savePercentage);
//        NSString *sku = [dictProd objectForKey:@"sku"];
        int sku = [[dictProd objectForKey:@"sku"] intValue];
        LogInfo(@"SKU: %i", sku);
        NSString *standardSku = [dictProd objectForKey:@"standardSku"];
        LogInfo(@"Standard SKU: %@", standardSku);
        NSString *valueProduct = [dictProd objectForKey:@"valueProduct"];
        LogInfo(@"Value Product: %@", valueProduct);
        NSString *extendId = [dictProd objectForKey:@"extendId"];
        LogInfo(@"Extend Id Product: %@", extendId);
        LogInfo(@"=======================================================================================");
        
        [dictTemp setObject:[NSNumber numberWithInt:sku] forKey:@"sku"];
        [dictTemp setObject:valueProduct forKey:@"valueProduct"];
        
        [arrTemp addObject:dictTemp];
        
        dictTemp = nil;
    }
    
    mds = nil;
    
    NSArray *arrTp = [NSArray arrayWithArray:arrTemp];
    arrTemp = nil;

    return arrTp;
}

- (NSString *) getJsonProducts {
    
    NSArray *arrTemp = [self getAndParseCart];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrTemp
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = @"";
    
    if (! jsonData) {
        LogInfo(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        LogInfo(@"Json String: %@",jsonString);
    }
    
    OFAddressTemp *oa = [[OFAddressTemp alloc] init];
    NSDictionary *dictAddress = [oa getAddressDictionary];
    LogInfo(@"Dict Address: %@", dictAddress);
    
    NSString *zipCode = [dictAddress objectForKey:@"zipCode"];
    zipCode = [zipCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    zipCode = [zipCode stringByReplacingOccurrencesOfString:@"-" withString:@""];
    LogInfo(@"Zip Code: %@", zipCode);
    
    NSString *jsonPackage;
    if (zipCode == NULL) {
            jsonPackage = [NSString stringWithFormat:@"{\
                           \"clientProfileData\":{\
                           },\
                           \"items\":\
                           %@\
                           }",  jsonString];
    }
    else {
        jsonPackage = [NSString stringWithFormat:@"{\
                       \"clientProfileData\":{\
                        },\
                        \"postalCode\":\"%@\",\
                        \"items\":\
                        %@\
                        }", zipCode, jsonString];
    }
    
    jsonPackage = [jsonPackage stringByReplacingOccurrencesOfString:@";" withString:@","];
    jsonPackage = [jsonPackage stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
    jsonPackage = [jsonPackage stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
    jsonPackage = [jsonPackage stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    
    LogInfo(@"String Json: %@", jsonPackage);
    
    return jsonPackage;
}

- (NSString *) getJsonProductsToShipping {
        
    NSArray *arrTemp = [self getAndParseCart];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrTemp
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData) {
        LogInfo(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        LogInfo(@"Json String: %@",jsonString);
    }
    
    
    NSString *jsonPackage = [NSString stringWithFormat:@"{\
                       \"clientProfileData\":{\
                       },\
                       \"items\":\
                       %@\
                       }",  jsonString];
    
    jsonPackage = [jsonPackage stringByReplacingOccurrencesOfString:@";" withString:@","];
    
    jsonPackage = [jsonPackage stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
    jsonPackage = [jsonPackage stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
    jsonPackage = [jsonPackage stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    
    LogInfo(@"String Json products to shipping: %@", jsonPackage);
    
    return jsonPackage;
}


- (NSString *) getJsonProductsSimple {
        
    OFCartUpdated *upd = [[OFCartUpdated alloc] init];
    NSArray *arrProducts = [upd getAllProductsUpdated];
    LogInfo(@"Products in Cart temp: %@", arrProducts);
    
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
    
    for (int i=0;i<[arrProducts count];i++) {
        
        NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
        
        NSDictionary *dictProd = [arrProducts objectAtIndex:i];
        //        [arrTemp addObject:dictProd];
        
        LogInfo(@"Desc. product [%i]: %@", i+1, [dictProd objectForKey:@"descProduct"]);
        LogInfo(@"Extended Warranty: %i", [[dictProd objectForKey:@"extendProduct"] boolValue]);
        LogInfo(@"Extende Time: %@", [dictProd objectForKey:@"extendTime"]);
        NSString *extendedValue = [dictProd objectForKey:@"extendedValue"];
        LogInfo(@"Extended Value: %@", extendedValue);
        LogInfo(@"Id Product: %@", [dictProd objectForKey:@"idProduct"]);
        LogInfo(@"Image Product: %@", [dictProd objectForKey:@"imgProduct"]);
        int qtyProduct = [[dictProd objectForKey:@"qtyProduct"] intValue];
        LogInfo(@"Qty Product: %i", qtyProduct);
        LogInfo(@"Save Percentage: %@", [dictProd objectForKey:@"savePercentage"]);
        int sku = [[dictProd objectForKey:@"sku"] intValue];
        LogInfo(@"SKU: %i", sku);
        LogInfo(@"Standard SKU: %@", [dictProd objectForKey:@"standardSku"]);
        NSString *valueProduct = [dictProd objectForKey:@"valueProduct"];
        LogInfo(@"Value Product: %@", valueProduct);
        NSString *extendId = [dictProd objectForKey:@"extendId"];
        LogInfo(@"Extend Id Product: %@", extendId);
        
//        float extValue = [extendedValue floatValue];
        
        extendedValue = [extendedValue stringByReplacingOccurrencesOfString:@"." withString:@""];
        int extendedWarrantyValue = [extendedValue intValue];
        
        NSString *strServices = [NSString stringWithFormat:@"[{'id':%@, 'quantity':%i, 'price':%i}]", extendId, qtyProduct, extendedWarrantyValue];
        LogInfo(@"=======================================================================================");
        
        [dictTemp setObject:[NSNumber numberWithInt:sku] forKey:@"id"];
        //        [dictTemp setObject:@"1" forKey:@"seller"];
        [dictTemp setObject:[NSNumber numberWithInt:qtyProduct] forKey:@"quantity"];
//        float valProd = [valueProduct floatValue] - extValue;
//        valueProduct = [NSString stringWithFormat:@"%.2f", valProd];
        valueProduct = [valueProduct stringByReplacingOccurrencesOfString:@"." withString:@""];
        [dictTemp setObject:valueProduct forKey:@"price"];
        
        if (![extendId isEqualToString:@""] && extendId != NULL && ![extendId isEqualToString:@"(null)"]) {
            [dictTemp setObject:strServices forKey:@"services"];
        }
        
        [arrTemp addObject:dictTemp];
        
    }
    
    LogInfo(@"ArrTemp Simple: %@", arrTemp);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrTemp
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData) {
        LogInfo(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        LogInfo(@"Json String: %@",jsonString);
    }
    
    
    NSString *jsonPackage = [NSString stringWithFormat:@"\
                             \"items\":\
                             %@\
                             ", jsonString];
    
    jsonPackage = [jsonPackage stringByReplacingOccurrencesOfString:@";" withString:@","];
    
    jsonPackage = [jsonPackage stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
    jsonPackage = [jsonPackage stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
    jsonPackage = [jsonPackage stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    
    LogInfo(@"String Json products to shipping: %@", jsonPackage);
    
    return jsonPackage;
}


- (NSArray *) getAndParseCart {
    
    MDSSqlite *mds = [[MDSSqlite alloc] init];
    NSArray *arrProducts = [mds getCart];
    LogInfo(@"Products in Cart Parse: %@", arrProducts);
    
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
    
    for (int i=0;i<[arrProducts count];i++) {
        
        NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
        
        NSDictionary *dictProd = [arrProducts objectAtIndex:i];
        //        [arrTemp addObject:dictProd];
        
        NSString *descProduct = [dictProd objectForKey:@"descProduct"];
        LogInfo(@"Desc. product [%i]: %@", i+1, descProduct);
        BOOL extendProduct = [[dictProd objectForKey:@"extendProduct"] boolValue];
        LogInfo(@"Extended Warranty: %i", extendProduct);
        NSString *extendTime = [dictProd objectForKey:@"extendTime"];
        LogInfo(@"Extende Time: %@", extendTime);
        NSString *extendedValue = [dictProd objectForKey:@"extendedValue"];
        LogInfo(@"Extended Value: %@", extendedValue);
        NSString *idProduct = [dictProd objectForKey:@"idProduct"];
        LogInfo(@"Id Product: %@", idProduct);
        NSString *imgProduct = [dictProd objectForKey:@"imgProduct"];
        LogInfo(@"Image Product: %@", imgProduct);
        NSString *qtyProduct = [dictProd objectForKey:@"qtyProduct"];
        LogInfo(@"Qty Product: %@", qtyProduct);
        NSString *savePercentage = [dictProd objectForKey:@"savePercentage"];
        LogInfo(@"Save Percentage: %@", savePercentage);
        //        NSString *sku = [dictProd objectForKey:@"sku"];
        int sku = [[dictProd objectForKey:@"sku"] intValue];
        LogInfo(@"SKU: %i", sku);
        NSString *standardSku = [dictProd objectForKey:@"standardSku"];
        LogInfo(@"Standard SKU: %@", standardSku);
        NSString *valueProduct = [dictProd objectForKey:@"valueProduct"];
        LogInfo(@"Value Product: %@", valueProduct);
        NSString *extendId = [dictProd objectForKey:@"extendId"];
        LogInfo(@"Extend Id Product: %@", extendId);
        
        NSString *strServices = [NSString stringWithFormat:@"[{'id':%@, 'quantity':%@}]", extendId, qtyProduct];
        LogInfo(@"=======================================================================================");
        
        [dictTemp setObject:[NSNumber numberWithInt:sku] forKey:@"id"];
        //        [dictTemp setObject:@"1" forKey:@"seller"];
        [dictTemp setObject:qtyProduct forKey:@"quantity"];
        
        if (![extendId isEqualToString:@""] && extendId != NULL && ![extendId isEqualToString:@"(null)"]) {
            [dictTemp setObject:strServices forKey:@"services"];
        }
        
        [arrTemp addObject:dictTemp];
        
    }

    return arrTemp;
}

+ (NSString *)convertToXMLEntities:(NSString *)myString
{
    NSMutableString *temp = [myString mutableCopy];
    
    [temp replaceOccurrencesOfString:@"&amp;"
                          withString:@"&"
                             options:0
                               range:NSMakeRange(0, [temp length])];
    
    [temp replaceOccurrencesOfString:@"&lt;"
                          withString:@"<"
                             options:0
                               range:NSMakeRange(0, [temp length])];
    
    [temp replaceOccurrencesOfString:@"&gt;"
                          withString:@">"
                             options:0
                               range:NSMakeRange(0, [temp length])];
    
    [temp replaceOccurrencesOfString:@"&quot;"
                          withString:@"\""
                             options:0
                               range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&apos;"
                          withString:@"'"
                             options:0
                               range:NSMakeRange(0, [temp length])];
    
    return temp;
}

@end
