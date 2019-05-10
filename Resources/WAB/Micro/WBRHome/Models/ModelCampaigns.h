//
//  ModelCampaigns.h
//  Walmart
//
//  Created by Marcelo Santos on 3/23/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "ModelCampaignsTop.h"
#import "ModelCampaignsBottom.h"

@interface ModelCampaigns : JSONModel

@property (strong, nonatomic) NSArray <Optional, ModelCampaignsTop> *top;
@property (strong, nonatomic) NSArray <Optional, ModelCampaignsBottom> *bottom;

@end
