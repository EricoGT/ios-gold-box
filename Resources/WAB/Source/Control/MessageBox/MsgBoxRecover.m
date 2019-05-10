//
//  MsgBoxRecover.m
//  Ofertas
//
//  Created by Marcelo Santos on 9/20/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "MsgBoxRecover.h"

#import "WMButton.h"

@interface MsgBoxRecover ()

@end

@implementation MsgBoxRecover

@synthesize message, dictSkin, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andMsg:(NSString *) msg andIsError:(BOOL) isAnError
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        OFSkinInfo *osk = [[OFSkinInfo alloc] init];
//        NSDictionary *skinDict = [osk getSkinDictionary];
        NSDictionary *skinDict = [OFSkinInfo getSkinDictionary];
        
        self.dictSkin = skinDict;
        isError = isAnError;
        self.message = msg;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (isError) {
        iconStatus.image = [UIImage imageNamed:@"ico_error.png"];
    }
    lblMessage.text = message;
    
    float sizeFont = 12.0f;
    UIFont *fontCustom = [UIFont fontWithName:@"OpenSans" size:sizeFont];
    lblMessage.font = fontCustom;
    
    [btOk setup];
    
    viewStatusAlert.layer.cornerRadius = 4.0f;
    viewStatusAlert.layer.masksToBounds = YES;
    
    //Detect device type and adjust logo for iPhone 4/4s
    WMDeviceType *dt = [[WMDeviceType alloc] init];
    BOOL is5 = [dt isPhone5];
    float posY = 20;
    
    if (!is5) {
        viewStatusAlert.frame = CGRectMake(37, 80+posY, 247, 164);
    } else {
        viewStatusAlert.frame = CGRectMake(37, 170+posY, 247, 164);
    }
    
    [self centerAlert];

//    
//    [self performSelector:@selector(feedContent) withObject:nil afterDelay:0.1];
//}
//
//- (void) feedContent {
}

- (void) centerAlert {
    
    float heightScreen = self.view.frame.size.height;
    float widthScreen = self.view.frame.size.width;
    LogInfo(@"W: %.2f H: %.2f", widthScreen, heightScreen);
    heightScreen = 548;
    widthScreen = 320;
    
    //Detect device type and adjust logo for iPhone 4/4s
    WMDeviceType *dt = [[WMDeviceType alloc] init];
    BOOL is5 = [dt isPhone5];
    if (!is5) {
        heightScreen = 460.0f;
    }
    
    float coordX = (widthScreen - viewStatusAlert.frame.size.width)/2;
    float coordY = (heightScreen - viewStatusAlert.frame.size.height)/2;
    
    viewStatusAlert.frame = CGRectMake(coordX, coordY, viewStatusAlert.frame.size.width, viewStatusAlert.frame.size.height);
}

- (void) ok {
    LogInfo(@"OK");
    if (isError) {
        [[self delegate] showLoginBox];
    }
    [self.view removeFromSuperview];
}

@end
