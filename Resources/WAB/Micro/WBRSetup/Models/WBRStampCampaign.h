//
//  WBRStampCampaign.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 27/07/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@interface WBRStampCampaign : JSONModel

@property (strong, nonatomic) NSString<Optional> *imageUrl;
@property (strong, nonatomic) NSString<Optional> *title;
@property (strong, nonatomic) NSString<Optional> *disclaimer;

@end
