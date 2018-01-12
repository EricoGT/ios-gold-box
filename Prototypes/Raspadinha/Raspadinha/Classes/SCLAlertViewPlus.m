//
//  SCLAlertViewPlus.m
//  AHK-100anos
//
//  Created by Erico GT on 10/7/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "SCLAlertViewPlus.h"

@interface SCLAlertViewPlus()

@property (nonatomic, strong) UILabel *lblQuantity;
//
@property (nonatomic, assign) int selectedQuantity;
@property (nonatomic, assign) int minQuantity;
@property (nonatomic, assign) int maxQuantity;

@end

@implementation SCLAlertViewPlus

@synthesize lblQuantity;
@synthesize selectedQuantity, minQuantity, maxQuantity;

- (instancetype)initWithNewWindow
{
    self = [super initWithNewWindow];
    selectedQuantity = 0;
    return self;
}

- (instancetype)init
{
    self = [super initWithNewWindow];
    selectedQuantity = 0;
    return self;
}

- (SCLButton *)addButton:(NSString *)title withType:(enumSCLAlertButtonType)type actionBlock:(SCLActionBlock)action
{
    SCLButton *button = [super addButton:title actionBlock:action];
    
    if (type == SCLAlertButtonType_Neutral){
        button.defaultBackgroundColor = [UIColor grayColor];
    }else if(type == SCLAlertButtonType_Question){
        button.defaultBackgroundColor = [UIColor colorWithRed:1.0/255.0 green:55.0/255.0 blue:91.0/255.0 alpha:1.0];
    }else if(type == SCLAlertButtonType_Destructive){
        button.defaultBackgroundColor = UIColorFromHEX(0xC1272D);
    }
    
    return button;
}

- (SCLButton *)addButton:(NSString *)title withType:(enumSCLAlertButtonType)type  validationBlock:(SCLValidationBlock)validationBlock actionBlock:(SCLActionBlock)action
{
    SCLButton *button = [super addButton:title validationBlock:validationBlock actionBlock:action];
    
    if (type == SCLAlertButtonType_Neutral){
        button.defaultBackgroundColor = [UIColor grayColor];
    }else if(type == SCLAlertButtonType_Question){
        button.defaultBackgroundColor = [UIColor colorWithRed:1.0/255.0 green:55.0/255.0 blue:91.0/255.0 alpha:1.0];
    }else if(type == SCLAlertButtonType_Destructive){
        button.defaultBackgroundColor = UIColorFromHEX(0xC1272D);
    }
    
    return button;
}

- (SCLButton *)addButton:(NSString *)title withType:(enumSCLAlertButtonType)type  target:(id)target selector:(SEL)selector
{
    SCLButton *button = [super addButton:title target:target selector:selector];
    
    if (type == SCLAlertButtonType_Neutral){
        button.defaultBackgroundColor = [UIColor grayColor];
    }else if(type == SCLAlertButtonType_Question){
        button.defaultBackgroundColor = [UIColor colorWithRed:1.0/255.0 green:55.0/255.0 blue:91.0/255.0 alpha:1.0];
    }else if(type == SCLAlertButtonType_Destructive){
        button.defaultBackgroundColor = UIColorFromHEX(0xC1272D);
    }
    
    return button;
}

+ (SCLAlertViewPlus*)createRichAlertWithMessage:(NSString*)bodyMessage imagesArray:(NSArray<UIImage*>*)images animationTimePerFrame:(NSTimeInterval)aTime
{
    SCLAlertViewPlus *alert = [[SCLAlertViewPlus alloc] initWithNewWindow];
    [alert.labelTitle setFont:[UIFont boldSystemFontOfSize:20.0]];
    [alert.viewText setFont:[UIFont systemFontOfSize:16.0]];
    [alert setButtonsTextFontFamily:[UIFont boldSystemFontOfSize:16.0].fontName withSize:16.0];
    alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;//SlideInFromTop;
    alert.hideAnimationType = SCLAlertViewHideAnimationFadeOut;//SlideOutToBottom;
    alert.backgroundType = SCLAlertViewBackgroundShadow;
    //
    CGFloat alertWidth = 216.0;
    CGRect textRect = [bodyMessage boundingRectWithSize:CGSizeMake(alertWidth, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}
                                         context:nil];
    
   
    //Label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10.0, alertWidth, textRect.size.height)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:16.0];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = bodyMessage;
    
    //ImageView
    UIImageView *imvView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, label.frame.size.height + 20.0, alertWidth, 120)];
    imvView.backgroundColor = [UIColor clearColor];
    imvView.contentMode = UIViewContentModeScaleAspectFit;
    imvView.clipsToBounds = YES;
    imvView.animationImages = images;
    imvView.animationDuration = (aTime * (float)images.count);
    [imvView startAnimating];
    
    //CustomView
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, alertWidth, (10.0 + label.frame.size.height + 10.0 + imvView.frame.size.height + 20.0))];
    [subView addSubview:label];
    [subView addSubview:imvView];
    //
    [alert addCustomView:subView];
    
    return alert;
}


+ (SCLAlertViewPlus*)createAlertWithQuantityOption:(NSString*)bodyMessage initialValue:(int)initValue minValue:(int)minValue maxValue:(int)maxValue
{
    SCLAlertViewPlus *alert = [[SCLAlertViewPlus alloc] initWithNewWindow];
    
    [alert setIconTintColor:[UIColor whiteColor]];
    
    if (initValue < minValue){
        initValue = minValue;
    }else if (initValue > maxValue){
        initValue = maxValue;
    }
    
    alert.selectedQuantity = initValue;
    alert.minQuantity = minValue;
    alert.maxQuantity = maxValue;
    
    [alert.labelTitle setFont:[UIFont boldSystemFontOfSize:20.0]];
    [alert.viewText setFont:[UIFont systemFontOfSize:16.0]];
    [alert setButtonsTextFontFamily:[UIFont boldSystemFontOfSize:16.0].fontName withSize:16.0];
    alert.showAnimationType = SCLAlertViewShowAnimationSlideInFromTop;//SlideInFromTop;
    alert.hideAnimationType = SCLAlertViewHideAnimationSlideOutToBottom;//SlideOutToBottom;
    alert.backgroundType = SCLAlertViewBackgroundShadow;
    
    CGFloat alertWidth = 216.0;
    CGRect textRect = [bodyMessage boundingRectWithSize:CGSizeMake(alertWidth, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}
                                                context:nil];
    
    //Label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10.0, alertWidth, textRect.size.height)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:16.0];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = bodyMessage;
    
    //View Options
    UIView *viewControls = [[UIView alloc] initWithFrame:CGRectMake(0.0, label.frame.size.height + 20.0, alertWidth, 40)];
    viewControls.backgroundColor = nil;
    //
    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeSystem];
    b1.frame = CGRectMake(36.0, 2, 36.0, 36.0);
    b1.backgroundColor = nil;
    [b1 setTitle:@"" forState:UIControlStateNormal];
    [b1 setImage:[[UIImage imageNamed:@"icon-remove"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    b1.tintColor = [UIColor colorWithRed:95.0/255.0 green:96.0/255.0 blue:98.0/255.0 alpha:1.0];
    [b1 addTarget:alert action:@selector(removeQuantity) forControlEvents:UIControlEventTouchUpInside];
    //
    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeSystem];
    b2.frame = CGRectMake((alertWidth - 72.0), 2, 36.0, 36.0);
    b2.backgroundColor = nil;
    [b2 setTitle:@"" forState:UIControlStateNormal];
    [b2 setImage:[[UIImage imageNamed:@"icon-add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    b2.tintColor = [UIColor colorWithRed:95.0/255.0 green:96.0/255.0 blue:98.0/255.0 alpha:1.0];
    [b2 addTarget:alert action:@selector(addQuantity) forControlEvents:UIControlEventTouchUpInside];
    //
    alert.lblQuantity = [[UILabel alloc] initWithFrame:CGRectMake(72.0, 2.0, (alertWidth - 144.0), 36.0)];
    alert.lblQuantity.font = [UIFont boldSystemFontOfSize:22.0];
    alert.lblQuantity.backgroundColor = [UIColor whiteColor];
    alert.lblQuantity.textColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
    alert.lblQuantity.textAlignment = NSTextAlignmentCenter;
    alert.lblQuantity.text = [NSString stringWithFormat:@"%i", alert.selectedQuantity];
    //
    [viewControls addSubview:b1];
    [viewControls addSubview:alert.lblQuantity];
    [viewControls addSubview:b2];
    
    //CustomView
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, alertWidth, (10.0 + label.frame.size.height + 10.0 + viewControls.frame.size.height + 20.0))];
    [subView addSubview:label];
    [subView addSubview:viewControls];
    //
    [alert addCustomView:subView];
    
    return alert;
}

- (void)addQuantity
{
    if (selectedQuantity < maxQuantity){
        selectedQuantity += 1;
    }
    lblQuantity.text = [NSString stringWithFormat:@"%i", selectedQuantity];
}

- (void)removeQuantity
{
    if (selectedQuantity > minQuantity){
        selectedQuantity -= 1;
    }
    lblQuantity.text = [NSString stringWithFormat:@"%i", selectedQuantity];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
