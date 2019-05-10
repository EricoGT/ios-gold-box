//
//  OFAboutViewController.m
//  Ofertas
//
//  Created by Marcelo Santos on 9/4/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFAboutViewController.h"
#import "UIImage+Additions.h"
#import <MessageUI/MFMailComposeViewController.h>

#import "WMWebViewController.h"
#import "WMBaseNavigationController.h"

#import "WBRSetupManager.h"

@interface OFAboutViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *legalInformationLabel;

@end

@implementation OFAboutViewController

@synthesize delegate, dictSkin;

- (OFAboutViewController *)init {
    self = [super initWithTitle:@"Sobre" isModal:NO searchButton:YES cartButton:YES wishlistButton:NO];
    if (self) {
        NSDictionary *skinDict = [OFSkinInfo getSkinDictionary];
        self.dictSkin = skinDict;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setLayout];
    [FlurryWM logEvent_aboutEntering];
    
    imgLogo.image = [UIImage imageNamed:@"logo_clube_walmart_azul.png"];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    #if defined CONFIGURATION_Release || CONFIGURATION_EnterpriseTK
    NSString *strVersion = [NSString stringWithFormat:@"Versão %@", version];
    #else
    NSString *strVersion = [NSString stringWithFormat:@"Versão %@ - Build %@", version, build];
    #endif
    
    NSString *strBuild = [NSString stringWithFormat:@"Build %@", build];
    
    lblVersion.text = strVersion;
    lblBuild.text = strBuild;
    
    float sizeFont = 15.0f;
    UIFont *fontCustom = [UIFont fontWithName:@"OpenSans" size:14];
    lblMessage.font = fontCustom;
    fontCustom = [UIFont fontWithName:@"OpenSans-Semibold" size:sizeFont];
    lblVersion.font = fontCustom;
    sizeFont = 10.0f;
    fontCustom = [UIFont fontWithName:@"OpenSans-Semibold" size:sizeFont];
    lblCopyright.font = fontCustom;
    
    if ([OFSetup backgroundEnable]) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEnteredBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    }
    
    self.legalInformationLabel.text = [WBRSetupManager aboutInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    CGRect scrollViewFrame = scrScreen.frame;
//    scrollViewFrame.size.height = [[UIScreen mainScreen] bounds].size.height - 44 - 20;
//    scrScreen.frame = scrollViewFrame;
}

- (void)handleEnteredBackground:(NSNotification *)notification
{
//    [FlurryController logClosingApplicationOnScreen:@"Sobre"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

- (void) back {
    
//    [FlurryController logButtonTouch:@"Menu" inScreen:@"Sobre"];
    [[self delegate] hideAboutScreen];
    
//    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void) goTerms {
    [FlurryWM logEvent_termsOfContent];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[OFUrls new] getURLTerms]]];
}

- (void) goTermsMarketPlace {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[OFUrls new] getURLTermsMarketPlace]]];
}

- (void) goPrivacy {
    [FlurryWM logEvent_privacyPolicy];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[OFUrls new] getURLPrivacy]]];
}

- (void) goDelivery {
    [FlurryWM logEvent_delivery];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[OFUrls new] getURLChangeOrReturnProduct]]];
}

- (void)setLayout
{
    UIColor *customBlue = RGBA(26, 117, 207, 1);
    UIColor *customOrange = RGBA(244, 123, 32, 1);
    
    [termsButton setTitleColor:customBlue forState:UIControlStateNormal];
    [termsButton setTitleColor:customOrange forState:UIControlStateHighlighted];
    [termsButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [termsButton setBackgroundImage:[UIImage imageWithColor:RGBA(247, 247, 247, 1)] forState:UIControlStateHighlighted];

    [termsMarketPlaceButton setTitleColor:customBlue forState:UIControlStateNormal];
    [termsMarketPlaceButton setTitleColor:customOrange forState:UIControlStateHighlighted];
    [termsMarketPlaceButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [termsMarketPlaceButton setBackgroundImage:[UIImage imageWithColor:RGBA(247, 247, 247, 1)] forState:UIControlStateHighlighted];
    
    [privacyButton setTitleColor:customBlue forState:UIControlStateNormal];
    [privacyButton setTitleColor:customOrange forState:UIControlStateHighlighted];
    [privacyButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [privacyButton setBackgroundImage:[UIImage imageWithColor:RGBA(247, 247, 247, 1)] forState:UIControlStateHighlighted];
    
    [shippingButton setTitleColor:customBlue forState:UIControlStateNormal];
    [shippingButton setTitleColor:customOrange forState:UIControlStateHighlighted];
    [shippingButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [shippingButton setBackgroundImage:[UIImage imageWithColor:RGBA(247, 247, 247, 1)] forState:UIControlStateHighlighted];
}

#pragma mark - UTMI
- (NSString *)UTMIIdentifier {
    return @"explore-app";
}

@end
