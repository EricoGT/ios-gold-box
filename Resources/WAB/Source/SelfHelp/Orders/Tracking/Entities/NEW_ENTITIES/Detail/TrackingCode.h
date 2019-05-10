//
//  TrackingCode.h
//  Walmart
//
//  Created by Bruno Delgado on 2/4/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "Code.h"

@protocol TrackingCode
@end

@interface TrackingCode : JSONModel

@property (nonatomic, strong) NSString<Optional> *carrierCode;
@property (nonatomic, strong) NSString<Optional> *carrierName;
@property (nonatomic, strong) NSArray<Code> *codes;

@end
