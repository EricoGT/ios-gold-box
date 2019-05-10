//
//  Code.h
//  Walmart
//
//  Created by Bruno Delgado on 2/4/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol Code
@end

@interface Code : JSONModel

@property (nonatomic, strong) NSString<Optional> *codeId;
@property (nonatomic, strong) NSString<Optional> *url;

@end
