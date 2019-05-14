//
//  WMParser.h
//  Ofertas
//
//  Created by Marcelo Santos on 7/11/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDSSqlite.h"

@protocol parseDelegate <NSObject>
@optional
//Splash Set
- (void) dictSplashSet:(NSDictionary *) content;
//Skin Set
- (void) dictSkinSet:(NSDictionary *) content;
//Product Set
- (void) dictProductSet:(NSArray *) content;
//Error DB
- (void) errorParseOrDatabase:(NSString *) msg;
//Home Screen
- (void) dictHomeSet:(NSDictionary *)infos;
//Category Screen
- (void) dictCategorySet:(NSArray *) content;
//Auth Token
- (void) dictAuthSet:(NSDictionary *) content;
//Shipment Address
- (void) dictShipmentAddress: (NSDictionary *) content;
- (void) dictShipmentAddressList:(NSArray *)addresses;
//New Cart
- (void) parsedNewCart:(NSDictionary *) parsedCart;
//Extended Warranty
- (void) dictExtended:(NSArray *) content;
- (void) errorParseExtended;

@end

@interface WMParser : NSObject <databaseDelegate> {
    
    __weak id <parseDelegate> delegate;
    NSString *skinCurrent;
    NSDictionary *dictNewCart;
}

@property (weak) id delegate;
@property (retain) NSString *skinCurrent;

- (void) parseJsonSplash:(NSString *) content;
- (void) parseJsonSkin:(NSString *) content;
- (void) parseJsonProduct:(NSString *) content;
- (void) parseJsonCategory:(NSString *)content;
- (void) parseJsonShipment:(NSString *) content;

- (void) parseNewCart:(NSString *) cart withError:(BOOL) withError andSeller:(NSArray *) seller  andTypeError:(NSString *) typeError andErrorCode:(NSString *) errorCode;

- (void) parseExtended:(NSString *) content;

+ (NSDictionary *)dictionaryFromJSONFileWithName:(NSString *)fileName;
+ (NSArray *)arrayFromJSONFileWithName:(NSString *)fileName;

@end
