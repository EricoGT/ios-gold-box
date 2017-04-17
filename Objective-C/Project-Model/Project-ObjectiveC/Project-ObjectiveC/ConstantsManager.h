//
//  ConstantsManager.h
//  DefaultModelProject
//
//  Created by Erico GT on 9/15/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//=======================================================================================================
#pragma mark - • MACROS
//=======================================================================================================
//Instância da aplicação (pode ser utilizada em qualquer view da aplicação, bastando importar 'AppDelegate')
#define AppD ((AppDelegate *)[UIApplication sharedApplication].delegate)

//Conversor
#define UIColorFromHEX(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//=======================================================================================================
#pragma mark - • DOMINIO APP (constantes de projeto)
//=======================================================================================================
#define APP_DOMAIN @"br.com.atlantic.Project-ObjectiveC"


//=======================================================================================================
#pragma mark - • PLIST KEYS (User Defaults)
//=======================================================================================================
#define PLISTKEY_ACCESS_TOKEN @"project_access_token"


//=======================================================================================================
#pragma mark - • SYSTEM NOTIFICATIONS (para observers)
//=======================================================================================================
#define SYSNOT_UPDATE_MAIN_MENU @"sysnot_update_main_menu"


//=======================================================================================================
#pragma mark - • CHAVES DICIONARIOS (body, response e afins)
//=======================================================================================================
#define AUTHENTICATE_HTTP_HEADER_FIELD @"Authorization"
#define AUTHENTICATE_ACCESS_TOKEN @"access_token"


//=======================================================================================================
#pragma mark - • ENDPOINTS SERVICOS WEB
//=======================================================================================================
#define SERVICE_URL_AUTHENTICATE_STORE @"/api/v1/authenticate/login"
#define SERVER_URL_DEV @"dev"
#define SERVER_URL_PROD @"prod"

//=======================================================================================================
#pragma mark - • DIRETORIOS E ARQUIVOS:
//=======================================================================================================
#define DATABASE_DEFAULT_NAME @"PO_DataBase_Default_Name"
#define PROFILE_DIRECTORY @"PO_ProfileData"
#define PROFILE_FILE @"PO_ProfileFile"
#define DOWNLOAD_DIRECTORY @"Downloads"
#define DOWNLOAD_FILE @"FileName"


//=======================================================================================================
#pragma mark - • CONSTANTS / TIME:
//=======================================================================================================
#define ANIMA_TIME_SUPER_FAST 0.1
#define ANIMA_TIME_FAST 0.2
#define ANIMA_TIME_NORMAL 0.3
#define ANIMA_TIME_SLOW 0.5
#define ANIMA_TIME_SLOOOW 1.0
//
#define FONT_MYRIAD_PRO_REGULAR @"MyriadPro-Regular"
#define FONT_MYRIAD_PRO_SEMIBOLD @"MyriadPro-Semibold"
#define FONT_MYRIAD_PRO_BOLD @"MyriadPro-Bold"
#define FONT_MYRIAD_PRO_ITALIC @"MyriadPro-It"
//
#define IMAGE_MAXIMUM_SIZE_SIDE 200


//=======================================================================================================
#pragma mark - • COMPUTED
//=======================================================================================================
#define CM_IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define CM_IPHONE ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
#define CM_SCREEN_SIZE ([UIScreen mainScreen].bounds.size)

