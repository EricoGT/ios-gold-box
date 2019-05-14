//
//  ExtendedWarrantyResumeModel.h
//  Walmart
//
//  Created by Renan Cargnin on 5/28/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@interface ExtendedWarrantyResumeModel : JSONModel

@property (nonatomic, strong) NSString *ticketNumber;
@property (nonatomic, strong) NSNumber *orderNumber;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSDate<Optional> *startDate;
@property (nonatomic, strong) NSDate<Optional> *expirationDate;
@property (nonatomic, strong) NSDate *enrollmentDate;
@property (nonatomic, strong) NSDate<Optional> *rescissionDate;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSString *urlImage;
@property (nonatomic, strong) NSNumber *cancelled;

@end
