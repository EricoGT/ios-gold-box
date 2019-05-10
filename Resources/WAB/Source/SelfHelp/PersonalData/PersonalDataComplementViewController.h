//
//  PersonalDataComplementViewController.h
//  Walmart
//
//  Created by Marcelo Santos on 12/8/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMFloatLabelMaskedTextField.h"

@class User, WMFloatLabelMaskedTextField;

@protocol personalComplementDelegate <NSObject>
@optional
- (void)successFromComplement;
@end

@interface PersonalDataComplementViewController : WMBaseViewController

@property (weak) id <personalComplementDelegate> delegate;
@property (nonatomic, strong) NSDictionary *dictDataPersonal;
@property (nonatomic, strong) User *userPersonalData;

@property (weak, nonatomic) IBOutlet UIButton *btCancel;

@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtCpf;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtNasc;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtPhone;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtPhoneMobile;

- (PersonalDataComplementViewController *)initWithPersonalDataDict:(NSDictionary *)dictDataPersonal delegate:(id <personalComplementDelegate>)delegate;

- (void) applyRulesToShowForm:(NSDictionary *) dictData;

- (void) validateFields;

@property BOOL isCpf;
@property BOOL isCnpj;
@property BOOL isAllOk;

@end
