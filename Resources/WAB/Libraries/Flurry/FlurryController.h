//
//  FlurryController.h
//  Ofertas
//
//  Created by Bruno Delgado on 04/11/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlurryController : NSObject

+ (void)logScreenEnter:(NSString *)screenName;
+ (void)logScreenExit:(NSString *)screenName;
+ (void)logCategoryTouchWithID:(NSInteger)categoryID Name:(NSString *)categoryName isMenu:(BOOL)isMenu;
+ (void)logProductTouchWithID:(NSInteger)productID Name:(NSString *)productName;
+ (void)logButtonTouch:(NSString *)buttonName inScreen:(NSString *)screenName;
+ (void)logAction:(NSString *)actionName inScreen:(NSString *)screenName;
+ (void)logClosingApplicationOnScreen:(NSString *)screenName;

@end
