//
//  TrackingSeller.h
//  Walmart
//
//  Created by Bruno Delgado on 10/8/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@interface TrackingSeller : JSONModel

@property (nonatomic, strong) NSString *sellerId;
@property (nonatomic, strong) NSString *sellerName;

@end
