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
#pragma mark - • APP OPTIONS (menu de configurações do aplicativo)
//=======================================================================================================
//NOTE: ericogt >> Itens que terminam com underline (_) terão o ID do usuário concatenado (são keys particulares)
#define APP_OPTION_KEY_SOUNDEFFECTS_STATUS @"app_options_key_soundeffects_status_"
#define APP_OPTION_KEY_TIMELINE_AUTO_PLAYVIDEOS @"app_options_key_timeline_auto_playvideos_"
#define APP_OPTION_KEY_TIMELINE_START_VIDEO_MUTED @"app_options_key_timeline_start_video_muted_"
#define APP_OPTION_KEY_TIMELINE_AUTO_EXPANDPOSTS @"app_options_key_timeline_auto_expandposts_"
#define APP_OPTION_KEY_TIMELINE_USE_VIDEO_CACHE @"app_options_key_timeline_use_video_cache_"
//
#define APP_OPTION_KEY_SHOWCASE_TIP_MASKUSER @"app_options_key_showcase_tip_mask_user_"
#define APP_OPTION_KEY_3DVIEWER_TIP_AR @"app_options_key_3dviewer_tip_ar_"
#define APP_OPTION_KEY_3DVIEWER_TIP_PLACEABLEAR @"app_options_key_3dviewer_tip_placeablear_"
#define APP_OPTION_KEY_3DVIEWER_TIP_SCENE @"app_options_key_3dviewer_tip_scene_"
#define APP_OPTION_KEY_3DVIEWER_TIP_IMAGETARGET @"app_options_key_3dviewer_tip_imagetarget_"

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


//===================================================================================================
#pragma mark - • COLORS
//===================================================================================================

#define COLOR_DEF_RED [UIColor colorWithRed:188.0/255.0 green:15.0/255.0 blue:24.0/255.0 alpha:1]
#define COLOR_DEF_GREEN [UIColor colorWithRed:34.0/255.0 green:162.0/255.0 blue:120.0/255.0 alpha:1]
#define COLOR_DEF_BLUE [UIColor colorWithRed:25.0/255.0 green:96.0/255.0 blue:161.0/255.0 alpha:1]
#define COLOR_DEF_YELLOW [UIColor colorWithRed:247.0/255.0 green:202.0/255.0 blue:46.0/255.0 alpha:1]
#define COLOR_DEF_ORANGE [UIColor colorWithRed:253.0/255.0 green:133.0/255.0 blue:50.0/255.0 alpha:1]
#define COLOR_DEF_GRAY [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1]
#define COLOR_DEF_DARKGRAY [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1]
#define COLOR_DEF_PURPLE [UIColor colorWithRed:124.0/255.0 green:11.0/255.0 blue:117.0/255.0 alpha:1]
#define COLOR_DEF_WHITE [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]
#define COLOR_DEF_LIGHTYELLOW [UIColor colorWithRed:250.0/255.0 green:254.0/255.0 blue:192.0/255.0 alpha:1.0]
#define COLOR_DEF_LIGHTOLIVE [UIColor colorWithRed:236.0/255.0 green:241.0/255.0 blue:236.0/255.0 alpha:1.0]
#define COLOR_DEF_OLIVE [UIColor colorWithRed:175.0/255.0 green:194.0/255.0 blue:175.0/255.0 alpha:1.0]
#define COLOR_DEF_LIGHTSALMON [UIColor colorWithRed:255.0/255.0 green:215.0/255.0 blue:214.0/255.0 alpha:1.0]
#define COLOR_DEF_SALMON [UIColor colorWithRed:225.0/255.0 green:94.0/255.0 blue:91.0/255.0 alpha:1.0]
