//
//  ExtendedWarrantyBuilder.h
//  Walmart
//
//  Created by Renan on 6/2/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ExtendedWarrantyResumeModel;
@class ExtendedWarrantyDetail;

@interface ExtendedWarrantyBuilder : NSObject

+ (ExtendedWarrantyResumeModel *)baseWarranty;
+ (ExtendedWarrantyResumeModel *)cancelledWarranty;
+ (NSArray *)warrantiesListWithSize:(NSUInteger)size;

+ (ExtendedWarrantyDetail *)baseWarrantyDetail;



@end
