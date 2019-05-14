//
//  WBRMenuManager.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 21/06/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBRMenuManager : NSObject

typedef void(^kMenuManagerSuccessBlock)(void);
typedef void(^kMenuManagerSuccessDataBlock)(NSArray *items, NSArray *totals);
typedef void(^kMenuManagerFailure)(NSError *error);

+ (void)getAndUpdateMenuItemsWithSuccessBlock:(kMenuManagerSuccessBlock)successBlock failureBlock:(kMenuManagerFailure)failureBlock;

+ (void)getMenuCategoriesWithCategoryId:(NSNumber *)categoryID successBlock:(kMenuManagerSuccessDataBlock)successBlock failureBlock:(kMenuManagerFailure)failureBlock;

@end
