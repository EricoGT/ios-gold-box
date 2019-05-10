//
//  WBRContactRequestExchangeModel.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 3/19/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

#import "ContactRequestExchangeFieldModel.h"
#import "WBRContactRequestCustomerModel.h"
#import "WBRContactRequestPaymentModel.h"
#import "WBRContactRequestExchangeTypeModel.h"

@interface WBRContactRequestExchangeModel : JSONModel

@property (strong, nonatomic) NSArray<WBRContactRequestExchangeTypeModel> *fields;
@property (strong, nonatomic) WBRContactRequestCustomerModel *customer;
@property (strong, nonatomic) NSArray<WBRContactRequestPaymentModel> *paymentMethods;
@property (strong, nonatomic) NSNumber *canceled;
@property (strong, nonatomic) NSNumber *allowCreateBankSlipTicket;
@property (strong, nonatomic) NSNumber *approvedPayment;
@property (strong, nonatomic) NSNumber *expiredBankSlip;

@end

