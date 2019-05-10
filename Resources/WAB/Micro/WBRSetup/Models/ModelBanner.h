//
//  ModelBanner.h
//  Walmart
//
//  Created by Marcelo Santos on 4/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "ModelBannerContent.h"

@interface ModelBanner : JSONModel

@property (strong, nonatomic) NSArray <ModelBannerContent, Optional> *top;
@property (strong, nonatomic) NSArray <ModelBannerContent, Optional> *bottom;

@end
