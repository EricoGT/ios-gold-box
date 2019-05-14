//
//  WBROrderManager.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 6/22/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^kOrderManagerRequestBankSlipSuccessBlock)(NSDictionary *bankSlipContent);
typedef void(^kOrderManagerRequestBankSlipFailureBlock)(NSError *error);

@interface WBROrderManager : NSObject

+ (void)getBankSlipWithOrder:(NSString *)orderNumber successBlock:(kOrderManagerRequestBankSlipSuccessBlock)successBlock failureBlock:(kOrderManagerRequestBankSlipFailureBlock)failureBlock;

@end
