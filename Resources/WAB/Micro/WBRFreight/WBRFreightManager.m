//
//  WBRFreightManager.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 27/08/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRFreightManager.h"
#import "WBRConnection.h"
#import "WBRUTM.h"
#import "Freight.h"

// MOCK Control---------------------------------------
#if defined CONFIGURATION_DebugCalabash || CONFIGURATION_TestWm
#define USE_MOCK_FREIGHT YES
#else
#define USE_MOCK_FREIGHT NO
#endif
// ---------------------------------------------------

@implementation WBRFreightManager

+ (void)getFreightWithZipcode:(NSString *)zipCode standardSku:(NSString *)sku success:(kFreightManagerSuccessBlock)successBlock failure:(kFreightManagerFailureBlock)failureBlock {
    
    NSString *log = [NSString stringWithFormat:@"[WBRFreightManager] getFreightWithZipcode: %@ standartSku: %@", zipCode, sku];

    if (USE_MOCK_FREIGHT) {
        LogInfo(@">>> USE MOCK FREIGHT: %@", log);

        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mockShippingPayment" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSError *parseError;
        NSArray *freights = [Freight arrayOfModelsFromData:jsonData error:&parseError];
        
        if ((successBlock) && (!parseError)) {
            successBlock(freights);
        }
        
    } else {
        LogInfo(@"%@", log);

        NSString *stringUrl = [NSString stringWithFormat:@"%@/postalCode=%@&sku=%@",[[OFUrls new] getURLFreight], zipCode, sku];
        stringUrl = [WBRUTM addUTMQueryParameterTo:[NSURL URLWithString:stringUrl]].absoluteString;
        
        NSDictionary *dictInfo = [OFSetup infoAppToServer];
        NSDictionary *headerDictionary = @{
                                           @"Content-Type": @"application/json",
                                           @"Accept": @"application/json",
                                           @"system" : dictInfo[@"system"],
                                           @"version" : dictInfo[@"version"]
                                           };
        
        [[WBRConnection sharedInstance] GET:stringUrl headers:headerDictionary authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
            NSError *freightParserError;
            NSMutableArray *freights = [Freight arrayOfModelsFromData:data error:&freightParserError];
            if (!freightParserError) {
                if (successBlock)
                    successBlock(freights);
            } else {
                failureBlock(freightParserError);
            }
            
        } failureBlock:^(NSError *error, NSData *failureData) {
            if (failureBlock)
                failureBlock(error);
        }];
    }
}

@end
