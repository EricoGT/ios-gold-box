//
//  ModelStaticHome.h
//  Walmart
//
//  Created by Marcelo Santos on 3/23/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "ModelCampaigns.h"
#import "ModelShowcases.h"

@interface ModelStaticHome : JSONModel

@property (strong, nonatomic) ModelCampaigns <Optional> *campaigns;
@property (strong, nonatomic) NSArray <Optional, ModelShowcases> *showcases;

@end
