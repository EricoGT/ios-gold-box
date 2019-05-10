//
//  FaceUser.h
//  Walmart
//
//  Created by Marcelo Santos on 12/4/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@interface FaceUser : JSONModel

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *idFacebook;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString <Optional> *tokenFacebook;

@property (strong, nonatomic) NSNumber *picture_height;
@property (strong, nonatomic) NSNumber *picture_width;
@property (strong, nonatomic) NSString *picture_url;
@property (strong, nonatomic) NSNumber *picture_silhouette;

@end
