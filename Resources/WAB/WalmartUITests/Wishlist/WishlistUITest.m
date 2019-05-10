//
//  WishlistUITest.m
//  Walmart
//
//  Created by Bruno Delgado on 3/14/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface WishlistUITest : XCTestCase

@end

@implementation WishlistUITest

- (void)setUp
{
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Open Wishlist
//- (void)testOpenWishlist
//{
//    
//    
//    XCUIApplication *app = [[XCUIApplication alloc] init];
//    [app.buttons[@"btnSales"] tap];
//    [app.navigationBars[@"WALHomeView"].buttons[@"ic navbar heart"] tap];
//    
//    if (app.buttons[@"btnLogin"].exists) {
//        XCUIElementQuery *elementsQuery = app.scrollViews.otherElements;
//        XCUIElement *txtpasswordSecureTextField = elementsQuery.secureTextFields[@"txtPassword"];
//        [txtpasswordSecureTextField tap];
//        [txtpasswordSecureTextField typeText:@"123456"];
//        [elementsQuery.buttons[@"btnLogin"] tap];
//    }
//    
//    [app.navigationBars[@"Favoritos"].buttons[@"ic ignore"] tap];
//    [app.navigationBars[@"WALHomeView"].buttons[@"ico menu"] tap];
//    
//    if (app.buttons[@"Entre ou Cadastre-se"].hittable) {
//        
//        [app.buttons[@"Entre ou Cadastre-se"] tap];
//        
//        XCUIElementQuery *elementsQuery = app.scrollViews.otherElements;
//        XCUIElement *txtpasswordSecureTextField = elementsQuery.secureTextFields[@"txtPassword"];
//        [txtpasswordSecureTextField tap];
//        [txtpasswordSecureTextField typeText:@"123456"];
//        [elementsQuery.buttons[@"btnLogin"] tap];
//        [app.navigationBars[@"WALHomeView"].buttons[@"ico menu"] tap];
//    }
//    
//    [app.staticTexts[@"txtUserName"] tap];
//    [app.scrollViews.otherElements.tables.staticTexts[@"Sair"] tap];
//    
//    
//    //Check for tutorial
////    XCUIApplication *app = [[XCUIApplication alloc] init];
////    XCUIElement *offersTutorialButton = app.buttons[@"Ver ofertas"];
////    if (offersTutorialButton.exists) [offersTutorialButton tap];
////                                         
////    [[[XCUIApplication alloc] init].navigationBars[@"logo walmart home"].buttons[@"ic navbar heart"] tap];
//    
//    
//    
////    XCUIApplication *app = [[XCUIApplication alloc] init];
////    [app.buttons[@"btnSales"] tap];
////    
////    XCUIElement *walhomeviewNavigationBar = app.navigationBars[@"WALHomeView"];
////    [walhomeviewNavigationBar.buttons[@"ico menu"] tap];
////    [walhomeviewNavigationBar.buttons[@"ic navbar heart"] tap];
////    [app.navigationBars[@"Favoritos"].buttons[@"ic ignore"] tap];
//    
//}

- (void)testLoginInWishlist
{
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"btnSales"] tap];
    
    XCUIElement *walhomeviewNavigationBar = app.navigationBars[@"WALHomeView"];
    [walhomeviewNavigationBar.buttons[@"ic navbar heart"] tap];
    
    XCUIElementQuery *elementsQuery = app.scrollViews.otherElements;
    XCUIElement *txtpasswordSecureTextField = elementsQuery.secureTextFields[@"txtPassword"];
    [txtpasswordSecureTextField tap];
    [txtpasswordSecureTextField typeText:@"123456"];
    [elementsQuery.buttons[@"btnLogin"] tap];
    [app.navigationBars[@"Favoritos"].buttons[@"ic ignore"] tap];
    [walhomeviewNavigationBar.buttons[@"ico menu"] tap];
    [app.staticTexts[@"txtUserName"] tap];
    [elementsQuery.tables.staticTexts[@"Sair"] tap];
    
    
    
//    XCUIApplication *app = [[XCUIApplication alloc] init];
//    XCUIElement *offersTutorialButton = app.buttons[@"Ver ofertas"];
//    if (offersTutorialButton.exists) [offersTutorialButton tap];
//    
//    [app.navigationBars[@"logo walmart home"].buttons[@"ic navbar heart"] tap];
//    
//    XCUIElementQuery *elementsQuery = app.scrollViews.otherElements;
//    XCUIElement *eMailCpfOuCnpjTextField = elementsQuery.textFields[@"E-mail, CPF ou CNPJ"];
//    XCUIElement *senhaSecureTextField = elementsQuery.secureTextFields[@"Senha"];
//    
//    //Check if we need to login
//    if (eMailCpfOuCnpjTextField.exists && senhaSecureTextField.exists)
//    {
//        [eMailCpfOuCnpjTextField typeText:@"teste@teste.com"];
//        [senhaSecureTextField typeText:@"123456"];
//        [elementsQuery.buttons[@"Entrar"] tap];
//        
//        NSPredicate *existsPredicate = [NSPredicate predicateWithFormat:@"exists == false"];
//        [self expectationForPredicate:existsPredicate evaluatedWithObject:eMailCpfOuCnpjTextField handler:nil];
//    }
//    
//    XCUIElementQuery *cellQuery = [app.tables.cells containingType:XCUIElementTypeButton identifier:@"ic fav selector"];
//    if (cellQuery.count > 0)
//    {
//        XCUIElement *selectWishlistProductButton = [cellQuery elementBoundByIndex:0];
//        [selectWishlistProductButton tap];
//        [app.buttons[@"Remover"] tap];
//        //[app.buttons[@"Excluir"] tap];
//    }
}



@end
