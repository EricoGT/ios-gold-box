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
    public static let FONT_SAN_FRANCISCO_BLACK:String = "SFUIDisplay-Black"
    public static let FONT_SAN_FRANCISCO_BOLD:String = "SFUIDisplay-Bold"
    public static let FONT_SAN_FRANCISCO_HEAVY:String = "SFUIDisplay-Heavy"
    public static let FONT_SAN_FRANCISCO_LIGHT:String = "SFUIDisplay-Light"
    public static let FONT_SAN_FRANCISCO_MEDIUM:String = "SFUIDisplay-Medium"
    public static let FONT_SAN_FRANCISCO_REGULAR:String = "SFUIDisplay-Regular"
    public static let FONT_SAN_FRANCISCO_SEMIBOLD:String = "SFUIDisplay-Semibold"
    public static let FONT_SAN_FRANCISCO_THIN:String = "SFUIDisplay-Thin"
    public static let FONT_SAN_FRANCISCO_ULTRALIGHT:String = "SFUIDisplay-Ultralight"
    //
    public static let FONT_SIZE_TEXT_FIELDS:CGFloat = 15.0
    public static let FONT_SIZE_LABEL_MINI_PLACEHOLDER:CGFloat = 12.0
    public static let FONT_SIZE_LABEL_BIG:CGFloat = 17.0
    public static let FONT_SIZE_LABEL_NORMAL:CGFloat = 16.0
    public static let FONT_SIZE_LABEL_SMALL:CGFloat = 15.0
    public static let FONT_SIZE_LABEL_MINI:CGFloat = 13.0
    public static let FONT_SIZE_BUTTON_TITLE:CGFloat = 16.0
    public static let FONT_SIZE_LABEL_TITLE:CGFloat = 17.0
    public static let FONT_SIZE_LABEL_HOME_TITLE:CGFloat = 20.0
    
    //MARK: - TEXT_MASKS
    
    public static let TEXT_MASK_DEFAULT_WILD_SYMBOL:String = "#"
    public static let TEXT_MASK_DEFAULT_CHARS_SET:String = "()/.:-_|+"
    public static let TEXT_MASK_CEP:String = "#####-###"
    public static let TEXT_MASK_PHONE:String = "(##) ####-####"
    public static let TEXT_MASK_CELLPHONE:String = "(##) #####-####"
    public static let TEXT_MASK_GENERIC_PHONE:String = "(##) #########"
    public static let TEXT_MASK_CPF:String = "###.###.###-##"
    public static let TEXT_MASK_CNPJ:String = "##.###.###/####-##"
    public static let TEXT_MASK_BIRTHDATE:String = "##/##/####"
    
    //MARK: - COMPUTED
    //=======================================================================================================
    public final var iPad:Bool{
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    public final var iPhone:Bool{
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    public final var screenSize:CGSize{
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
}
