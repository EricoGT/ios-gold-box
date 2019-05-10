//
//  WMCheckoutConnection.h
//  Walmart
//
//  Created by Bruno on 9/8/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseConnection.h"
@class ShowcaseTrackerModel;

typedef enum : NSUInteger {
    CheckoutStepCart,
    CheckoutStepAddress,
    CheckoutStepPayment
} CheckoutStep;

@interface WMRetargetingConnection : WMBaseConnection

//Tracks when user touch a department
- (void)trackDepartmentWithId:(NSString *)departmentId;

//Tracks when user touch a category
- (void)trackCategoryWithId:(NSString *)categoryId departmentId:(NSString *)departmentId;

//Tracks when user touch a subcategory
- (void)trackSubcategoryWithId:(NSString *)subcategoryId categoryId:(NSString *)categoryId departmentId:(NSString *)departmentId;

//Tracks when user reach a new step in checkout. Possible steps: Cart, Address and Payment
- (void)trackCheckoutOrder:(NSDictionary *)source step:(CheckoutStep)step;

//Tracks when there's a complete purchase
- (void)trackSuccessOrder:(NSDictionary *)order orderId:(NSNumber *)orderId;

@end

