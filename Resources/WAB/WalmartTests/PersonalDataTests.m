//
//  PersonalDataTests.m
//  Walmart
//
//  Created by Renan Cargnin on 5/4/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PersonalDataViewController.h"
#import "WMFloatLabelMaskedTextField.h"
//#import "UserPersonalData.h"
#import "PhoneModel.h"
#import "PersonalDataBuilder.h"
#import "WMButton.h"
#import "FeedbackAlertView.h"

@interface PersonalDataTests : XCTestCase {
    PersonalDataViewController *vc;
    UserPersonalData *data;
}

@end

@implementation PersonalDataTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    vc = [[PersonalDataViewController alloc] initWithNibName:@"PersonalDataViewController" bundle:nil];
    vc.view.hidden = NO;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Loading

//- (void)DISABLED_testLoadUserPersonalDataFailure {
//    [vc loadUserPersonalDataFailure:@"Test"];
//    
//    XCTAssertFalse(vc.loader.isAnimating);
//    XCTAssertTrue(vc.scrollView.hidden);
////    XCTAssertNotNil(vc.retryView);
////    XCTAssertEqual(vc.retryView.delegate, vc);
////    XCTAssertTrue(vc.view.center.x == vc.retryView.center.x && vc.view.center.y == vc.retryView.center.y);
////    XCTAssertEqual(vc.view, vc.retryView.superview);
//}
//
//- (void)DISABLED_testLoadUserPersonalDataSuccess {
//    data = [PersonalDataBuilder basePersonalData];
//    [vc loadUserPersonalDataSuccess:data];
//    
//    XCTAssertFalse(vc.loader.isAnimating);
//    XCTAssertFalse(vc.scrollView.hidden);
//    
//    NSString *fullName = [NSString stringWithFormat:@"%@ %@", data.firstName, data.lastName];
//    XCTAssertTrue([vc.txtName.text isEqualToString:fullName]);
//    
//    if ([data.gender isEqualToString:@"MALE"]) {
//        XCTAssertFalse(vc.btMale.enabled);
//        XCTAssertTrue(vc.btFemale.enabled);
//    }
//    else if ([data.gender isEqualToString:@"FEMALE"]) {
//        XCTAssertFalse(vc.btFemale.enabled);
//        XCTAssertTrue(vc.btMale.enabled);
//    }
//    else {
//        XCTAssertTrue(vc.btMale.enabled);
//        XCTAssertTrue(vc.btFemale.enabled);
//    }
//    
//    XCTAssertTrue([vc.txtDocument.raw isEqualToString:data.document]);
//    
//    PhoneModel *telephone;
//    PhoneModel *cellphone;
//    
//    for (PhoneModel *phone in data.phones) {
//        if ([phone.type isEqualToString:@"RESIDENTIAL"]) {
//            telephone = phone;
//        }
//        else if ([phone.type isEqualToString:@"MOBILE"]) {
//            cellphone = phone;
//        }
//    }
//    
//    NSString *fullTelephone = [NSString stringWithFormat:@"%@%@", telephone.areaCode, telephone.number];
//    XCTAssertTrue([vc.txtTelephone.raw isEqualToString:fullTelephone]);
//
//    NSString *fullCelphone = [NSString stringWithFormat:@"%@%@", cellphone.areaCode, cellphone.number];
//    XCTAssertTrue([vc.txtCelphone.raw isEqualToString:fullCelphone]);
//    
//    XCTAssertFalse(vc.txtEmail.enabled);
//    XCTAssertTrue([vc.txtEmail.text isEqualToString:data.email]);
//    XCTAssertTrue(vc.switchReceiveNews.on == [[data.preferences objectForKey:@"email"] boolValue]);
//}

#pragma mark - Gender Buttons

- (void)DISABLED_testMaleButtonPress {
    [vc malePressed:nil];
    XCTAssertTrue(vc.btMale.layer.borderWidth == 0.0f);
    XCTAssertFalse(vc.btMale.enabled);
    XCTAssertTrue(vc.btFemale.enabled);
}

- (void)DISABLED_testFemaleButtonPress {
    [vc femalePressed:nil];
    XCTAssertTrue(vc.btFemale.layer.borderWidth == 0.0f);
    XCTAssertFalse(vc.btFemale.enabled);
    XCTAssertTrue(vc.btMale.enabled);
}

#pragma mark - Validation

//- (void)DISABLED_testNameValidation {
//    data = [PersonalDataBuilder basePersonalData];
//    data.firstName = @"";
//    data.lastName = @"";
//    
//    [vc setupWithPersonalData:data];
//    
//    NSArray *invalidFields = [vc validateAndGetInvalidFields];
//    
//    XCTAssertTrue([invalidFields containsObject:vc.txtName]);
//    XCTAssertTrue([vc.alertMsg isEqualToString:PERSONAL_DATA_WARNING_NAME]);
//}
//
//- (void)DISABLED_testLastNameValidation {
//    data = [PersonalDataBuilder basePersonalData];
//    data.lastName = @"";
//    
//    [vc setupWithPersonalData:data];
//    
//    NSArray *invalidFields = [vc validateAndGetInvalidFields];
//    
//    XCTAssertTrue([invalidFields containsObject:vc.txtName]);
//    XCTAssertTrue([vc.alertMsg isEqualToString:PERSONAL_DATA_WARNING_NAME]);
//}
//
//- (void)DISABLED_testGenderValidation {
//    data = [PersonalDataBuilder basePersonalData];
//    data.gender = @"";
//    
//    [vc setupWithPersonalData:data];
//    
//    NSArray *invalidFields = [vc validateAndGetInvalidFields];
//    
//    XCTAssertTrue([invalidFields containsObject:vc.btMale]);
//    XCTAssertTrue([invalidFields containsObject:vc.btFemale]);
//    XCTAssertTrue([vc.alertMsg isEqualToString:PERSONAL_DATA_WARNING_SEX]);
//}
//
//- (void)DISABLED_testEmptyPhonesValidation {
//    data = [PersonalDataBuilder basePersonalData];
//    data.phones = nil;
//    [vc setupWithPersonalData:data];
//    
//    NSArray *invalidFields = [vc validateAndGetInvalidFields];
//    
//    XCTAssertTrue([invalidFields containsObject:vc.txtTelephone]);
//    XCTAssertTrue([invalidFields containsObject:vc.txtCelphone]);
//    XCTAssertTrue([vc.alertMsg isEqualToString:PERSONAL_DATA_WARNING_TELEPHONE]);
//}
//
//- (void)DISABLED_testInvalidTelephoneValidation {
//    data = [PersonalDataBuilder basePersonalData];
//    
//    for (PhoneModel *phone in data.phones) {
//        if ([phone.type isEqualToString:@"RESIDENTIAL"]) {
//            phone.areaCode = @"11";
//            phone.number = @"1234";
//        }
//    }
//    
//    [vc setupWithPersonalData:data];
//    
//    NSArray *invalidFields = [vc validateAndGetInvalidFields];
//    
//    XCTAssertTrue([invalidFields containsObject:vc.txtTelephone]);
//    XCTAssertTrue([vc.alertMsg isEqualToString:PERSONAL_DATA_WARNING_INVALID_TELEPHONE]);
//}
//
//- (void)DISABLED_testInvalidCellphoneValidation {
//    data = [PersonalDataBuilder basePersonalData];
//    
//    for (PhoneModel *phone in data.phones) {
//        if ([phone.type isEqualToString:@"MOBILE"]) {
//            phone.areaCode = @"11";
//            phone.number = @"1234";
//        }
//    }
//    
//    [vc setupWithPersonalData:data];
//    
//    NSArray *invalidFields = [vc validateAndGetInvalidFields];
//    
//    XCTAssertTrue([invalidFields containsObject:vc.txtCelphone]);
//    XCTAssertTrue([vc.alertMsg isEqualToString:PERSONAL_DATA_WARNING_INVALID_TELEPHONE]);
//}

#pragma mark - Save Changes

- (void)testSaveChanges {
    XCTAssertTrue(vc.scrollView.hidden);
    XCTAssertTrue(vc.loader.isAnimating);
}

- (void)testSaveChangesSuccess {
    [vc saveUserPersonalDataSuccess];
    XCTAssertFalse(vc.loader.isAnimating);
}

- (void)testSaveChangesFailure {
    [vc saveUserPersonalDataFailureWithError:@"Test"];
    XCTAssertFalse(vc.loader.isAnimating);
//    XCTAssertNotNil(vc.retryAlert);
//    XCTAssertEqual(vc.retryAlert.delegate, vc);
}

#pragma mark - Alerts

- (void)testAlertField {
    UIView *alertView = vc.txtName;
    CGColorRef color = RGBA(26, 117, 207, 1).CGColor;
    [vc alertField:alertView color:color];
    
    XCTAssertTrue(CGColorEqualToColor(alertView.layer.borderColor, color));
    XCTAssertTrue(alertView.layer.borderWidth == 1.0f);
}

- (void)testUnalertField {
    UIView *alertView = vc.txtName;
    [vc unalertView:alertView];
    
    if ([alertView isKindOfClass:[WMFloatLabelMaskedTextField class]]) {
        WMFloatLabelMaskedTextField *textField = (WMFloatLabelMaskedTextField *)alertView;
        XCTAssertTrue(CGColorEqualToColor([textField defaultBorderColor], textField.layer.borderColor));
    }
    else {
        XCTAssertTrue(CGColorEqualToColor(alertView.layer.borderColor, RGBA(232, 232, 232, 1).CGColor));
    }
}

@end
