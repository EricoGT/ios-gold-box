//
//  WALMenuViewController.h
//  Walmart
//
//  Created by Bruno on 8/19/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMBaseViewController.h"
//#import "ServicesModel.h"
#import "ModelServices.h"

@class DepartmentMenuItem, WALHomeViewController, DeepLinkAction, WALMenuItemViewController;

@interface WALMenuViewController : WMBaseViewController

@property (nonatomic, assign, getter=isMenuOpen) BOOL menuOpen;
@property (nonatomic, strong) NSArray *departments;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
//@property (nonatomic, strong) ServicesModel *services;
@property (nonatomic, strong) ModelServices *services;
@property (strong, nonatomic) WALHomeViewController *home;
@property (strong, nonatomic) DeepLinkAction *deepLink;

@property (assign, nonatomic) BOOL userAuthenticated;

+ (instancetype)singleton;

//Menu options
- (IBAction)presentLogin;
- (IBAction)presentMyAccount;
- (IBAction)openContactAction;
- (void)presentLoginAnimated:(BOOL)animated;
- (void)logoutAndShowHome:(BOOL)showHome;
- (void)presentMyAccountWithOrderId:(NSString *)orderId;
- (void)presentHomeWithAnimation:(BOOL)animated reset:(BOOL)reset;
- (void)presentDepartment:(DepartmentMenuItem *)department;
- (void)presentAllShopping;
- (void)presentHubWithID:(NSString *)hubId title:(NSString *)hubTitle otherCategories:(NSArray *)otherCategories;
- (void)presentNotifications;
- (void)presentHowToUse;
- (void)presentFeedback;
- (void)rateInAppStore;
- (void)presentAbout;
- (void)presentInternalControl;
- (void)presentWalmartWebsite;
- (void)presentOrdersViewController;
- (void)updateDepartments;
- (void)refreshWithNewDepartments:(NSDictionary *)departmentsDictionary;
- (void)dismissBackToRootViewController;
- (void)loadQueryOnCurrentViewController:(NSString *)query;
- (void)loadProductOnCurrentViewControllerForProductId:(NSString *)productId;
- (void)loadProductOnCurrentViewControllerForProductSku:(NSString *)productSku;
- (void)checkDeepLinkActions;
- (void)updateUserInformation;
- (void)unselectHeaderButtons;

- (void)logoutAndShowHomeCalabash:(BOOL)showHome;

//Menu control
- (void)openMenuWithCompletion:(void (^)())completionBlock;
- (void)closeMenuAnimated:(BOOL)animated completion:(void (^)())completionBlock;
- (void)checkMenuSelection;
- (void)reloadHome;
- (WALMenuItemViewController *)currentController;
- (NSString *)currentUTMIIdentifier;

@end
