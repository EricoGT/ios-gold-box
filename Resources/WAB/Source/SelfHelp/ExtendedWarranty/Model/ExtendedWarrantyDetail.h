//
//  ExtendedWarrantyDetail.h
//  Walmart
//
//  Created by Bruno Delgado on 5/29/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "AddressModel.h"

@protocol ExtendedWarrantyDetail
@end

typedef enum : NSUInteger {
    WarrantyStateNormal,
    WarrantyStateCancelling,
    WarrantyStateCanceled,
} WarrantyState;

@interface ExtendedWarrantyDetail : JSONModel

@property (nonatomic, strong) NSString *ticketNumber;
@property (nonatomic, strong) NSNumber *orderNumber;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSDate<Optional> *startDate;
@property (nonatomic, strong) NSDate<Optional> *expirationDate;
@property (nonatomic, strong) NSDate<Optional> *enrollmentDate;
@property (nonatomic, strong) NSDate<Optional> *rescissionDate;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSString *urlImage;
@property (nonatomic, strong) NSNumber *cancelled;
@property (nonatomic, strong) NSNumber *cancelable;
@property (nonatomic, strong) NSString<Optional> *rescissionPdf;
@property (nonatomic, strong) NSString<Optional> *ticketPdf;
@property (nonatomic, strong) NSString<Optional> *enrollmentPdf;
@property (nonatomic, strong) AddressModel *address;
@property (nonatomic, assign) NSNumber<Ignore> *state;

@end
