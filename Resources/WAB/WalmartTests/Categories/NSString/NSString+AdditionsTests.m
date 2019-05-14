//
//  NSString+AdditionsTests.m
//  WalmartTests
//
//  Created by Murilo Alves Alborghette on 11/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Additions.h"

@interface NSString_AdditionsTests : XCTestCase

@end

@implementation NSString_AdditionsTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSizeForTextWithFontAndConstrainedToSize {

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.text = @"test";
    
    NSString *text = label.text;
    CGSize size = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    UIFont *font = label.font;
    
    if ((size.width == 0) && ((size.height == 0))) size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    CGRect expectedFrame = [text boundingRectWithSize:size
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil]
                                              context:nil];
    CGSize theSize = CGSizeMake(expectedFrame.size.width, expectedFrame.size.height);
    CGSize approximateSize = CGSizeMake(ceil(theSize.width), ceil(theSize.height));
    
    CGSize textSize = [text sizeForTextWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)];
    
    XCTAssertTrue(CGSizeEqualToSize(approximateSize, textSize));
}

- (void)testStringByRemovingAccentuation {
    NSString *textWithAccentuation = @"acentuação";
    XCTAssertTrue([[textWithAccentuation stringByRemovingAccentuation] isEqualToString:@"acentuacao"]);
}

@end
