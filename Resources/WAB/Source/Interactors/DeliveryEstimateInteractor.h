//
//  DeliveryEstimateInteractor.h
//  Walmart
//
//  Created by Renan Cargnin on 25/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryEstimateInteractor : NSObject

+ (NSString *)deliveryEstimateWithDays:(NSUInteger)days unit:(NSString *)unit;

@end
