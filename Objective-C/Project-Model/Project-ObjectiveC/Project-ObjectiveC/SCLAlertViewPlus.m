//
//  SCLAlertViewPlus.m
//  AHK-100anos
//
//  Created by Erico GT on 10/7/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "SCLAlertViewPlus.h"

@implementation SCLAlertViewPlus

- (instancetype)initWithNewWindow
{
    self = [super initWithNewWindow];
    return self;
}

- (instancetype)init
{
    self = [super initWithNewWindow];
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

+ (SCLAlertViewPlus*)createDefaultAlert
{
    SCLAlertViewPlus *alert = [[SCLAlertViewPlus alloc] initWithNewWindow];
    [alert.labelTitle setFont:[UIFont fontWithName:FONT_MYRIAD_PRO_SEMIBOLD size:20.0]];
    [alert.viewText setFont:[UIFont fontWithName:FONT_MYRIAD_PRO_REGULAR size:16.0]];
    [alert setButtonsTextFontFamily:FONT_MYRIAD_PRO_SEMIBOLD withSize:16.0];
    alert.showAnimationType = SCLAlertViewShowAnimationSlideInFromTop;//SlideInFromTop;
    alert.hideAnimationType = SCLAlertViewHideAnimationSlideOutToBottom;//SlideOutToBottom;
    alert.backgroundType = SCLAlertViewBackgroundShadow;
    return alert;
}

+ (SCLAlertViewPlus*)createRichAlertWithMessage:(NSString*)bodyMessage imagesArray:(NSArray<UIImage*>*)images animationTimePerFrame:(NSTimeInterval)aTime
{
    SCLAlertViewPlus *alert = [[SCLAlertViewPlus alloc] initWithNewWindow];
    [alert.labelTitle setFont:[UIFont fontWithName:FONT_MYRIAD_PRO_SEMIBOLD size:20.0]];
    [alert.viewText setFont:[UIFont fontWithName:FONT_MYRIAD_PRO_REGULAR size:16.0]];
    [alert setButtonsTextFontFamily:FONT_MYRIAD_PRO_SEMIBOLD withSize:16.0];
    alert.showAnimationType = SCLAlertViewShowAnimationSlideInFromTop;//SlideInFromTop;
    alert.hideAnimationType = SCLAlertViewHideAnimationSlideOutToBottom;//SlideOutToBottom;
    alert.backgroundType = SCLAlertViewBackgroundShadow;
    //
    CGFloat alertWidth = 216.0;
    CGRect textRect = [bodyMessage boundingRectWithSize:CGSizeMake(alertWidth, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_MYRIAD_PRO_REGULAR size:16.0]}
                                         context:nil];
    
   
    //Label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10.0, alertWidth, textRect.size.height)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont fontWithName:FONT_MYRIAD_PRO_REGULAR size:16.0];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = bodyMessage;
    
    //ImageView
    UIImageView *imvView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, label.frame.size.height + 20.0, alertWidth, 120)];
    imvView.backgroundColor = [UIColor redColor];
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

@end
