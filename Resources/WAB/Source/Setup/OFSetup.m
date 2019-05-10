//
//  OFSetup.m
//  Walmart
//
//  Created by Bruno Delgado on 5/21/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "OFSetup.h"
#import "Reachability.h"

//*
//
//  Configuration
//
//*

//static const BOOL canShowMyAccount = NO;

//#if defined CONFIGURATION_BetaQA || defined CONFIGURATION_EnterpriseQA
//static const BOOL canShowMyAccount = YES;
//#else
//static const BOOL canShowMyAccount = NO;
//#endif

//static const BOOL canShowMyAccount = NO;
static const BOOL canShowSearch = YES;
static const BOOL canTestVariations = NO;
static const BOOL canTestAdviseMe = YES;
//static const BOOL canTestBannerDetail = NO;
static BOOL canShowMyAccount = NO;
static BOOL canShowBannerDetail = NO;
//static BOOL canShowFilter = YES;
static BOOL canShowDepartmentsOnMenu = NO;
static BOOL canShowRatingAlert = NO;
static BOOL enableLogs = YES;
static BOOL enableBackground = YES;
static BOOL enableExtendedWarrantyNewCard = YES;
static BOOL enableExtendedWarrantyFeature = YES;
static BOOL enableHomeError = YES;
static BOOL useNewTrackingURL = YES;
static BOOL enableDoublePayment = YES;
static BOOL enableHomeMock = NO;
static BOOL enableNewInvoiceInTracking = YES;
static BOOL enableBankingTicket = YES;
static BOOL enableExtendedWarrantyInSelfHelp = NO;
static BOOL enableInstallmentsWithRateInPaymentForms = YES;
static BOOL enableInstallmentsWithRateInCheckout = YES;
static BOOL enableFacebookDeepLink = YES;
static BOOL enableFacebookButton = YES;
static BOOL enableUTMI = NO;
static BOOL enableWishlist = YES;
static BOOL canAddProductsToTheWishlistOutsideProductDetail = YES;
static BOOL enableTouchID = YES;
static BOOL enableBankSlipDiscount = NO;

@implementation OFSetup

+ (BOOL)hasActiveConnection
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];
    
    NetworkStatus stat = [reach currentReachabilityStatus];
    if(stat != NotReachable)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - Banking Ticket (Boleto)
+ (BOOL)showBankingTicket {
    
    return enableBankingTicket;
}

#pragma mark - Home Mock
+ (BOOL) enableMockHome {
    
    return enableHomeMock;
}

#pragma mark - Double Payment
+ (BOOL) enableNewDoublePayment {
    
    return enableDoublePayment;
}

#pragma mark - Global Product
- (void) setShowAccount:(BOOL) show {
    
    canShowMyAccount = show;
}

- (void) setShowBannerDelivery:(BOOL) show {
    
    canShowBannerDetail = show;
}

- (void) setShowDepartmentsOnMenu:(BOOL)show
{
    canShowDepartmentsOnMenu = show;
}

#pragma mark - Advise when product is available
+ (BOOL) testAdviseMe
{
    return canTestAdviseMe;
}

#pragma mark - Filter
+ (BOOL) showFilter
{
//    return canShowFilter;
    
    //Force off
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"enabled_filter"];
//    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_filter"]) {
//        return YES;
//    } else {
//        return NO;
//    }
    
    return YES;
}

#pragma mark - My Account
+ (BOOL)showMyAccount
{
    return canShowMyAccount;
}

#pragma mark - Search
+ (BOOL)showSearch
{
    return canShowSearch;
}

+ (BOOL)testCollections {
    
    return NO;
}

+ (BOOL) showBannerDelivery {
    
    return canShowBannerDetail;
}

+ (NSArray *)arrTestCollections {
    
    NSArray *arrColectionsTest = @[@"15973",@"15984",@"15979",@"15968",@"15989"];
    
    return arrColectionsTest;
}

+ (BOOL) testVariations {
    
    return canTestVariations;
}

+ (NSString *) idProductVariations {
    
    return @"2033529";
}

+ (BOOL)showDepartmentsOnMenu
{
    return canShowDepartmentsOnMenu;
}

+ (BOOL)showRatingAlertView
{
    return canShowRatingAlert;
}

+ (BOOL) logsEnable
{
    return enableLogs;
}

+ (BOOL) backgroundEnable {
    
    return enableBackground;
}

+ (BOOL) extendedWarrantyEnableNewCard {
    
    return enableExtendedWarrantyNewCard;
}

+ (BOOL) extendedWarrantyEnableFeature {
    
    return enableExtendedWarrantyFeature;
}

+ (BOOL) showExtendedWarrantyInSelfHelp
{
    return enableExtendedWarrantyInSelfHelp;
}

- (void)setShowExtendedWarrantyInSelfHelp:(BOOL)show {
    enableExtendedWarrantyInSelfHelp = show;
}

+ (BOOL) useNewTrackingURL {
    
    return useNewTrackingURL;
}

+ (BOOL)showHomeError
{
    return enableHomeError;
}

+ (BOOL)showNewInvoiceInTracking
{
    return enableNewInvoiceInTracking;
}

+ (BOOL)enableInstallmentsWithRateInPaymentForms
{
    return enableInstallmentsWithRateInPaymentForms;
}

+ (BOOL)enableInstallmentsWithRateInCheckout
{
    return enableInstallmentsWithRateInCheckout;
}

+ (BOOL)enableFacebookDeepLink
{
    return enableFacebookDeepLink;
}

+ (BOOL)enableFacebookButton
{
    return enableFacebookButton;
}

+ (BOOL)enableUTMI
{
    return enableUTMI;
}

+ (BOOL)enableWishlist
{
    return enableWishlist;
}

+ (BOOL)canAddProductsToTheWishlistOutsideProductDetail
{
    return canAddProductsToTheWishlistOutsideProductDetail;
}

+ (BOOL)enableTouchID
{
    return enableTouchID;
}


+ (NSDictionary *) infoAppToServer {
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *system = @"iOS";
    
    return @{@"version" : version ?: @"",
             @"system"  : system
             };
}

+ (BOOL)enableShowcaseColorsCount {
    return YES;
}

+ (BOOL)enableBankSlipDiscount {
    return enableBankSlipDiscount;
}

@end
