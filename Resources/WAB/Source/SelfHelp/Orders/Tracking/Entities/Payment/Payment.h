//
//  Payment.h
//  Tracking
//
//  Created by Bruno Delgado on 4/22/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

@protocol Payment
@end

@interface Payment : JSONModel

@property (nonatomic, strong) NSNumber<Optional> *value;
@property (nonatomic, strong) NSString<Optional> *status;
@property (nonatomic, strong) NSString<Optional> *paymentType;
@property (nonatomic, assign) NSNumber<Optional> *current;
@property (nonatomic, assign) NSString<Optional> *cardHolder;
@property (nonatomic, assign) NSString<Optional> *flag;
@property (nonatomic, assign) NSString<Optional> *name;
@property (nonatomic, assign) NSString<Optional> *last4Digits;
@property (nonatomic, assign) NSNumber<Optional> *installments;
@property (nonatomic, assign) NSNumber<Optional> *parcelValue;
@property (nonatomic, strong) NSDate<Optional> *date;
@property (nonatomic, strong) NSString<Optional> *paymentDescription;

@end
