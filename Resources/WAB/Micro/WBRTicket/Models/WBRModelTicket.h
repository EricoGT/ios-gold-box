//
//  WBRModelTicket.h
//  Walmart
//
//  Created by Rafael Valim dos Santos on 15/03/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "WBRModelOrderImages.h"
#import "WBRModelTicketSeller.h"

@protocol WBRModelTicket;

@interface WBRModelTicket : JSONModel

@property (strong, nonatomic) NSNumber *ticketId;
@property (strong, nonatomic) NSString *creationDate;
@property (strong, nonatomic) NSString *ticketDescription;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString <Optional> *dueDate;
@property (strong, nonatomic) NSString <Optional> *orderId;
@property (assign, nonatomic) BOOL canBeReopened;
@property (strong, nonatomic) NSNumber <Optional> *commentsVisible;
@property (strong, nonatomic) NSArray <WBRModelOrderImages, Optional> *orderImages;
@property (strong, nonatomic) WBRModelTicketSeller <Optional> *seller;

- (BOOL)isTicketOpen;

@end
