//
//  WBRRatingModel.h
//  Walmart
//
//  Created by Guilherme Ferreira on 30/06/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@interface WBRRatingModel : JSONModel

@property (strong, nonatomic) NSNumber *ratingValue;
@property (strong, nonatomic) NSNumber *totalOfRatings;

@end
