//
//  ExtendedWarrantyBuilder.m
//  Walmart
//
//  Created by Renan on 6/2/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ExtendedWarrantyBuilder.h"
#import "ExtendedWarrantyResumeModel.h"
#import "ExtendedWarrantyDetail.h"

@implementation ExtendedWarrantyBuilder

+ (ExtendedWarrantyResumeModel *)baseWarranty {
    NSDictionary *warrantyDict = @{@"ticketNumber" : @290700000000122,
                                   @"orderNumber" : @14089746,
                                   @"description" : @"Garantia estendida 1 ano.",
                                   @"startDate" : @1436756400000,
                                   @"expirationDate" : @1468378800000,
                                   @"enrollmentDate" : @1421114400000,
                                   @"rescissionDate" : @1421114400000,
                                   @"value" : @95.12,
                                   @"urlImage" : @"http://static-cms.waldev.com.br/imgres/arquivos/ids/2840442",
                                   @"cancelled" : @NO};
    
    ExtendedWarrantyResumeModel *warranty = [[ExtendedWarrantyResumeModel alloc] initWithDictionary:warrantyDict error:nil];
    return warranty;
}

+ (ExtendedWarrantyResumeModel *)cancelledWarranty {
    ExtendedWarrantyResumeModel *warranty = [ExtendedWarrantyBuilder baseWarranty];
    warranty.cancelled = @YES;
    return warranty;
}

+ (NSArray *)warrantiesListWithSize:(NSUInteger)size {
    NSMutableArray *warranties = [NSMutableArray new];
    ExtendedWarrantyResumeModel *baseWarranty = [ExtendedWarrantyBuilder baseWarranty];
    for (int i = 0; i < size; i++) {
        [warranties addObject:baseWarranty];
    }
    return warranties.copy;
}

+ (ExtendedWarrantyDetail *)baseWarrantyDetail
{
    NSDictionary *country = @{@"name" : @"Brasil"};
    NSDictionary *state = @{@"id" : @"São Paulo"};
    
    NSDictionary *address = @{@"country" : country,
                              @"state" : state,
                              @"city": @"São Paulo",
                              @"zipcode": @"02310140",
                              @"street": @"Rua Caure",
                              @"number": @"65",
                              @"complement": @"",
                              @"neighborhood": @"Vila Mazzei",
                              @"defaultAddress": @(false),
                              @"notReceiver": @(false)};
    
    NSDictionary *warrantyDict = @{@"ticketNumber" : @290700000000122,
                                   @"orderNumber" : @14089746,
                                   @"description" : @"Garantia estendida 1 ano.",
                                   @"startDate" : @1436756400000,
                                   @"expirationDate" : @1468378800000,
                                   @"enrollmentDate" : @1421114400000,
                                   @"rescissionDate" : @1421114400000,
                                   @"value" : @95.12,
                                   @"urlImage" : @"https://static-cms.waldev.com.br/imgres/arquivos/ids/2840442",
                                   @"cancelled" : @NO,
                                   @"cancelable" : @YES,
                                   @"rescissionPdf" : @"/users/warranties/rescission/290700000000224.pdf",
                                   @"ticketPdf" : @"/users/warranties/ticket/290700000000224.pdf",
                                   @"enrollmentPdf" : @"/users/warranties/enrollment/290700000000224.pdf",
                                   @"address" : address};
    
    ExtendedWarrantyDetail *warranty = [[ExtendedWarrantyDetail alloc] initWithDictionary:warrantyDict error:NULL];
    return warranty;
}


@end
