//
//  OFBlockVersion.m
//  Walmart
//
//  Created by Marcelo Santos on 11/13/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "OFBlockVersion.h"

@implementation OFBlockVersion

@synthesize delegate;

- (void) blockScreenCheck:(NSDictionary *) content {
    
    //Alerts from server for Block or not
    LogInfo(@"Block Version? :%i", [self checkIfScreenShouldBeBlocked:content]);
    
    if ([content objectForKey:@"initialAlert"]) {
        
        NSDictionary *alertInfos = [content objectForKey:@"initialAlert"];
        NSString *urlToGo = [alertInfos objectForKey:@"url"];
        NSString *msgAlert = [alertInfos objectForKey:@"message"];
        
        if ([self checkIfScreenShouldBeBlocked:content]) {
            //Block Screen
            if (![urlToGo isEqualToString:@""] && ![msgAlert isEqualToString:@""]) {
                LogInfo(@"Show Alert with button to the link and the Message");
                NSDictionary *dictTemp = @{@"message"   : msgAlert,
                                           @"url"       : urlToGo,
                                           @"showCancel": @NO,
                                           @"textCancel": @"",
                                           @"showAction": @YES,
                                           @"textAction": @"Abrir URL"
                                           };
                [[self delegate] showMessage:dictTemp];
            }
            else if (![msgAlert isEqualToString:@""]) {
                LogInfo(@"Show Message and Button OK blocking app: - block the user");
                NSDictionary *dictTemp = @{@"message"   :msgAlert,
                                           @"url"       : urlToGo,
                                           @"showCancel": @NO,
                                           @"textCancel": @"",
                                           @"showAction": @NO,
                                           @"textAction": @""
                                           };
                [[self delegate] showMessage:dictTemp];
            }
            else {
                LogInfo(@"Nothing to show - Go to Home");
                
                [[self delegate] blockAlertAction];
            }
        }
        else {
            //First, verify if there is a message and/or link to show to the user
            //Show alert
            if (![urlToGo isEqualToString:@""] && ![msgAlert isEqualToString:@""]) {
                LogInfo(@"Show Alert with Button to the link and Button to the home and Message");
                NSDictionary *dictTemp = @{@"message"   :msgAlert,
                                           @"url"       : urlToGo,
                                           @"showCancel": @YES,
                                           @"textCancel": @"Continuar",
                                           @"showAction": @YES,
                                           @"textAction": @"Abrir URL"
                                           };
                [[self delegate] showMessage:dictTemp];
            }
            else if (![msgAlert isEqualToString:@""]) {
                LogInfo(@"Show Message and Button to the Continue");
                NSDictionary *dictTemp = @{@"message"   :msgAlert,
                                           @"url"       : urlToGo,
                                           @"showCancel": @NO,
                                           @"textCancel": @"",
                                           @"showAction": @YES,
                                           @"textAction": @"Continuar"
                                           };
                [[self delegate] showMessage:dictTemp];
            }
            else {
                LogInfo(@"Nothing to do!");
                
                [[self delegate] blockAlertAction];
            }
        }
    }
    else {
        //Missing key 'initialAlert' from splash
        LogErro(@"Missing 'initialAlert' from splash");
        
        [[self delegate] blockAlertAction];
    }
}


- (BOOL) checkIfScreenShouldBeBlocked:(NSDictionary *) content {
    
    //0: Liberar acesso
    //1: Bloquear acesso
    
    BOOL blockScreen = NO;
    
    if ([content objectForKey:@"initialAlert"]) {
        
        if ([[[content objectForKey:@"initialAlert"] objectForKey:@"status"] intValue] == 1) {
            LogInfo(@"SCREEN LOCKED!");
            blockScreen = YES;
        } else {
            LogInfo(@"SCREEN UNLOCKED!");
        }
    }
    
    return blockScreen;
}

@end
