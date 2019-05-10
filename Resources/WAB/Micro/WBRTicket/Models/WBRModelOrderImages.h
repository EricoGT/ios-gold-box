//
//  WBRModelOrderImages.h
//  Walmart
//
//  Created by Rafael Valim dos Santos on 15/03/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@protocol WBRModelOrderImages;

@interface WBRModelOrderImages : JSONModel

@property (strong, nonatomic) NSString *imageUrl;

@end
