//
//  LoginUITest.m
//  Walmart
//
//  Created by Marcelo Santos on 3/14/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface LoginUITest : XCTestCase

@end

@implementation LoginUITest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLogin {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"btnSales"] tap];
    [app.navigationBars[@"WALHomeView"].buttons[@"ico menu"] tap];
    
    if (app.staticTexts[@"txtUserName"].hittable) {
        [app.staticTexts[@"txtUserName"] tap];
        [app.scrollViews.otherElements.tables.staticTexts[@"Sair"] tap];
        [app.navigationBars[@"WALHomeView"].buttons[@"ico menu"] tap];
    }
    
    [app.buttons[@"Entre ou Cadastre-se"] tap];
    
    XCUIElementQuery *elementsQuery = app.scrollViews.otherElements;
    XCUIElement *txtpasswordSecureTextField = elementsQuery.secureTextFields[@"txtPassword"];
    [txtpasswordSecureTextField tap];
    [txtpasswordSecureTextField typeText:@"123456"];
    [elementsQuery.buttons[@"btnLogin"] tap];
    
    
//    XCUIApplication *app = [[XCUIApplication alloc] init];
//    XCUIElement *icoMenuButton = app.navigationBars[@"logo walmart home"].buttons[@"ico menu"];
//    [icoMenuButton tap];
//    
//    [app.buttons[@"Entre ou Cadastre-se"] tap]; //This button is always present.
//    
//    XCUIElementQuery *elementsQuery = app.scrollViews.otherElements;
//    
//    if (!elementsQuery.textFields[@"E-mail, CPF ou CNPJ"].exists) { //FIRST, Verify if there is an email field
//        
//        [app.scrollViews.otherElements.buttons[@"Sair"] tap]; //Make logout
//        
//        [icoMenuButton tap]; //Open Menu
//        [app.buttons[@"Entre ou Cadastre-se"] tap]; //Tap Enter Subscription
//    }
//    
//    //Test login
//    [self performAutoLoginWithQueryElements:elementsQuery];
//    
//    //Let's add a timeout interval until connection to be completed
//    NSPredicate *exists = [NSPredicate predicateWithFormat:@"exists == 1"];
//    [self expectationForPredicate:exists evaluatedWithObject:icoMenuButton handler:nil];
//    [self waitForExpectationsWithTimeout:10 handler:nil];
//    
//    [icoMenuButton tap]; //Open Menu
//    
//    [app.buttons[@"Entre ou Cadastre-se"] tap];
//    
//    XCTAssertFalse(elementsQuery.textFields[@"E-mail, CPF ou CNPJ"].exists, @"The user is not logged!");
}

- (void)testLogOff {
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"btnSales"] tap];
    [app.navigationBars[@"WALHomeView"].buttons[@"ico menu"] tap];
    
    if (app.buttons[@"Entre ou Cadastre-se"].hittable) {
        
        [app.buttons[@"Entre ou Cadastre-se"] tap];
        
        XCUIElementQuery *elementsQuery = app.scrollViews.otherElements;
        XCUIElement *txtpasswordSecureTextField = elementsQuery.secureTextFields[@"txtPassword"];
        [txtpasswordSecureTextField tap];
        [txtpasswordSecureTextField typeText:@"123456"];
        [elementsQuery.buttons[@"btnLogin"] tap];
        [app.navigationBars[@"WALHomeView"].buttons[@"ico menu"] tap];
    }
    
    [app.staticTexts[@"txtUserName"] tap];
    [app.scrollViews.otherElements.tables.staticTexts[@"Sair"] tap];

    
//    XCUIApplication *app = [[XCUIApplication alloc] init];
//    XCUIElement *icoMenuButton = app.navigationBars[@"logo walmart home"].buttons[@"ico menu"];
//    [icoMenuButton tap];
//    
//    [app.buttons[@"Entre ou Cadastre-se"] tap]; //This button is always present.
//    
//    XCUIElementQuery *elementsQuery = app.scrollViews.otherElements;
//    
//    if (elementsQuery.textFields[@"E-mail, CPF ou CNPJ"].exists) { //FIRST, Verify if there is an email field
//        
//        [self performAutoLoginWithQueryElements:elementsQuery];
//        
//        //Let's add a timeout interval until connection to be completed
//        NSPredicate *exists = [NSPredicate predicateWithFormat:@"exists == 1"];
//        [self expectationForPredicate:exists evaluatedWithObject:icoMenuButton handler:nil];
//        [self waitForExpectationsWithTimeout:10 handler:nil];
//        
//        [icoMenuButton tap]; //Open Menu
//        
//        [app.buttons[@"Entre ou Cadastre-se"] tap]; //Tap Enter Subscription
//    }
//    
//    [app.scrollViews.otherElements.buttons[@"Sair"] tap]; //Make logout
//    
//    [icoMenuButton tap]; //Open Menu
//    
//    [app.buttons[@"Entre ou Cadastre-se"] tap];
//    
//    XCTAssertFalse(!elementsQuery.textFields[@"E-mail, CPF ou CNPJ"].exists, @"The user is logged!");
}

- (void)performAutoLoginWithQueryElements:(XCUIElementQuery *) elementsQuery  {
    
    XCUIElement *emailTextField = elementsQuery.textFields[@"E-mail, CPF ou CNPJ"];
    [emailTextField tap];
    [emailTextField typeText:@" "];
    [elementsQuery.buttons[@"Clear text"] tap];
    [emailTextField typeText:@"wmteste@mobile.com"];
    
    XCUIElement *senhaSecureTextField = elementsQuery.secureTextFields[@"Senha"];
    [senhaSecureTextField tap];
    [senhaSecureTextField typeText:@"123456"];
    [elementsQuery.buttons[@"Entrar"] tap];
}

@end
