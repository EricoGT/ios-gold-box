//
//  WBRModelReviewsClient.h
//  Walmart
//
//  Created by Cássio Sousa on 03/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@interface WBRModelReviewClient : JSONModel

@property (strong, nonatomic) NSNumber<Optional> *clientId;
@property (copy, nonatomic) NSString<Optional> *name;
@property (copy, nonatomic) NSString<Optional> *email;
@property (copy, nonatomic) NSString<Optional> *city;
@property (copy, nonatomic) NSString<Optional> *state;

@end
