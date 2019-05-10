//
//  ModelSplash.h
//  Walmart
//
//  Created by Marcelo Santos on 3/9/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "ModelSplashBgColor.h"

@interface ModelSplash : JSONModel

@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) ModelSplashBgColor *bgColor;

@end
