//
//  WBRContactTicketAttachmentModel.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 12/20/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactTicketAttachmentModel.h"

@implementation WBRContactTicketAttachmentModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"identifier": @"id",
                                                                  @"contentType": @"contentType",
                                                                  @"fileName": @"fileName",
                                                                  @"fileSize": @"fileSize"
                                                                  }];
}

@end
