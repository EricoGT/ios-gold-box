//
//  ServicesModel.h
//  Walmart
//
//  Created by Renan Cargnin on 8/18/15.
//  Copyright (c) 2015 Walmart.com. All rights reserved.
//

#import "JSONModel.h"

#import "ServicesMessageModel.h"

@interface ServicesModel : JSONModel

@property (assign, nonatomic) BOOL tracking;
@property (assign, nonatomic) BOOL showDepartmentsOnMenu;
@property (assign, nonatomic) BOOL paymentByBankSlip;
@property (assign, nonatomic) BOOL showWarranties;
@property (assign, nonatomic) BOOL isCouponEnabled;
@property (assign, nonatomic) BOOL masterCampaign;

@property (strong, nonatomic) ServicesMessageModel<Optional> *message;

@end
