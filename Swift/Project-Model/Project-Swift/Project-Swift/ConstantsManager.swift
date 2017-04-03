//
//  Constants.swift
//  Project-Swift
//
//  Created by Erico GT on 3/31/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import UIKit

class ConstantsManager{
    
    //MARK: - PLIST KEYS (User Defaults)
    //=======================================================================================================
    public static let PLISTKEY_ACCESS_TOKEN:String = "project_access_token"
    
    
    //MARK: - SYSTEM NOTIFICATIONS (para observers)
    //=======================================================================================================
    public static let SYSNOT_UPDATE_MAIN_MENU:String = "sysnot_update_main_menu"
    public static let SYSNOT_LOCATION_SERVICE_UPDATE_WITHOUT_GEOCODEINFO:String = "sysnot_location_service_update_without_geocodeinfo"
    public static let SYSNOT_LOCATION_SERVICE_UPDATE_WITH_GEOCODEINFO:String = "sysnot_location_service_update_with_geocodeinfo"
    
    
    //MARK: - CHAVES DICIONARIOS (body, response e afins)
    //=======================================================================================================
    public static let AUTHENTICATE_PASSWORD_KEY:String = "password"
    
    
    //MARK: - ENDPOINTS SERVICOS WEB
    //=======================================================================================================
    public static let SERVICE_URL_AUTHENTICATE_USER:String = "/api/v1/authenticate/login"
    
    
    //MARK: - DIRETORIOS E ARQUIVOS:
    //=======================================================================================================
    public static let PROFILE_DIRECTORY:String = "AS_ProfileData"
    public static let PROFILE_FILE:String = "AS_ProfileFile"
    
    
    //MARK: - CONSTANTS / TIME:
    //=======================================================================================================
    public static let ANIMA_TIME_SUPER_FAST:Double = 0.1
    public static let ANIMA_TIME_FAST:Double = 0.2
    public static let ANIMA_TIME_NORMAL:Double = 0.3
    public static let ANIMA_TIME_SLOW:Double = 0.5
    public static let ANIMA_TIME_SLOOOW:Double = 1.0
    //
    public static let FONT_MYRIAD_PRO_REGULAR:String = "MyriadPro-Regular"
    public static let FONT_MYRIAD_PRO_SEMIBOLD:String = "MyriadPro-Semibold"
    public static let FONT_MYRIAD_PRO_BOLD:String = "MyriadPro-Bold"
    public static let FONT_MYRIAD_PRO_ITALIC:String = "MyriadPro-It"
    //
    public static let FONT_SIZE_TEXT_FIELDS:Double = 15.0
    public static let FONT_SIZE_BUTTON_TITLE:Double = 18.0
    
    
    //MARK: - COMPUTED
    //=======================================================================================================
    public final var iPad:Bool{
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    public final var iPhone:Bool{
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    public final var ScreenSize:CGSize{
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
}
