//
//  ModelSkin.h
//  Walmart
//
//  Created by Marcelo Santos on 3/9/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "ModelSkinBgColor.h"
#import "ModelSkinTextShowcaseColor.h"

@interface ModelSkin : JSONModel

@property (strong, nonatomic) ModelSkinBgColor *bgColor;
@property (strong, nonatomic) ModelSkinTextShowcaseColor *textShowcaseColor;

@end
