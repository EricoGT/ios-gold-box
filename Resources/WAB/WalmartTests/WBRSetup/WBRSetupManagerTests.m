//
//  WBRSetupTests.m
//  Walmart
//
//  Created by Marcelo Santos on 3/16/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBRSetupManager.h"
#import "ModelSetup.h"
#import "ModelAlert.h"
#import "OCMock.h"

@interface WBRSetupManagerTests : XCTestCase
@property (nonatomic, strong) ModelSetup *setupModel;
@end

@interface WBRSetupManager (Tests)
@end

@implementation WBRSetupManagerTests

- (void)setUp {
    [super setUp];
    
    NSString *fileName = @"setup";
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    //Send to model
    _setupModel = [[ModelSetup new] initWithData:jsonData error:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetAlert {
    
    ModelAlert *modelAlert = _setupModel.alert;
    
    [WBRSetupManager getAlert:^(ModelAlert *alertModel) {
        
        XCTAssertEqualObjects(modelAlert.block, alertModel.block);
        XCTAssertEqualObjects(modelAlert.message, alertModel.message);
        XCTAssertEqualObjects(modelAlert.url, alertModel.url);
        XCTAssertEqualObjects(modelAlert.version, alertModel.version);
        XCTAssertEqualObjects(modelAlert.system, alertModel.system);
        XCTAssertEqualObjects(modelAlert.title, alertModel.title);
        XCTAssertEqualObjects(modelAlert.buttonOk, alertModel.buttonOk);
        XCTAssertEqualObjects(modelAlert.buttonCancel, alertModel.buttonCancel);
        
    } failure:^(NSDictionary *dictError) {
    }];
}

- (void)testGetBaseImages {
    
    ModelBaseImages *modelBaseImages = self.setupModel.baseImages;
    [WBRSetupManager getBaseImages:^(ModelBaseImages *baseImagesModel) {
        XCTAssertEqualObjects(modelBaseImages.products, baseImagesModel.products);
        XCTAssertEqualObjects(modelBaseImages.showcases, baseImagesModel.showcases);
    } failure:^(NSDictionary *dictError) {
    }];
}

- (void)testBaseImages {
    
    ModelBaseImages *modelBaseImages = self.setupModel.baseImages;
    [WBRSetupManager getBaseImages:^(ModelBaseImages *baseImagesModel) {
        ModelBaseImages *baseImagesModelSetup = [WBRSetupManager baseImages];
        XCTAssertEqualObjects(modelBaseImages.products, baseImagesModelSetup.products);
        XCTAssertEqualObjects(modelBaseImages.showcases, baseImagesModelSetup.showcases);
        
    } failure:^(NSDictionary *dictError) {
    }];
}

- (void)testGetServices {
    
    ModelServices *modelServices = _setupModel.services;
    [WBRSetupManager getServices:^(ModelServices *servicesModel) {
        XCTAssertEqualObjects(modelServices.showDepartmentsOnMenu, servicesModel.showDepartmentsOnMenu);
        XCTAssertEqualObjects(modelServices.paymentByBankSlip, servicesModel.paymentByBankSlip);
        XCTAssertEqualObjects(modelServices.isCouponEnabled, servicesModel.isCouponEnabled);
        XCTAssertEqualObjects(modelServices.showWarranties, servicesModel.showWarranties);
    } failure:^(NSDictionary *dictError) {
    }];
}

- (void)testGetSkin {
    
    ModelSkin *modelSkin = _setupModel.skin;
    
    [WBRSetupManager getSkin:^(ModelSkin *skinModel) {
        
        XCTAssertEqualObjects(modelSkin.bgColor.r, skinModel.bgColor.r);
        XCTAssertEqualObjects(modelSkin.bgColor.g, skinModel.bgColor.g);
        XCTAssertEqualObjects(modelSkin.bgColor.b, skinModel.bgColor.b);
        XCTAssertEqualObjects(modelSkin.bgColor.a, skinModel.bgColor.a);
        
        XCTAssertEqualObjects(modelSkin.textShowcaseColor.r, skinModel.textShowcaseColor.r);
        XCTAssertEqualObjects(modelSkin.textShowcaseColor.g, skinModel.textShowcaseColor.g);
        XCTAssertEqualObjects(modelSkin.textShowcaseColor.b, skinModel.textShowcaseColor.b);
        XCTAssertEqualObjects(modelSkin.textShowcaseColor.a, skinModel.textShowcaseColor.a);
        
    } failure:^(NSDictionary *dictError) {
    }];
}

- (void)testGetSplash {
    
    ModelSplash *modelSplash = _setupModel.splash;
    
    [WBRSetupManager getSplash:^(ModelSplash *splashModel) {
        
        XCTAssertEqualObjects(modelSplash.bgColor.r, splashModel.bgColor.r);
        XCTAssertEqualObjects(modelSplash.bgColor.g, splashModel.bgColor.g);
        XCTAssertEqualObjects(modelSplash.bgColor.b, splashModel.bgColor.b);
        XCTAssertEqualObjects(modelSplash.bgColor.a, splashModel.bgColor.a);
        
        XCTAssertEqualObjects(modelSplash.image, splashModel.image);
        
    } failure:^(NSDictionary *dictError) {
    }];
}

- (void)testGetErrata {
    
    ModelErrata *modelErrata = _setupModel.errata;
    
    [WBRSetupManager getErrata:^(ModelErrata *errataModel) {
        
        XCTAssertEqualObjects(modelErrata.title, errataModel.title);
        
    } failure:^(NSDictionary *dictError) {
    }];
}

- (void)testGetBanners {
    
    ModelBanner *modelBanner = _setupModel.banners;
    
    [WBRSetupManager getBanners:^(ModelBanner *bannerModel) {
        
        XCTAssertEqualObjects(modelBanner.top, bannerModel.top);
        
    } failure:^(NSDictionary *dictError) {
    }];
}

@end
