//
//  WBRReviewClientModel.h
//  Walmart
//
//  Created by Cássio Sousa on 04/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@interface WBRReviewClientModel : JSONModel

@property (strong, nonatomic) NSNumber *clientId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString<Optional> *city;
@property (copy, nonatomic) NSString<Optional> *state;

@end

