//
//  WMBFaceLinkViewController.m
//  Walmart
//
//  Created by Marcelo Santos on 12/5/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBFaceLinkViewController.h"
#import "WMButtonRounded.h"
#import "WMBFaceHeaderViewController.h"
#import "WMBFaceInfoViewController.h"
#import "WBRFacebookLoginManager.h"
#import "WALRegisterViewController.h"
#import "OFLoginViewController.h"
#import "UIViewController+Login.h"
#import "WBRLoginManager.h"
#import "NSString+Validation.h"
#import "ShowcaseProductModel.h"
#import "WALHomeViewController.h"

@interface WMBFaceLinkViewController () <WALRegisterViewControllerDelegate>

@property (nonatomic, weak) IBOutlet WMButtonRounded *linkAccount;
@property (nonatomic, weak) IBOutlet WMButtonRounded *createAccount;

@property (weak, nonatomic) IBOutlet UIView *viewFaceHeader;
@property (weak, nonatomic) IBOutlet UIView *viewFaceInfo;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewInScrollHeightConstraint;

//@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightFaceHeaderConstraint;


- (IBAction)registerUser:(id)sender;
- (IBAction)linkMyAccount:(id)sender;

@end

@implementation WMBFaceLinkViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Conectar";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupLayout];
    [self addHeaderFacebook];
}

- (void) addHeaderFacebook {
    
    WMBFaceHeaderViewController *wmh = [[WMBFaceHeaderViewController alloc] initWithNibName:@"WMBFaceHeaderViewController" bundle:nil];
    [WBRFacebookLoginManager getFacebookUserInformationsWithSuccess:^(FaceUser *facebookUser, NSHTTPURLResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wmh setContent:facebookUser];
        });
    } failure:^(NSError *error, NSHTTPURLResponse *failResponse) {
        LogErro(@"[FACEBOOK] Error: %@", [error description]);
    }];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    result = CGSizeMake(result.width , result.height);
    
    float widthScreen = result.width;
    
    [_viewFaceHeader setNeedsLayout];
    [_viewFaceHeader layoutIfNeeded];
    
    _viewFaceHeader.frame = CGRectMake(0, 0, widthScreen, 110);
    
    [_viewFaceHeader addSubview:wmh.view];
    
    [_viewFaceInfo setNeedsLayout];
    [_viewFaceInfo layoutIfNeeded];
    
    _viewFaceInfo.frame = CGRectMake(0, 0, widthScreen, 80);
    
    WMBFaceInfoViewController *wmi = [[WMBFaceInfoViewController alloc] initWithNibName:@"WMBFaceInfoViewController" bundle:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [wmi setLabelContent:@"Seu email cadastrado no Walmart.com é diferente do seu email do Facebook."];
    });
    
    [_viewFaceInfo addSubview:wmi.view];
    
    _viewFaceHeader.alpha = 1;
    _viewFaceHeader.hidden = NO;
    
    _viewFaceInfo.alpha = 1;
    _viewFaceInfo.hidden = NO;
}


#pragma mark - Layout
- (void)setupLayout
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    result = CGSizeMake(result.width, result.height);
    float heightScreen = result.height;
    
    //Verify if iPhone 6 or Plus
    if (heightScreen >= 667) {
        _viewInScrollHeightConstraint.constant = heightScreen-64;
    }
    else if (heightScreen >= 568) {
        _viewInScrollHeightConstraint.constant = heightScreen*1.1;
    }
    else if (heightScreen >= 480) {
        _viewInScrollHeightConstraint.constant = heightScreen*1.3;
    }
}

- (void) linkMyAccount:(id)sender {
    
    [self presentLoginLinkFacebookWithSnId:_strSnId facebookLink:_isFacebookWithLink fromClass:_fromClass completionBlock:^{
        [self.navigationController.view hideModalLoading];
//        [self.navigationController popViewControllerAnimated:YES];
    } successBlock:^{
        LogInfo(@"Success Facelink");
        [self.navigationController popViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"faceLoginDismiss" object:self];
    }dismissBlock:^{
        LogInfo(@"Dismiss Block"); //When the "X" is pressed
    }];
}

- (void) dismissLoginScreen {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) registerUser:(id)sender {
    
    WALRegisterViewController *registerViewController = [[WALRegisterViewController alloc] initWithDelegate:self];
    registerViewController.isFacebook = YES;
    registerViewController.strSnId = _strSnId;
    registerViewController.isFacebookWithLink = NO;
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)walRegisterViewControllerRegisteredUserWithEmail:(NSString *)email pass:(NSString *)pass
{
    //Login
    [FlurryWM logEvent_login_btn];

    BOOL isFacebook;
    BOOL isFacebookWithLink;
    NSString *snID;
    
    LogInfo(@"From Class facelink: %@", _fromClass);

    if ([email isEmail]) {

        isFacebook = YES;
        snID = _strSnId;
        isFacebookWithLink = NO;
        
        [WBRLoginManager loginWithUser:email pass:pass isFacebook:isFacebook isFacebookWithLink:isFacebookWithLink snId:snID successBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self facebookAddAccount];
            });

        } failureBlock:^(NSError *error) {
            LogErro(@"Error!!!");
        }];
    }
    else if ([email isCPF] || [email isCNPJ]) {
        
        isFacebook = YES;
        snID = _strSnId;
        isFacebookWithLink = NO;
        
        [WBRLoginManager loginWithDocument:email pass:pass isFacebook:isFacebook isFacebookWithLink:isFacebookWithLink snId:snID successBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self facebookAddAccount];
            });
        } failureBlock:^(NSError *error) {
            LogErro(@"Error!!!");
        }];
    }
}


#pragma mark - Facebook Add Account

- (void) facebookAddAccount {
    
    //Search by pre favorited product
    NSData *wishlistProductData = [[NSUserDefaults standardUserDefaults] objectForKey:@"showcaseHeart"];
    if (wishlistProductData) {
        ShowcaseProductModel *spm = [NSKeyedUnarchiver unarchiveObjectWithData:wishlistProductData];
        [[WALHomeViewController new] favoriteProduct:spm completionBlock:nil];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"showcaseHeart"];
    }
    
    if ([_fromClass isEqualToString:@"NewCartViewController"]) {
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"faceBuyOrder" object:self];
    }
    else if ([_fromClass isEqualToString:@"WMContactViewController"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"faceContact" object:self];
    }
    else if ([_fromClass isEqualToString:@"WALWishlistViewController"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if ([_fromClass isEqualToString:@"WALProductDetailViewController"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"faceFavoriteDetail" object:self];
    }
    else if ([_fromClass isEqualToString:@"OFSearchProductsViewController"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"faceFavoriteSearch" object:self];
    }
    else {
        
        [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
