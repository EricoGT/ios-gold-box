//
//  HubCategory.h
//  Walmart
//
//  Created by Renan on 2/5/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseModel.h"

@protocol HubCategory
@end

@interface HubCategory : WMBaseModel

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *searchParameter;
@property (assign, nonatomic) BOOL useHub;

@end
