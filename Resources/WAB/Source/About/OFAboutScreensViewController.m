//
//  OFAboutScreensViewController.m
//  Ofertas
//
//  Created by Marcelo Santos on 9/5/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFAboutScreensViewController.h"

@interface OFAboutScreensViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *viewUpperBar;
@property (weak, nonatomic) IBOutlet UIButton *btBack;
@property (weak, nonatomic) IBOutlet UIButton *btBackModal;

@property (assign, nonatomic) BOOL isFromConfirm;

@property (strong, nonatomic) NSURL *urlOut;

@end

@implementation OFAboutScreensViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andHtmlFile:(NSString *) htmlfilename andTitle:(NSString *)title isFromConfirm:(BOOL) isConfirm
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSDictionary *skinDict = [OFSkinInfo getSkinDictionary];
        
        self.dictSkin = skinDict;
        self.fileHtml = htmlfilename;
        self.strTitle = title;
        LogInfo(@"Title About Screen: %@", title);
        
        self.isFromConfirm = isConfirm;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (_isFromConfirm)
    {
        _btBack.hidden = YES;
        _btBackModal.hidden = NO;
    }
    else
    {
        _btBack.hidden = NO;
        _btBackModal.hidden = YES;
    }
    
    
    //Detect device type and adjust logo for iPhone 4/4s
    WMDeviceType *dt = [[WMDeviceType alloc] init];
    BOOL is5 = [dt isPhone5];
    if (!is5) {
        _webContent.frame = CGRectMake(0, 57, 320, 423);
    }
    
    _lblTitle.text = _strTitle;
    
    //loading local html file into UIWebview
    NSBundle *bundle=[NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:_fileHtml ofType: @"html"];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    [_webContent setScalesPageToFit:NO];
    [_webContent loadRequest:request];
    
    if ([OFSetup backgroundEnable]) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEnteredBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    }
}

- (void)handleEnteredBackground:(NSNotification *)notification
{
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

- (void) back
{
    [[self delegate] hideScreens];
}

- (void) backModal
{
    [[self delegate] closeAbout];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    [FlurryWM logEvent_signup_toc];
    if ( navigationType == UIWebViewNavigationTypeLinkClicked )
    {
        if (_isFromConfirm)
        {
            [self.view showPopupWithTitle:GO_OUT_APP_FROM_TERMS_TITLE message:GO_OUT_APP_FROM_TERMS cancelButtonTitle:CANCEL_BUTTON cancelBlock:nil actionButtonTitle:CONTINUE_BUTTON actionBlock:^{
                [[UIApplication sharedApplication] canOpenURL:self->_urlOut];
            }];
            self.urlOut = [request URL];
        }
        else
        {
            [[UIApplication sharedApplication] canOpenURL:[request URL]];
        }
        
        return NO;
    }
    return YES;
}

@end
