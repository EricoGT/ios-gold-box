//
//  WBRInstallCampaign.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 27/12/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@interface WBRInstallCampaign : JSONModel

@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSNumber *minValue;
@property (strong, nonatomic) NSString *descriptionText;

@end
