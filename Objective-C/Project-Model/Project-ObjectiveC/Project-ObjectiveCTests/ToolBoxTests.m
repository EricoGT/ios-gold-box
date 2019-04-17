//
//  ToolBoxTests.m
//  Project-ObjectiveCTests
//
//  Created by Erico Teixeira - Terceiro on 17/04/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <XCTest/XCTest.h>
//
#import "ToolBox.h"

#define TOOLBOXTESTS_SAMPLEFILENAME @"alert.mp3"

@interface ToolBoxTests : XCTestCase

@property(nonatomic, assign) BOOL sampleFileAvailable;

@end

@implementation ToolBoxTests

@synthesize sampleFileAvailable;

+(void)setUp {
    [super setUp];
    // This is the setUp() class method.
    // It is called before the first test method begins.
    // Set up any overall initial state here.
    
    //Adicionando arquivo de teste na pasta do usuário
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:TOOLBOXTESTS_SAMPLEFILENAME];
    NSString *finalPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:TOOLBOXTESTS_SAMPLEFILENAME];
    [fileManager copyItemAtPath:finalPath toPath:dbPath error:nil];
}

+ (void)tearDown {
    [super tearDown];
    // This is the tearDown() class method.
    // It is called after all test methods complete.
    // Perform any overall cleanup here.
    
    //Removendo arquivo de teste da pasta do usuário
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *filePath = [documentsDir stringByAppendingPathComponent:TOOLBOXTESTS_SAMPLEFILENAME];
    [fileManager removeItemAtPath:filePath error:nil];
}

#pragma mark -

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    [super tearDown];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

#pragma mark - • TOOL BOX

- (void)testToolBoxVersion
{
    __block NSString *version = [ToolBox toolBoxHelper_classVersionInfo];
    
    //method specific teardownBlock:
    [self addTeardownBlock:^{
        NSLog(@"%@ >> teardownBlock >> %@", NSStringFromSelector(_cmd), version);
    }];
    
    XCTAssertTrue((version != nil) && (![version isEqualToString:@""]));
}


#pragma mark - • APPLICATION HELPER

- (void)testApplicationHelper_VersionBundle
{
    __block NSString *vBundle = [ToolBox applicationHelper_VersionBundle];
    
    //method specific teardownBlock:
    [self addTeardownBlock:^{
        NSLog(@"%@ >> teardownBlock >> %@", NSStringFromSelector(_cmd), vBundle);
    }];
    
    XCTAssertTrue((vBundle != nil) && (![vBundle isEqualToString:@""]));
}

- (void)testApplicationHelper_AppName
{
    __block NSString *appName = [ToolBox applicationHelper_AppName];
    
    //method specific teardownBlock:
    [self addTeardownBlock:^{
        NSLog(@"%@ >> teardownBlock >> %@", NSStringFromSelector(_cmd), appName);
    }];
    
    XCTAssertTrue((appName != nil) && (![appName isEqualToString:@""]));
}

- (void)testApplicationHelper_InstalationDataForSimulator
{
    __block NSString *iData = [ToolBox applicationHelper_InstalationDataForSimulator];
    
    //method specific teardownBlock:
    [self addTeardownBlock:^{
        NSLog(@"%@ >> teardownBlock >> %@", NSStringFromSelector(_cmd), iData);
    }];
    
    XCTAssertTrue((iData != nil) && (![iData isEqualToString:@""]));
}

- (void)testApplicationHelper_FileSize1
{
    //Arquivo existe:
    __block NSString *fileSize = [ToolBox applicationHelper_FileSize:TOOLBOXTESTS_SAMPLEFILENAME];
    
    //method specific teardownBlock:
    [self addTeardownBlock:^{
        NSLog(@"%@ >> teardownBlock >> %@", NSStringFromSelector(_cmd), fileSize);
    }];
    
    XCTAssertTrue( ![fileSize isEqualToString:@""] );
}

- (void)testApplicationHelper_FileSize2
{
    //Arquivo não existente:
    __block NSString *fileSize = [ToolBox applicationHelper_FileSize:@"xxxxxx"];
    
    //method specific teardownBlock:
    [self addTeardownBlock:^{
        NSLog(@"%@ >> teardownBlock >> %@", NSStringFromSelector(_cmd), fileSize);
    }];
    
    XCTAssertTrue( [fileSize isEqualToString:@""] );
}

- (void)testApplicationHelper_VerifyFile1
{
    //Arquivo existente:
    __block BOOL fileExists = [ToolBox applicationHelper_VerifyFile:TOOLBOXTESTS_SAMPLEFILENAME];
    
    //method specific teardownBlock:
    [self addTeardownBlock:^{
        NSLog(@"%@ >> teardownBlock >> %@", NSStringFromSelector(_cmd), (fileExists ? @"YES" : @"NO"));
    }];
    
    XCTAssertTrue( fileExists );
}

- (void)testApplicationHelper_VerifyFile2
{
    //Arquivo não existente:
    __block BOOL fileExists = [ToolBox applicationHelper_VerifyFile:@"xxxxxx"];
    
    //method specific teardownBlock:
    [self addTeardownBlock:^{
        NSLog(@"%@ >> teardownBlock >> %@", NSStringFromSelector(_cmd), (fileExists ? @"YES" : @"NO"));
    }];
    
    XCTAssertTrue( !fileExists );
}

#pragma mark -

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
