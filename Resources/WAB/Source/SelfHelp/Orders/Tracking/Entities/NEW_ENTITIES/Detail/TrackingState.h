//
//  TrackingState.h
//  Walmart
//
//  Created by Bruno Delgado on 10/10/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@interface TrackingState : JSONModel

@property (nonatomic, strong) NSString<Optional> *stateID;
@property (nonatomic, strong) NSString<Optional> *code;

@end
