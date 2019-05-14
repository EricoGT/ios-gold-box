//
//  ServicesMessageModel.h
//  Walmart
//
//  Created by Renan Cargnin on 8/24/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@interface ServicesMessageModel : JSONModel

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *buttonOk;
@property (strong, nonatomic) NSString *buttonCancel;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSNumber *status;
 
@end
