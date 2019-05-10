//
//  SetupModel.h
//  Walmart
//
//  Created by Marcelo Santos on 3/9/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "ModelAlert.h"
#import "ModelBaseImages.h"
#import "ModelServices.h"
#import "ModelSkin.h"
#import "ModelSplash.h"
#import "ModelErrata.h"
#import "ModelBanner.h"
#import "WBRStampCampaign.h"
#import "WBRInstallCampaign.h"

@interface ModelSetup : JSONModel

@property (strong, nonatomic) ModelAlert <Optional> *alert;
@property (strong, nonatomic) ModelBaseImages *baseImages;
@property (strong, nonatomic) ModelServices *services;
@property (strong, nonatomic) ModelSkin <Optional> *skin;
@property (strong, nonatomic) ModelSplash <Optional> *splash;
@property (strong, nonatomic) ModelErrata <Optional> *errata;
@property (strong, nonatomic) ModelBanner <Optional> *banners;
@property (strong, nonatomic) NSString<Optional> *aboutInfo;
@property (strong, nonatomic) WBRStampCampaign<Optional> *stampCampaign;
@property (strong, nonatomic) WBRInstallCampaign<Optional> *installCampaign;

@end
