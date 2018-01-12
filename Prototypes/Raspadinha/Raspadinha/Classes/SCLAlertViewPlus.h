//
//  SCLAlertViewPlus.h
//  AHK-100anos
//
//  Created by Erico GT on 10/7/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "SCLAlertView.h"

#define UIColorFromHEX(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//#ifdef DEFAULT_WINDOW_WIDTH
//// Already defined - undefine
//#undef DEFAULT_WINDOW_WIDTH
//#endif
//#define DEFAULT_WINDOW_WIDTH 420

@interface SCLAlertViewPlus : SCLAlertView

typedef enum {SCLAlertButtonType_Neutral, SCLAlertButtonType_Normal, SCLAlertButtonType_Question, SCLAlertButtonType_Destructive} enumSCLAlertButtonType;

@property (nonatomic, assign, readonly) int selectedQuantity;

- (SCLButton *)addButton:(NSString *)title withType:(enumSCLAlertButtonType)type actionBlock:(SCLActionBlock)action;

- (SCLButton *)addButton:(NSString *)title withType:(enumSCLAlertButtonType)type  validationBlock:(SCLValidationBlock)validationBlock actionBlock:(SCLActionBlock)action;

- (SCLButton *)addButton:(NSString *)title withType:(enumSCLAlertButtonType)type  target:(id)target selector:(SEL)selector;

+ (SCLAlertViewPlus*)createRichAlertWithMessage:(NSString*)bodyMessage imagesArray:(NSArray<UIImage*>*)images animationTimePerFrame:(NSTimeInterval)aTime;

+ (SCLAlertViewPlus*)createAlertWithQuantityOption:(NSString*)bodyMessage initialValue:(int)initValue minValue:(int)minValue maxValue:(int)maxValue;

@end
