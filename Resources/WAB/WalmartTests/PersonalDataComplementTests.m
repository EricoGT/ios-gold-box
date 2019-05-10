//
//  PersonalDataComplementTests.m
//  Walmart
//
//  Created by Marcelo Santos on 12/14/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PersonalDataComplementViewController.h"
#import "WMFloatLabelMaskedTextField.h"

@interface PersonalDataComplementTests : XCTestCase {
    
    PersonalDataComplementViewController *pdct;
}
@end

@implementation PersonalDataComplementTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    pdct = [[PersonalDataComplementViewController alloc] initWithNibName:@"PersonalDataComplementViewController" bundle:nil];
    pdct.view.hidden = NO;
}

- (void) testViewDidLoad {
    
    XCTAssertTrue(pdct.isCpf);
    XCTAssertFalse(pdct.isCnpj);
    
//    float radiusObj = 4;
    
//    XCTAssertEqualWithAccuracy(pdct.btCancel.layer.cornerRadius, radiusObj, .5, @"The radius for this button should be 4.0");
//    XCTAssertTrue(pdct.btCancel.layer.masksToBounds);
}

- (void) testApplyRulesToShowForm {
    
    //Case without Document and Phone
    NSDictionary *dictTest1 = @{@"hasDocument":@NO,
                               @"hasPhone":@NO
                               };
    
    [pdct applyRulesToShowForm:dictTest1];
    
    XCTAssertFalse(pdct.txtCpf.hidden);
    XCTAssertFalse(pdct.txtNasc.hidden);
    XCTAssertFalse(pdct.txtPhone.hidden);
    XCTAssertFalse(pdct.txtPhoneMobile.hidden);
    
    //Case without phone
    NSDictionary *dictTest2 = @{@"hasDocument":@YES,
                 @"hasPhone":@NO
                 };
    
    [pdct applyRulesToShowForm:dictTest2];
    
    XCTAssertTrue(pdct.txtCpf.hidden);
    XCTAssertTrue(pdct.txtNasc.hidden);
    XCTAssertFalse(pdct.txtPhone.hidden);
    XCTAssertFalse(pdct.txtPhoneMobile.hidden);
    
    //Case without document
    NSDictionary *dictTest3 = @{@"hasDocument":@NO,
                                @"hasPhone":@YES
                                };
    
    [pdct applyRulesToShowForm:dictTest3];
    
    XCTAssertFalse(pdct.txtCpf.hidden);
    XCTAssertFalse(pdct.txtNasc.hidden);
    XCTAssertTrue(pdct.txtPhone.hidden);
    XCTAssertTrue(pdct.txtPhoneMobile.hidden);
    
}

- (void) DISABLED_testApplyMask {
    
    //Delegates
    //Phones
    XCTAssertNotNil(pdct.txtPhone.delegate);
    XCTAssertNotNil(pdct.txtPhoneMobile.delegate);
    //CPF
    XCTAssertNotNil(pdct.txtCpf.delegate);
    
    //Masks
    XCTAssertTrue([pdct.txtCpf.mask isEqualToString:@"###.###.###-##"]);
    XCTAssertTrue([pdct.txtPhone.mask isEqualToString:@"(##) #### ####"]);
    XCTAssertTrue([pdct.txtPhoneMobile.mask isEqualToString:@"(##) ##### ####"]);
    
    XCTAssertFalse(pdct.txtNasc.pastingEnabled);
    XCTAssertFalse(pdct.txtNasc.cuttingEnabled);
}

- (void) testValidateFields {
    
    //Cases:
    
    //When wrong CPF
    [pdct.txtCpf setHidden:NO];
    [pdct.txtPhone setHidden:YES];
    [pdct.txtCpf setText:@"052.641.038-77"];
    [pdct validateFields];
    XCTAssertFalse(pdct.isAllOk);
    //When correct CPF
    [pdct.txtCpf setHidden:NO];
    [pdct.txtPhone setHidden:YES];
    [pdct.txtCpf setText:@"052.641.038-87"];
    [pdct validateFields];
    XCTAssertTrue(pdct.isAllOk);

    //When wrong Phone
    [pdct.txtCpf setHidden:YES];
    [pdct.txtPhone setHidden:NO];
    [pdct.txtPhone setText:@"(19) 3301-77"];
    [pdct validateFields];
    XCTAssertFalse(pdct.isAllOk);
    //When correct Phone
    [pdct.txtCpf setHidden:YES];
    [pdct.txtPhone setHidden:NO];
    [pdct.txtPhone setText:@"(19) 3301-3300"];
    [pdct validateFields];
    XCTAssertTrue(pdct.isAllOk);

    //When correct Phone Mobile
    [pdct.txtCpf setHidden:YES];
    [pdct.txtPhone setHidden:NO];
    [pdct.txtPhoneMobile setText:@"(19) 99123-1629"];
    [pdct validateFields];
    XCTAssertTrue(pdct.isAllOk);
    //When wrong Phone Mobile
    [pdct.txtCpf setHidden:YES];
    [pdct.txtPhone setHidden:NO];
    [pdct.txtPhoneMobile setText:@"(19) 9940-58"];
    [pdct validateFields];
    XCTAssertFalse(pdct.isAllOk);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
}

@end
