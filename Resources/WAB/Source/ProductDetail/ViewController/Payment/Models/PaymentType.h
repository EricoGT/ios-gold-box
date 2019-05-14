//
//  PaymentType.h
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/19/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol PaymentType
@end

@interface PaymentType : JSONModel
@property (nonatomic, strong) NSNumber *_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *idFile;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *sigePaymentTypeId;
@property (nonatomic, strong) NSNumber *sigeBankId;
@property (nonatomic, assign) BOOL credit;
@end
