//
//  InternalControlViewController.m
//  Walmart
//
//  Created by Marcelo Santos on 1/19/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

@import AirshipKit;

#import "InternalControlViewController.h"

#import "OFAppDelegate.h"
#import "QASkuViewController.h"
#import "TimeManager.h"
#import "WBRUser.h"
#import "WBRUTM.h"

#import <MessageUI/MessageUI.h>

@interface InternalControlViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblToken;
@property (weak, nonatomic) IBOutlet UILabel *lblStatusUrban;
@property (weak, nonatomic) IBOutlet UIButton *btToken;

@property (nonatomic, strong) MFMailComposeViewController *comp;
@property (nonatomic, strong) NSString *tokenUrbanValue;
@property (weak, nonatomic) IBOutlet UIButton *btConfig;

@property (weak, nonatomic) IBOutlet UILabel *UTMSourceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *UTMSourceDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *UTMMediumValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *UTMMediumDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *UTMCampaignValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *UTMCampaignDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *UTMStatusLabel;


- (IBAction)sendToken:(id)sender;
- (IBAction)loadConfig:(id)sender;

- (IBAction)loadDetail:(id)sender;

- (IBAction)deletePID:(id)sender;

@end

@implementation InternalControlViewController

- (BOOL) isSimulator {
    
    return TARGET_OS_SIMULATOR != 0; // Use this line in Xcode 6
}

- (InternalControlViewController *)init {
    self = [super initWithTitle:@"Controle Interno" isModal:NO searchButton:NO cartButton:NO wishlistButton:NO];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self performSelector:@selector(verifyTokenUrban) withObject:nil afterDelay:1];
    [self loadUTMValues];
}

- (void)loadDetail:(id)sender {
    
    QASkuViewController *cart = [QASkuViewController new];
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:cart];
    [self.navigationController presentViewController:navigation animated:YES completion:nil];
}

- (void) verifyTokenUrban {
    
    BOOL pushError = [[NSUserDefaults standardUserDefaults] boolForKey:@"pushError"];
    
    if (pushError) {
        
        _lblToken.text = @"Push não disponível. Talvez algum problema com certificado.";
        
        if (TARGET_OS_SIMULATOR) {
            _lblToken.text = @"Usando simulador. Push não disponível.";
        }
        
        _lblStatusUrban.text = @"OFF";
    }
    else {
        
        NSString *strPushToken = [UAirship push].deviceToken ?: @"";
        LogInfo(@"Push Channel: %@", strPushToken);
        
        if (strPushToken.length > 0) {
            _lblToken.text = strPushToken;
            _lblStatusUrban.textColor = [UIColor greenColor];
            _lblStatusUrban.text = @"ON";
            
            _tokenUrbanValue = strPushToken;
        }
    }
}

- (void)stateChangedBanner:(UISwitch *)switchState
{
    if ([switchState isOn]) {
        LogInfo(@"Switch Banner is ON");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"controlBannerRefresh"];
    } else {
        LogInfo(@"Switch Banner is OFF");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"controlBannerRefresh"];
    }
}

- (IBAction)deletePID:(id)sender {
    
    [WBRUser removePIDFromUser];
    
//    OFAppDelegate *appDelegate = (OFAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate calabashBackdoor:@""];
}

- (IBAction)sendToken:(id)sender {
    
    if (_tokenUrbanValue.length > 0) {
        
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            mail.mailComposeDelegate = self;
            [mail setSubject:@"TOKEN Urban"];
            [mail setMessageBody:[NSString stringWithFormat:@"%@", _tokenUrbanValue ?: @""] isHTML:YES];
            
            [self presentViewController:mail animated:YES completion:NULL];
            
            [self.view hideLoading];
        }
        else
        {
            LogErro(@"This device cannot send email");
            
            [self.view hideLoading];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Este iPhone não pode enviar e-mail." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Não há um token a ser enviado." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)loadConfig:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (IBAction)invalidateUTMs:(id)sender {
    [WBRUTM invalidateUTMs];
    [self loadUTMValues];
}

- (void)loadUTMValues {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    WBRUTMModel *utmSource = [WBRUTM getUTMForKey:kUTMKeychainSource];
    if (utmSource) {
        self.UTMSourceValueLabel.text = utmSource.UTMValue;
        self.UTMSourceDateLabel.text = [dateFormatter stringFromDate:utmSource.savedDate];
    }
    
    WBRUTMModel *utmMedium = [WBRUTM getUTMForKey:kUTMKeychainMedium];
    if (utmMedium) {
        self.UTMMediumValueLabel.text = utmMedium.UTMValue;
        self.UTMMediumDateLabel.text = [dateFormatter stringFromDate:utmMedium.savedDate];
    }
    
    WBRUTMModel *utmCampaign = [WBRUTM getUTMForKey:kUTMKeychainCampaign];
    if (utmCampaign) {
        self.UTMCampaignValueLabel.text = utmCampaign.UTMValue;
        self.UTMCampaignDateLabel.text = [dateFormatter stringFromDate:utmCampaign.savedDate];
    }
    
    NSDate *utmDate;
    
    if (utmSource) {
        utmDate = utmSource.savedDate;
    }
    else if (utmMedium) {
        utmDate = utmMedium.savedDate;
    }
    else if (utmCampaign) {
        utmDate = utmCampaign.savedDate;
    }
    
    if (utmDate) {
        BOOL utmValid = [TimeManager UTMDateStillValid:utmDate];
        
        if (utmValid) {
            self.UTMStatusLabel.textColor = [UIColor greenColor];
            self.UTMStatusLabel.text = @"Valid";
        }
        else {
            self.UTMStatusLabel.textColor = [UIColor redColor];
            self.UTMStatusLabel.text = @"Invalid";
        }
    }
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
