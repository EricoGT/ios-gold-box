//
//  WMPwdStrengthProgressView.h
//  Walmart
//
//  Created by Renan Cargnin on 3/30/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

#import "PwdStrengthEnum.h"

@interface WMPwdStrengthView : WMView

@property (weak, nonatomic) IBOutlet UITextField *textField;

- (void)setPwdString:(NSString *)pwdString;

@end
