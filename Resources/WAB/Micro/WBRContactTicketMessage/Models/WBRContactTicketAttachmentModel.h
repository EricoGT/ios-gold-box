//
//  WBRContactTicketAttachmentModel.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 12/20/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol WBRContactTicketAttachmentModel;

@interface WBRContactTicketAttachmentModel : JSONModel

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString <Optional> *contentType;
@property (strong, nonatomic) NSString <Optional> *fileName;
@property (strong, nonatomic) NSNumber <Optional> *fileSize;

@end
