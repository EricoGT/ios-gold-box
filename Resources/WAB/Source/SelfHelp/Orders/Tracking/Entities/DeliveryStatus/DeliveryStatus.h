//
//  DeliveryStatus.h
//  Tracking
//
//  Created by Bruno Delgado on 4/22/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#define statusTypeWaitingPayment @"AGP"
#define statusTypeCanceled @"CAN"
#define statusTypeProcessing @"EAN"
#define statusTypeFinished @"ENT"
#define statusTypeDeclinedPayment @"PNA"

@protocol DeliveryStatus
@end

@interface DeliveryStatus : JSONModel

@property (nonatomic, strong) NSString<Optional> *statusId;
@property (nonatomic, strong) NSString<Optional> *code;
@property (nonatomic, strong) NSNumber<Optional> *group;
@property (nonatomic, strong) NSDate<Optional> *date;
@property (nonatomic, strong) NSDate<Optional> *shippingEstimateDate;
@property (nonatomic, strong) NSString<Optional> *statusDescription;
@property (nonatomic, strong) NSString<Optional> *descriptor;

+ (UIImage *)imageForStatus:(NSString *)statusDescription;

@end
