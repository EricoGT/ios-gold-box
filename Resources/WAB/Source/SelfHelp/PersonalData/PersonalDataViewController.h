//
//  PersonalDataViewController.h
//  Walmart
//
//  Created by Renan on 4/16/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseViewController.h"
#import "WMButtonRounded.h"

@class WMFloatLabelMaskedTextField, WMButton, User, FormAlertView, ChangePasswordViewController;

@protocol personalDataDelegate <NSObject>
@optional
- (void)saveUserPersonalDataSucessWithUserData:(User *)userPersonalData;
@end

@interface PersonalDataViewController : WMBaseViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *validationFields;
@property (weak, nonatomic) IBOutlet UISwitch *switchReceiveNews;


@property (weak, nonatomic) IBOutlet UIButton *btMale;
@property (weak, nonatomic) IBOutlet UIButton *btFemale;
@property (weak, nonatomic) IBOutlet WMButtonRounded *btChangePassword;
@property (weak, nonatomic) IBOutlet WMButtonRounded *btSaveChanges;

@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtName;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtDocument;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtBirthDate;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtEmail;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtTelephone;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtCelphone;

@property (strong, nonatomic) NSString *alertMsg;

@property (nonatomic, strong) User *userPersonalData;
@property (nonatomic, strong) ChangePasswordViewController *changePasswordScreen;

@property (weak) id <personalDataDelegate> delegate;

- (void)loadUserPersonalDataSuccess:(User *)userPersonalData;
- (void)loadUserPersonalDataFailure:(NSString *)error;

- (void)setupWithPersonalData:(User *)userPersonalData;
- (NSArray *)validateAndGetInvalidFields;

- (void)alertField:(UIView *)view color:(CGColorRef)color;
- (void)unalertView:(UIView *)view;

- (void)saveChanges;
- (void)saveUserPersonalDataSuccess;
- (void)saveUserPersonalDataFailureWithError:(NSString *)error;

- (IBAction)malePressed:(id)sender;
- (IBAction)femalePressed:(id)sender;
- (IBAction)changePasswordPressed:(id)sender;
- (IBAction)highlightGenderButton:(UIButton *)button;
- (IBAction)unhighlightGenderButton:(UIButton *)button;
- (IBAction)saveChangesPressed:(id)sender;

@end
