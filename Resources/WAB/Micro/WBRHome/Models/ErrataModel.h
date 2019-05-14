//
//  ErrataModel.h
//  Walmart
//
//  Created by Renan Cargnin on 8/18/15.
//  Copyright (c) 2015 Walmart.com. All rights reserved.
//

#import "JSONModel.h"

@interface ErrataModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *urlImage;
@property (strong, nonatomic) NSString<Optional> *title;
@property (strong, nonatomic) NSString<Optional> *message;
@property (strong, nonatomic) NSString<Optional> *url;

@end
