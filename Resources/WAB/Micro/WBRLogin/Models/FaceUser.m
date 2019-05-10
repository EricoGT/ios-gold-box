//
//  FaceUser.m
//  Walmart
//
//  Created by Marcelo Santos on 12/4/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "FaceUser.h"

@implementation FaceUser

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"picture_height"     : @"picture.data.height",
                                                                  @"picture_width"      : @"picture.data.width",
                                                                  @"picture_url"        : @"picture.data.url",
                                                                  @"picture_silhouette" : @"picture.data.is_silhouette",
                                                                  @"idFacebook"         : @"id",
                                                                  @"tokenFacebook"      : @"accessToken" }];
}


@end
