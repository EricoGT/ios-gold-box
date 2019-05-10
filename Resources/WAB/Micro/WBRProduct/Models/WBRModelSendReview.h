//
//  WBRModelSendReview.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 16/05/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@interface WBRModelSendReview : JSONModel

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *rating;
@property BOOL showEmail;

@end
