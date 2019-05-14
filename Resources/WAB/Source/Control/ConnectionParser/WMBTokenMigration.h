//
//  WMBTokenMigration.h
//  Walmart
//
//  Created by Bruno Delgado on 8/2/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMBTokenMigration : NSObject

/**
 *  Runs the token migration code
 */
+ (void)migrateToken;

@end
