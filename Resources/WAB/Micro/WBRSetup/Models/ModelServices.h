//
//  ModelServices.h
//  Walmart
//
//  Created by Marcelo Santos on 3/9/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@interface ModelServices : JSONModel

@property (strong, nonatomic) NSNumber *showDepartmentsOnMenu;
@property (strong, nonatomic) NSNumber *paymentByBankSlip;
@property (strong, nonatomic) NSNumber *isCouponEnabled;
@property (strong, nonatomic) NSNumber *showWarranties;
@property (strong, nonatomic) NSNumber *showDynamicHomeIos;
@property (strong, nonatomic) NSNumber <Optional> *showUtm;
@property (strong, nonatomic) NSNumber <Optional> *showTickets;
@property (strong, nonatomic) NSNumber <Optional> *isUserWriteReviewEnabled;
@property (strong, nonatomic) NSNumber <Optional> *isUserLikeReviewEnabled;
@property (strong, nonatomic) NSNumber <Optional> *masterCampaign;
@property (strong, nonatomic) NSNumber <Optional> *installCampaign;
@property (strong, nonatomic) NSNumber <Optional> *ticketsCommentsVisible;
@property (strong, nonatomic) NSNumber <Optional> *fileTicketsCommentsVisible;

@end
