//
//  OFSplashViewController.m
//  Ofertas
//
//  Created by Marcelo Santos on 7/11/13.
//  Copyright (c) 2013/2014 Marcelo Santos. All rights reserved.
//

#import "OFSplashViewController.h"
#import "PushHandler.h"
#import "UIImageView+WebCache.h"
#import "WALMenuViewController.h"
#import "OFCustomSizeNavigationBar.h"
#import "UIImage+Additions.h"
#import "RefreshTokenStatus.h"
#import "WMBaseNavigationController.h"
#import "OFTutorial.h"
#import "WBRSetupManager.h"
#import "WMParser.h"
#import "OFAppDelegate.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface OFSplashViewController () <refStatusDelegate>

@property (nonatomic, strong) RefreshTokenStatus *refTokAlert;
@property BOOL showSplashCustomized;

@end

@implementation OFSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [FlurryWM logEvent_splashEntering];
    
    UIDevice *myDevice=[UIDevice currentDevice];
    NSString *UUID = [[myDevice identifierForVendor] UUIDString];
    LogMicro(@"INDETIFIERVENDOR UUID: %@", UUID);
    
    //Show button to test refresh token
#if !defined CONFIGURATION_Release && !defined CONFIGURATION_EnterpriseTK
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showStatusRefreshToken:)
                                                 name:@"statusRefreshToken"                                               object:nil];
#endif
    
    //Verify DB - Create or not the DB
    MDSSqlite *db = [[MDSSqlite alloc] init];
    [db verifyDBExists];
    
    //Configure splash
    [self showSplash];
    
    //Configure toggles (services)
    [self configureServices];
}

- (void) blockVersion:(void (^)(ModelAlert *modelAlert)) success failure:(void (^)(NSDictionary *dictError))failure {
    
    [WBRSetupManager getAlert:^(ModelAlert *alertModel) {
        
        success (alertModel);
        
    } failure:^(NSDictionary *dictError) {
        
        failure (dictError);
    }];
}

- (void) showSplash {
    
    //Splash
    __weak OFSplashViewController *weakSelf = self;
    [WBRSetupManager getSplash:^(ModelSplash *splashModel) {
        
        LogMicro(@"splashModel: %@", splashModel);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.showSplashCustomized = NO;
            
            //Fill background Color
            if (splashModel.bgColor) {
                //First get background
                int rColor = [splashModel.bgColor.r intValue];
                int gColor = [splashModel.bgColor.g intValue];
                int bColor = [splashModel.bgColor.b intValue];
                float aColor = [splashModel.bgColor.a floatValue];
                
                weakSelf.view.backgroundColor = RGBA(rColor, gColor, bColor, aColor);
                
                weakSelf.showSplashCustomized = YES;
            }
            
            //Search by image
            if (splashModel.image.length > 0) {
                
                //Get image
                NSString *pathImg = splashModel.image;
                
                BOOL canOpenImageURL = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pathImg]];
                
                if (canOpenImageURL) {
                    
                    __weak UIImageView *weakThumb = weakSelf.imgPromotion;
                    [weakSelf.imgPromotion sd_setImageWithURL:[NSURL URLWithString:pathImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                    }];
                    
                    
                    [weakSelf.imgPromotion sd_setImageWithURL:[NSURL URLWithString:pathImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl) {
                         if (!image) {
                             weakThumb.image = [UIImage imageNamed:@"img_splashpage.png"];
                         }
                     }];

                }
            }
            
            //Search by Alert
            OFAppDelegate *appDelegate = (OFAppDelegate *)[[UIApplication sharedApplication] delegate];

            [appDelegate checkAlert:^(ModelAlert *modelAlert) {
                
                if (!modelAlert.block.boolValue) {
                    
                    if (weakSelf.showSplashCustomized) { //Add 4 seconds if splash is customized
                        [weakSelf performSelector:@selector(showOrHideTutorial) withObject:nil afterDelay:3];
                    } else {
                        //Go Tutorial or Home
                        [weakSelf showOrHideTutorial];
                    }
                }
            }];
        });
        
    } failure:^(NSDictionary *dictError) {
        
        LogErro(@"[SPLASH] Error: %@", dictError);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf hideIndicator];
            
            NSString *msgError = ERROR_CONNECTION_UNKNOWN;
            
            if ([dictError objectForKey:@"error"]) {
                msgError = [dictError objectForKey:@"error"];
            } else if ([dictError objectForKey:@"message"]) {
                msgError = [dictError objectForKey:@"message"];
            }
            
            [weakSelf.view showAlertWithMessage:msgError dismissButtonTitle:TRY_BUTTON dismissBlock:^{
                
                //Configure toggles (services)
                [weakSelf configureServices];
                //Configure splash
                [weakSelf showSplash];
            }];
        });
    }];
}


- (void) configureServices {
    
    [self showIndicator];
    
    //Services
    [WBRSetupManager getServices:^(ModelServices *servicesModel) {
        LogMicro(@"\n\n[SERVICES] Sergices Model: %@", servicesModel);
        
        [[WALMenuViewController singleton] setServices:servicesModel];
        [[WALMenuViewController singleton] updateDepartments];
        
    } failure:^(NSDictionary *dictError) {
        
        LogErro(@"[SERVICES] Error: %@", dictError);
    }];
}


- (void) showOrHideTutorial {
    
    [self hideIndicator];
    
#if defined CONFIGURATION_EnterpriseQA || CONFIGURATION_Staging || CONFIGURATION_DebugCalabash || DEBUGQA
    [self openTutorial];
#else
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FirstNewOpen"]) {
        [self openTutorial];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstNewOpen"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        //Go Tutorial or Home
        [self loadMenuAndHome];
    }
#endif
    
}


- (void)openTutorial {
    OFTutorial *tutorial = [[OFTutorial alloc] initWithNibName:@"OFTutorial" bundle:nil];
    [self presentViewController:tutorial animated:NO completion:^{
        
        [self loadMenu];
    }];
}


- (void) loadMenuAndHome {
    [self loadMenu];
}

/*
- (void) goHome
{
    
    [self hideIndicator];
    
    if ([[PushHandler singleton] notificationDictionary]) {
        //Hide tutorial when we are comming from a push notification
        [self openMenu];
    }
    else {
#if defined DEBUGQA || defined CONFIGURATION_Staging
        [self openTutorial];
#else
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstOpen"]) {
            [self openMenu];
        }
        else {
            [self openTutorial];
        }
#endif
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstOpen"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
 */

- (void)loadMenu {
    
    WALMenuViewController *menuViewController = [WALMenuViewController singleton];
    
    self.container = [[UINavigationController alloc] initWithNavigationBarClass:[OFCustomSizeNavigationBar class] toolbarClass:[UIToolbar class]];
    [_container setViewControllers:@[menuViewController]];
    [_container.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBA(0, 81, 156, 1) size:CGSizeMake(self.view.bounds.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    _container.navigationBar.tintColor = [UIColor whiteColor];
    _container.navigationBar.translucent = NO;
    
    [self addChildViewController:_container];
    _container.view.frame = self.view.bounds;
    [self.view addSubview:_container.view];
    [_container didMoveToParentViewController:self];
}

- (void) showIndicator {
    
    actInd.hidden = NO;
}

- (void) hideIndicator {
    
    actInd.hidden = YES;
}


#pragma mark - Status Refresh Token

- (void) showStatusRefreshToken:(NSNotification *) not {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //Show button to test refresh token
#if !defined CONFIGURATION_Release && !defined CONFIGURATION_EnterpriseTK
        [self.view showFeedbackAlertOfKind:SuccessAlert message:@"::::: T O K E N  RENOVADO :::::"];
        
        LogInfo(@"\n");
        LogInfo(@"        --------------------------------------------------------------------");
        LogInfo(@"        [REFRESHTOKEN] Token RENEWED");
        LogInfo(@"        --------------------------------------------------------------------");
        LogInfo(@"\n");
#endif
    });
}

- (void) removeStatusRefreshToken {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:.3 animations:^{
            self.refTokAlert.view.frame = CGRectMake(0, -120, self->_refTokAlert.view.frame.size.width, 100);
        } completion:^(BOOL finished) {
            [self->_refTokAlert.view removeFromSuperview];
        }];
    });
}


@end
