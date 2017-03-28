//
//  ToolBox.swift
//  Etna
//
//  Created by Erico GT on 3/21/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import UIKit

private extension String {
    
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    var stringByDeletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    var stringByDeletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }
}

private extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
            //iPhone
            case "iPhone1,1":    return  "iPhone 1G"
            case "iPhone1,2":    return  "iPhone 3G"
            case "iPhone2,1":    return  "iPhone 3GS"
            case "iPhone3,1":    return  "iPhone 4"
            case "iPhone3,2":    return  "iPhone 4 (GSM)"
            case "iPhone3,3":    return  "iPhone 4 (CDMA)"
            case "iPhone4,1":    return  "iPhone 4S"
            case "iPhone5,1":    return  "iPhone 5 (GSM)"
            case "iPhone5,2":    return  "iPhone 5 (GSM+CDMA)"
            case "iPhone5,3":    return  "iPhone 5C (GSM)"
            case "iPhone5,4":    return  "iPhone 5C (GSM+CDMA)"
            case "iPhone6,1":    return  "iPhone 5S (GSM)"
            case "iPhone6,2":    return  "iPhone 5S (GSM+CDMA)"
            case "iPhone7,1":    return  "iPhone 6 Plus"
            case "iPhone7,2":    return  "iPhone 6"
            case "iPhone8,1":    return  "iPhone 6S"
            case "iPhone8,2":    return  "iPhone 6S Plus"
            case "iPhone8,3":    return  "iPhone SE (GSM+CDMA)"
            case "iPhone8,4":    return  "iPhone SE (GSM)"
            case "iPhone9,1":    return  "iPhone 7"
            case "iPhone9,2":    return  "iPhone 7 Plus"
            case "iPhone9,3":    return  "iPhone 7"
            case "iPhone9,4":    return  "iPhone 7 Plus"
                
            //iPod
            case "iPod1,1":      return  "iPod Touch 1G"
            case "iPod2,1":      return  "iPod Touch 2G"
            case "iPod3,1":      return  "iPod Touch 3G"
            case "iPod4,1":      return  "iPod Touch 4G"
            case "iPod5,1":      return  "iPod Touch 5G"
            case "iPod6,1":      return  "iPod Touch 6G"
                
            //iPad
            case "iPad1,1":      return  "iPad"
            case "iPad2,1":      return  "iPad 2 (WiFi)"
            case "iPad2,2":      return  "iPad 2 (GSM)"
            case "iPad2,3":      return  "iPad 2 (CDMA)"
            case "iPad2,4":      return  "iPad 2 (WiFi)"
            case "iPad3,1":      return  "iPad 3 (WiFi)"
            case "iPad3,2":      return  "iPad 3 (GSM+CDMA)"
            case "iPad3,3":      return  "iPad 3 (GSM)"
            case "iPad3,4":      return  "iPad 4 (WiFi)"
            case "iPad3,5":      return  "iPad 4 (GSM)"
            case "iPad3,6":      return  "iPad 4 (GSM+CDMA)"
                
            //iPad Mini
            case "iPad2,5":      return  "iPad Mini (WiFi)"
            case "iPad2,6":      return  "iPad Mini (GSM)"
            case "iPad2,7":      return  "iPad Mini (GSM+CDMA)"
            case "iPad4,4":      return  "iPad Mini 2 (WiFi)"
            case "iPad4,5":      return  "iPad Mini 2 (Cellular)"
            case "iPad4,6":      return  "iPad Mini 2"
            case "iPad4,7":      return  "iPad Mini 3"
            case "iPad4,8":      return  "iPad Mini 3"
            case "iPad4,9":      return  "iPad Mini 3"
            case "iPad5,1":      return  "iPad Mini 4 (WiFi)"
            case "iPad5,2":      return  "iPad Mini 4 (Cellular)"
                
            //iPad Air
            case "iPad4,1":      return  "iPad Air (WiFi)"
            case "iPad4,2":      return  "iPad Air (Cellular)"
            case "iPad4,3":      return  "iPad Air"
            case "iPad5,3":      return  "iPad Air 2 (WiFi)"
            case "iPad5,4":      return  "iPad Air 2 (Cellular)"
                
            //iPad Pro
            case "iPad6,3":      return  "iPad Pro (9.7 inch, Wi-Fi)"
            case "iPad6,4":      return  "iPad Pro (9.7 inch, Wi-Fi+LTE)"
            case "iPad6,7":      return  "iPad Pro (12.9 inch, Wi-Fi)"
            case "iPad6,8":      return  "iPad Pro (12.9 inch, Wi-Fi+LTE)"
                
            //simulador
            case "i386":         return  "Simulator"
            case "x86_64":       return  "Simulator"
            
            //other
            default:             return identifier
        }
    }
}


private extension Calendar{
    
    var identifierString:String{
        
        switch identifier {
            
            case Identifier.gregorian:              return "gregorian"
                
            case Identifier.buddhist:               return "buddhist"
                
            case Identifier.chinese:                return "chinese"
                
            case Identifier.coptic:                 return "coptic"
                
            case Identifier.ethiopicAmeteMihret:    return "ethiopicAmeteMihret"
                
            case Identifier.ethiopicAmeteAlem:      return "ethiopicAmeteAlem"
                
            case Identifier.hebrew:                 return "hebrew"
                
            case Identifier.iso8601:                return "iso8601"
                
            case Identifier.indian:                 return "indian"
                
            case Identifier.islamic:                return "islamic"
                
            case Identifier.islamicCivil:           return "islamicCivil"
                
            case Identifier.japanese:               return "japanese"
                
            case Identifier.persian:                return "persian"
                
            case Identifier.republicOfChina:        return "republicOfChina"
                
            /// A simple tabular Islamic calendar using the astronomical/Thursday epoch of CE 622 July 15
            case Identifier.islamicTabular:         return "islamicTabular"
                
            /// The Islamic Umm al-Qura calendar used in Saudi Arabia. This is based on astronomical calculation, instead of tabular behavior.
            case Identifier.islamicUmmAlQura:       return "islamicUmmAlQura"
                
            default:                                return ""
            
        }
    }
}

enum ToolBoxComparationRule:Int {
    case Less = 1
    case Equal = 2
    case Greater = 3
    case LessOrEqual = 4
    case GreaterOrEqual = 5
}

class ToolBox: NSObject{
    
    //MARK: - DEFINES
    
    public static let DATE_BAR_ddMMM:String = "dd/MMM"
    public static let DATE_BAR_ddMMMyyyy:String = "dd/MMM/yyyy"
    public static let DATE_BAR_ddMMyyyy:String = "dd/MM/yyyy"
    public static let DATE_BAR_yyyyMMdd:String = "yyyy/MM/dd"
    public static let DATE_BAR_ddMMyyyy_HHmm:String = "dd/MM/yyyy HH:mm"
    public static let DATE_BAR_yyyyMMdd_HHmm:String = "yyyy/MM/dd HH:mm"
    public static let DATE_BAR_yyyyMMdd_HHmmss_Z:String = "yyyy/MM/dd HH:mm:ss Z"
    public static let DATE_BAR_ddMMyyyy_HHmmss_Z:String = "dd/MM/yyyy HH:mm:ss Z"
    public static let DATE_BAR_ddMMyyyy_at_HHmm:String = "dd/MM/yyyy 'às' HH:mm"
    public static let DATE_BAR_yyyyMMdd_T_HHmmssSSSZ:String = "yyyy/MM/dd'T'HH:mm:ss.SSSZ"
    //
    public static let DATE_HIFEN_ddMMM:String = "dd-MMM"
    public static let DATE_HIFEN_ddMMMyyyy:String = "dd-MMM-yyyy"
    public static let DATE_HIFEN_ddMMyyyy:String = "dd-MM-yyyy"
    public static let DATE_HIFEN_yyyyMMdd:String = "yyyy-MM-dd"
    public static let DATE_HIFEN_ddMMyyyy_HHmm:String = "dd-MM-yyyy HH:mm"
    public static let DATE_HIFEN_yyyyMMdd_HHmm:String = "yyyy-MM-dd HH:mm"
    public static let DATE_HIFEN_yyyyMMdd_HHmmss_Z:String = "yyyy-MM-dd HH:mm:ss Z"
    public static let DATE_HIFEN_ddMMyyyy_HHmmss_Z:String = "dd-MM-yyyy HH:mm:ss Z"
    public static let DATE_HIFEN_ddMMyyyy_at_HHmm:String = "dd-MM-yyyy 'às' HH:mm"
    public static let DATE_HIFEN_yyyyMMdd_T_HHmmssSSSZ:String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    //
    public static let DATE_DOT_ddMMM:String = "dd.MMM"
    public static let DATE_DOT_ddMMMyyyy:String = "dd.MMM.yyyy"
    public static let DATE_DOT_ddMMyyyy:String = "dd.MM.yyyy"
    public static let DATE_DOT_yyyyMMdd:String = "yyyy.MM.dd"
    public static let DATE_DOT_ddMMyyyy_HHmm:String = "dd.MM.yyyy HH:mm"
    public static let DATE_DOT_yyyyMMdd_HHmm:String = "yyyy.MM.dd HH:mm"
    public static let DATE_DOT_yyyyMMdd_HHmmss_Z:String = "yyyy.MM.dd HH:mm:ss Z"
    public static let DATE_DOT_ddMMyyyy_HHmmss_Z:String = "dd.MM.yyyy HH:mm:ss Z"
    public static let DATE_DOT_ddMMyyyy_at_HHmm:String = "dd.MM.yyyy 'às' HH:mm"
    public static let DATE_DOT_yyyyMMdd_T_HHmmssSSSZ:String = "yyyy.MM.dd'T'HH:mm:ss.SSSZ"
    //
    public static let DATE_NONE_yyyyMMddHHmmss:String = "yyyyMMddHHmmss"
    public static let DATE_TIME_HHmm:String = "HH.mm"
    public static let DATE_TIME_HHmmss:String = "HH.mm.ss"
    //
    public static let TOOLBOX_SYMBOL_DEFAULT_MONETARY:String = "R$"
    public static let TOOLBOX_SYMBOL_DEFAULT_VOLUME_LIQUID:String = "L"
    public static let TOOLBOX_SYMBOL_DEFAULT_VOLUME_SOLID:String = "m³"
    public static let TOOLBOX_SYMBOL_DEFAULT_DISTANCE:String = "KM"

    
    //MARK: - • TOOL BOX =======================================================================
    
    /** Retorna dados informativos sobre a versão corrente do utilitário 'ToolBox'.*/
    class func toolBoxHelper_classVersionInfo() -> String!{
        
        //OBS: Favor não apagar as linhas anteriores. Apenas comente para referência futura.
        return "Version: 7.0  |  Date: 21/03/2017  |  Autor: EricoGT  |  Note: Primeira versão em Swift.";
    }
    
    /** Verifica se o parâmetro referência é nulo.*/
    class func isNil(object:AnyObject?) -> Bool{
        if let _:AnyObject = object{
            return false
        }else{
            return true
        }
    }
    
    //MARK: - • APPLICATION HELPER =======================================================================
    
    /** Versão do aplicativo.*/
    class func applicationHelper_VersionBundle() -> String!{
        
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) - \(build)"
    }
    

    /** Retorna o caminho de instalação do app (útil para testes com simulador). Preferencialmente utilize no 'didFinishLaunchingWithOptions' do AppDelegate.*/
    class func applicationHelper_InstalationDataForSimulator() -> String!{
        
        return String.init(format: "\n\n---------- Logs ----------\nClasse: %@\nMétodo: %@\nLinha: %d\nDescrição: LOCAL SIMULATOR: %@\n---------- Logs ----------\n\n",
                           arguments: [String(describing: type(of: self)),
                            #function,
                            #line,
                            NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]])
    }
    
    
    /** Informa o tamanho de um dado arquivo (da pasta de documentos do usuário). Utiliza formatos: bytes, KB, MB, GB, TB, conforme necessidade.*/
    class func applicationHelper_FileSize(fileName: String!) -> String?{
        
        let paths:Array = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir:String = paths.first!
        let filePath:String = documentsDir.stringByAppendingPathComponent(path: fileName)
        var fileSize : UInt64
        
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: filePath)
            fileSize = attr[FileAttributeKey.size] as! UInt64
            //
            return self.toolBoxPrivate_TransformedValue(size: fileSize)
            
        } catch {
            print("Error >> applicationHelper_FileSize: \(error)")
            //
            return nil
        }
    }
    
    
    /** Verifica se um dado arquivo existe na pasta de documentos do usuário.*/
    class func applicationHelper_VerifyFile(fileName:String!) -> Bool{
        
        let paths:Array = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir:String = paths.first!
        let filePath:String = documentsDir.stringByAppendingPathComponent(path: fileName)
        let exists:Bool = FileManager.default.fileExists(atPath: filePath)
        //
        return exists
    }
    
    
    /** Salva arquivo (imagem, texto) na pasta de documentos do usuário.*/
    class func applicationHelper_SaveFile(data:NSData!, fileName:String!) -> Bool{
        
        let url:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let filePath:String = url.absoluteString.stringByAppendingPathComponent(path: fileName)
        //
        return data.write(toFile: filePath, atomically: true)
    }
    
    
    /** Carrega dados de um arquivo da pasta de documentos do usuário. Utilize extensão do arquivo, se existir.*/
    class func applicationHelper_LoadDataFromFile(fileName:String!) -> NSData?{
        
        let url:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let filePath:String = url.absoluteString.stringByAppendingPathComponent(path: fileName)
        
        do{
            let data:NSData = try NSData.init(contentsOfFile: filePath)
            //
            return data
        } catch{
            print("Error >> applicationHelper_LoadDataFromFile: \(error)")
            //
            return nil
        }
    }
    
    
    /** Renomeia um arquivo existente na pasta de documentos do usuário.*/
    class func applicationHelper_RenameFile(oldFileName:String!, newFileName:String!) -> Bool!{
        
        let paths:Array = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir:String = paths.first!
        let oldFilePath:String = documentsDir.stringByAppendingPathComponent(path: oldFileName)
        let newFilePath:String = documentsDir.stringByAppendingPathComponent(path: newFileName)
        
        do{
            try FileManager.default.moveItem(atPath: oldFilePath, toPath: newFilePath)
            //
            return true
        }catch{
            print("Error >> applicationHelper_RenameFile: \(error)")
            //
            return false
        }
    }
    
    
    /** Deleta um arquivo existente na pasta de documentos do usuário.*/
    class func applicationHelper_DeleteFile(fileName:String!) -> Bool{
        
        let paths:Array = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir:String = paths.first!
        let filePath:String = documentsDir.stringByAppendingPathComponent(path: fileName)
        
        if (FileManager.default.isDeletableFile(atPath: filePath)){
            
            do{
                try FileManager.default.removeItem(atPath: filePath)
                //
                return true
            }catch{
                print("Error >> applicationHelper_DeleteFile: \(error)")
                //
                return false
            }
        }
        
        return false
    }
    
    
    /** Copia um dado arquivo com um novo nome.*/
    class func applicationHelper_CopyFile(originalFileName:String!, copyFileName:String!) -> Bool{
        
        let paths:Array = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir:String = paths.first!
        let originalFilePath:String = documentsDir.stringByAppendingPathComponent(path: originalFileName)
        let copyFilePath:String = documentsDir.stringByAppendingPathComponent(path: copyFileName)
        
        do{
            try FileManager.default.copyItem(atPath: originalFilePath, toPath: copyFilePath)
            //
            return true
        }catch{
            print("Error >> applicationHelper_RenameFile: \(error)")
            //
            return false
        }
    }
    
    
    /** Clona um arquivo da aplicação para a pasta de documentos do usuário.*/
    class func applicationHelper_CloneFileFromBundleToUserDirectory(fileName:String!) -> Bool{
        
        let paths:Array = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir:String = paths.first!
        let filePathDocuments:String = documentsDir.stringByAppendingPathComponent(path: fileName)
        let filePathBundle:String = Bundle.main.path(forResource:fileName, ofType:nil)!
        
        do{
            try FileManager.default.copyItem(atPath: filePathBundle, toPath: filePathDocuments)
            //
            return true
        }catch{
            print("Error >> applicationHelper_CloneFileFromBundleToUserDirectory: \(error)")
            //
            return false
        }
    }
    
    
    //MARK: - • DEVICE HELPER =======================================================================
    
    /** Retorna o tamanho da tela do dispositivo (em points).*/
    class func deviceHelper_ScreenSize() -> CGRect{
        
        return UIScreen.main.bounds
    }
    
    
    /** Retorna o modelo do dispositivo.*/
    class func deviceHelper_Model() -> String{
        
        return UIDevice.current.modelName
    }
    
    
    /** Retorna o nome do dispositivo.*/
    class func deviceHelper_Name() -> String{
        
        return UIDevice.current.name
    }
    
    /** Busca o tamanho total de memória interna do dispositivo.*/
    class func deviceHelper_StorageCapacity() -> String{
        
        do{
            let attr = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            let fileSize:UInt64 = attr[FileAttributeKey.systemSize] as! UInt64
            //
            return self.toolBoxPrivate_TransformedValue(size: fileSize)
        }catch{
            return self.toolBoxPrivate_TransformedValue(size: 0)
        }
    }
    

    /** Busca o tamanho da memória livre disponível no dispositivo.*/
    class func deviceHelper_FreeMemorySpace() -> String{
        
        do{
            let attr = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            let fileSize:UInt64 = attr[FileAttributeKey.systemFreeSize] as! UInt64
            //
            return self.toolBoxPrivate_TransformedValue(size: fileSize)
        }catch{
            return self.toolBoxPrivate_TransformedValue(size: 0)
        }
    }
    
    
    /** Retorna a versão do SO.*/
    class func deviceHelper_SystemVersion() -> String{
        
        return UIDevice.current.systemVersion
    }
    
    
    /** Retorna a língua atual  do sistema.*/
    class func deviceHelper_SystemLanguage() -> String{
        
        let lang:String = NSLocale.current.languageCode!
        //
        return lang
    }
    
    
    /** Retorna o calendário atual do sistema.*/
    class func deviceHelper_SystemCalendar() -> String{
        
        let calendar:String = NSLocale.current.calendar.identifierString
        //
        return calendar
    }
    
    
    /** Retorna o código UUID.*/
    class func deviceHelper_IdentifierForVendor() -> String{
        
        let uuid:String = (UIDevice.current.identifierForVendor?.uuidString)!
        //
        return uuid
    }
    
    //MARK: - • DATE HELPER =======================================================================
    
    
    /** Converte texto para data. Utilizar constantes definidas na classe 'ToolBox'.*/
    class func dateHelper_DateFromString(dateString:String?, stringFormat:String!) -> Date?{
        
        if let str = dateString {
            
            let updatedString:String = str.replacingOccurrences(of: " 0000", with: " +0000")
            
            let dateFormatter:DateFormatter = DateFormatter.init()
            let calendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
            let enUSPOSIXLocale:Locale = Locale.init(identifier: "en_US_POSIX")
            //
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.calendar = calendar
            dateFormatter.dateFormat = stringFormat
            dateFormatter.locale = enUSPOSIXLocale
            //
            let date:Date = dateFormatter.date(from: updatedString)!
            //
            return date
            
        }else{
            return nil
        }
    }
    
    
    /** Converte um valor timestamp para data.*/
    class func dateHelper_DateFromTimeStamp(interval:TimeInterval) -> Date{
        
        return Date.init(timeIntervalSince1970: interval)
    }
    
    
    /** Converte data para texto. Utilizar constantes definidas na classe 'ToolBox'.*/
    class func dateHelper_StringFromDate(date:Date?, stringFormat:String!) -> String{
        
        if let d = date {
            
            let dateFormatter:DateFormatter = DateFormatter.init()
            let calendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
            let enUSPOSIXLocale:Locale = Locale.init(identifier: "en_US_POSIX")
            //
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.calendar = calendar
            dateFormatter.dateFormat = stringFormat
            dateFormatter.locale = enUSPOSIXLocale
            //
            let strDate:String = dateFormatter.string(from: d)
            //
            return strDate
        }else{
            return ""
        }
    }
    
    /** Converte data para texto, considerando um TimeZone específico. Utilizar constantes definidas na classe 'ToolBox'.*/
    class func dateHelper_StringFromDate(date:Date?, stringFormat:String!, timeZone:TimeZone?) -> String{
        
        if let d = date {
            
            let dateFormatter:DateFormatter = DateFormatter.init()
            let calendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
            let enUSPOSIXLocale:Locale = Locale.init(identifier: "en_US_POSIX")
            //
            if let tZ = timeZone {
                dateFormatter.timeZone = tZ
            }else{
                dateFormatter.timeZone = TimeZone.current
            }
            //
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.calendar = calendar
            dateFormatter.dateFormat = stringFormat
            dateFormatter.locale = enUSPOSIXLocale
            //
            let strDate:String = dateFormatter.string(from: d)
            //
            return strDate
        }else{
            return ""
        }
    }
    
    
    /** Simplifica uma data, removendo hora, minuto e segundos (time resetado para zero).*/
    class func dateHelper_SimplifyDate(date:Date?) -> Date?{
        
        if let d:Date = date {
            
            let strDate:String = self.dateHelper_StringFromDate(date: d, stringFormat: self.DATE_BAR_ddMMyyyy)
            let newDate:Date! = self.dateHelper_DateFromString(dateString: strDate, stringFormat: self.DATE_BAR_ddMMyyyy)
            //
            return newDate
            
        }else{
            return nil
        }
    }
    
    
    /** Cria um novo objeto, cópia da data.*/
    class func dateHelper_CopyDate(date:Date?) -> Date?{
        
        if let d:Date = date{
            let copyDate:Date = Date.init(timeInterval: 0, since: d)
            //
            return copyDate
        }else{
            return nil
        }
    }
    
    
    /** Calcula a idade (texto localizado pt-BR), baseando-se nas datas parâmetro.*/
    class func dateHelper_CalculateAgeFromDate(initialDate:Date?, finalDate:Date?) -> String{
        
        
        if var iDate:Date = initialDate{
            
            if var fDate:Date = finalDate{
                
                iDate = self.dateHelper_DateFromString(dateString: (self.dateHelper_StringFromDate(date: iDate, stringFormat: self.DATE_BAR_ddMMyyyy)), stringFormat: self.DATE_BAR_ddMMyyyy)!
                fDate = self.dateHelper_DateFromString(dateString: (self.dateHelper_StringFromDate(date: fDate, stringFormat: self.DATE_BAR_ddMMyyyy)), stringFormat: self.DATE_BAR_ddMMyyyy)!
                
                let gregorianCalendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
                //
                var setComponents = Set<Calendar.Component>()
                setComponents.insert(Calendar.Component.year)
                setComponents.insert(Calendar.Component.month)
                setComponents.insert(Calendar.Component.day)
                //
                let dateComponents:DateComponents = gregorianCalendar.dateComponents(setComponents, from: fDate)
                //
                let years:Int = dateComponents.year!
                let months:Int = dateComponents.month!
                let days:Int = dateComponents.day!
                
                
                //---------------> Retornando a idade <---------------
                if(years == 0)
                {
                    if(months == 0)
                    {
                        if(days == 0)
                        {
                            //Mesma data
                            return "";
                        }
                        else
                        {
                            if(days == 1)
                            {
                                return String.init(format: "%d dia", [days])
                            }
                            else
                            {
                                return String.init(format: "%d dias", [days])
                            }
                        }
                    }
                    else
                    {
                        if(months == 1)
                        {
                            if(days == 0)
                            {
                                return String.init(format: "%d mês", [months])
                            }
                            else
                            {
                                if(days == 1)
                                {
                                    return String.init(format: "%d mês e %d dia", [months, days])
                                }
                                else
                                {
                                    return String.init(format: "%d mês e %d dias", [months, days])
                                }
                            }
                        }
                        else
                        {
                            if(days == 0)
                            {
                                return String.init(format: "%d meses", [months]);
                            }
                            else
                            {
                                if(days == 1)
                                {
                                    return String.init(format: "%d meses e %d dia", [months, days])
                                }
                                else
                                {
                                    return String.init(format: "%d meses e %d dias", [months, days])
                                }
                            }
                        }
                    }
                }
                else
                {
                    if(years == 1)
                    {
                        if(months == 0)
                        {
                            if(days == 0)
                            {
                                //Mesma data
                                return String.init(format: "%d ano", [years])
                            }
                            else
                            {
                                if(days == 1)
                                {
                                    return String.init(format: "%d ano e %d dia", [years, days])
                                }
                                else
                                {
                                    return String.init(format: "%d ano e %d dia", [years, days])
                                }
                            }
                        }
                        else
                        {
                            if(months == 1)
                            {
                                if(days == 0)
                                {
                                    return String.init(format: "%d ano e %d mês", [years, months])
                                }
                                else
                                {
                                    if(days == 1)
                                    {
                                        return String.init(format: "%d ano, %d mês e %d dia", [years, months, days])
                                    }
                                    else
                                    {
                                        return String.init(format: "%d ano, %d mês e %d dias", [years, months, days])
                                    }
                                }
                            }
                            else
                            {
                                if(days == 0)
                                {
                                    return String.init(format: "%d ano e %d meses", [years, months])
                                }
                                else
                                {
                                    if(days == 1)
                                    {
                                        return String.init(format: "%d ano, %d meses e %d dia", [years, months, days])
                                    }
                                    else
                                    {
                                        return String.init(format: "%d ano, %d meses e %d dias", [years, months, days])
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        if(months == 0)
                        {
                            if(days == 0)
                            {
                                //Mesma data
                                return String.init(format: "%d anos", [years])
                            }
                            else
                            {
                                if(days == 1)
                                {
                                    return String.init(format: "%d anos e %d dia", [years, days])
                                }
                                else
                                {
                                    return String.init(format: "%d anos e %d dias", [years, days])
                                }
                            }
                        }
                        else
                        {
                            if(months == 1)
                            {
                                if(days == 0)
                                {
                                    return String.init(format: "%d anos e %d mês", [years, months])
                                }
                                else
                                {
                                    if(days == 1)
                                    {
                                        return String.init(format: "%d anos, %d mês e %d dia", [years, months, days])
                                    }
                                    else
                                    {
                                        return String.init(format: "%d anos, %d mês e %d dias", [years, months, days])
                                    }
                                }
                            }
                            else
                            {
                                if(days == 0)
                                {
                                    return String.init(format: "%d anos e %d meses", [years, months])
                                }
                                else
                                {
                                    if(days == 1)
                                    {
                                        return String.init(format: "%d anos, %d meses e %d dia", [years, months, days])
                                    }
                                    else
                                    {
                                        return String.init(format: "%%d anos, %d meses e %d dias", [years, months, days])
                                    }
                                }
                            }
                        }
                    }
                }
                
            }else{
                return ""
            }
            
        }else{
            return ""
        }
    }
    
    
    /** Calcula o tempo transcorrido (texto localizado pt-BR), baseando-se nas datas parâmetro.*/
    class func dateHelper_CalculateTimeFromDate(initialDate:Date?, finalDate:Date?) -> String{
        
        if let iDate:Date = initialDate{
            
            if let fDate:Date = finalDate{
                
                var timeInterval:TimeInterval = iDate.timeIntervalSince(fDate)
                
                timeInterval = fabs(timeInterval)
                
                let hoursBetweenDates:Int = Int(timeInterval / Double(3600)) //60*60
                let minutesLeft:Int = Int(Double(Int(timeInterval) % 3600) / 60.0)
                
                if(hoursBetweenDates == 0)
                {
                    if(minutesLeft == 0)
                    {
                        return "menos de 1 minuto";
                    }
                    else if(minutesLeft == 1)
                    {
                        return "1 minuto";
                    }
                    else
                    {
                        return String.init(format: "%d minutos", [minutesLeft])
                    }
                }
                else if(hoursBetweenDates == 1)
                {
                    if(minutesLeft == 0)
                    {
                        return "1 hora";
                    }
                    else if(minutesLeft == 1)
                    {
                        return "1 hora e 1 minuto";
                    }
                    else
                    {
                        return String.init(format: "1 hora e %lu minutos", [minutesLeft])
                    }
                }
                else
                {
                    if(minutesLeft == 0)
                    {
                        return String.init(format: "%d horas", [hoursBetweenDates])
                    }
                    else if(minutesLeft == 1)
                    {
                        return String.init(format: "%d horas e 1 minuto", [hoursBetweenDates])
                    }
                    else
                    {
                        return String.init(format: "%d horas e %lu minutos", [hoursBetweenDates, minutesLeft])
                    }
                }                
            }else{
                return ""
            }
            
        }else{
            return ""
        }
    }
    
    
    /** Calcula a quantidade de dias baseando-se nas datas parâmetro.*/
    class func dateHelper_CalculateTotalDaysBetweenInitialDate(initialDate:Date?, finalDate:Date?) -> Int{
        
        if let iDate:Date = initialDate{
            
            if let fDate:Date = finalDate{
                
                let gregorianCalendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
                var setComponents = Set<Calendar.Component>()
                setComponents.insert(Calendar.Component.day)
                let components:DateComponents = gregorianCalendar.dateComponents(setComponents, from: iDate, to: fDate)
                //
                return components.day!
                
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    
    /** Calcula a quantidade de horas baseando-se nas datas parâmetro.*/
    class func dateHelper_CalculateTotalHoursBetweenInitialDate(initialDate:Date?, finalDate:Date?) -> Int{
        
        if let iDate:Date = initialDate{
            
            if let fDate:Date = finalDate{
                
                let gregorianCalendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
                var setComponents = Set<Calendar.Component>()
                setComponents.insert(Calendar.Component.hour)
                let components:DateComponents = gregorianCalendar.dateComponents(setComponents, from: iDate, to: fDate)
                //
                return components.hour!
                
            }else{
                return 0
            }
        }else{
            return 0
        }
    }

    
    /** Retorna uma nova data, utilizando uma data base deslocada de 'n' unidades de calendário (ex.: dias, horas, minutos).*/
    class func dateHelper_NewDateForReferenceDate(referenceDate:Date?, offSet:Int, unitCalendar:Calendar.Component) -> Date?{
        
        if let rDate:Date = referenceDate{
            
            let gregorianCalendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
            var calendarComponent:DateComponents = DateComponents.init()
            calendarComponent.setValue(offSet, for: unitCalendar)
            //
            let newDate:Date = gregorianCalendar.date(byAdding: calendarComponent, to: rDate)!
            //
            return newDate
            
        }else{
            return nil
        }
    }
    
    
    /** Retorna o primeiro dia do mês para uma determinada data referência.*/
    class func dateHelper_FirtsDayOfMonthForReferenceDate(referenceDate:Date?) -> Date?{
        
        if let rDate:Date = referenceDate{
            
            let gregorianCalendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
            //
            var setComponents = Set<Calendar.Component>()
            setComponents.insert(Calendar.Component.year)
            setComponents.insert(Calendar.Component.month)
            setComponents.insert(Calendar.Component.day)
            var dateComponents:DateComponents = gregorianCalendar.dateComponents(setComponents, from: rDate)
            //
            dateComponents.setValue(1, for: Calendar.Component.day)
            //
            return gregorianCalendar.date(from: dateComponents)
            
        }else{
            return nil
        }
    }
    
    
    /** Retorna o último dia do mês para uma determinada data referência.*/
    class func dateHelper_LastDayOfMonthForReferenceDate(referenceDate:Date?) -> Date?{
        
        if let rDate:Date = referenceDate{
            
            let gregorianCalendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
            //
            let dayRange:Range = gregorianCalendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: rDate)!
            let dayCount:Int = dayRange.count
            //
            var setComponents = Set<Calendar.Component>()
            setComponents.insert(Calendar.Component.year)
            setComponents.insert(Calendar.Component.month)
            setComponents.insert(Calendar.Component.day)
            var dateComponents:DateComponents = gregorianCalendar.dateComponents(setComponents, from: rDate)
            //
            dateComponents.setValue(dayCount, for: Calendar.Component.day)
            //
            return gregorianCalendar.date(from: dateComponents)
            
        }else{
            return nil
        }
    }
    
    
    /** Retorna o ano vigente .*/
    class func dateHelper_ActualYear() -> Int{
        
        let actualDate:Date = Date.init()
        let calendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let year:Int = calendar.component(Calendar.Component.year, from:actualDate)
        //
        return year
    }
    
    
    /** Encontra o valor absoluto de uma unidade de calendário (ano, mês, dia, etc) numa determinada data referência.*/
    class func dateHelper_ValueForUnit(calendarUnit:Calendar.Component, referenceDate:Date?) -> Int{
        
        if let rDate = referenceDate{
            
            let calendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
            let value:Int = calendar.component(calendarUnit, from: rDate)
            //
            return value
        }else{
            return -1
        }
    }
    
    
    /** Retorna o timeStamp da data referência em segundos (apenas a parte inteira no número).*/
    class func dateHelper_TimeStampInSecondsFromDate(date:Date?) -> Int{
        
        if let d:Date = date{
            
            let totalSeconds:TimeInterval = d.timeIntervalSince1970
            //
            return Int(totalSeconds)
            
        }else{
            return 0
        }
    }
    
    
    /** Retorna o timeInterval da data referência completa.*/
    class func dateHelper_TimeStampFromDate(date:Date?) -> TimeInterval{
        
        if let d:Date = date{
            
            let timeInterval:TimeInterval = d.timeIntervalSince1970
            //
            return timeInterval
            
        }else{
            return 0
        }
    }
    
    
    /** Retorna o timeStamp textual completo do sistema iOS, sem pontuação.*/
    class func dateHelper_TimeStampCompleteIOSfromDate(date:Date?) -> String{
        
        if let d:Date = date{
            
            let timeInterval:TimeInterval = d.timeIntervalSince1970
            var strTimeInterval:String = "\(timeInterval)"
            strTimeInterval = strTimeInterval.replacingOccurrences(of: ".", with: "")
            strTimeInterval = strTimeInterval.replacingOccurrences(of: ",", with: "")
            //
            return strTimeInterval
            
        }else{
            return ""
        }
    }
    
    
    /** Compara duas datas. Utiliza o typedef enum 'ToolBoxComparationRules' da classe 'ToolBox'. */
    class func dateHelper_CompareDates(date1:Date?, date2:Date?, rule:ToolBoxComparationRule) -> Bool{
        
        if let d1:Date = date1{
            if let d2:Date = date2{
                
                let calendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
                //
                var setComponents = Set<Calendar.Component>()
                setComponents.insert(Calendar.Component.year)
                setComponents.insert(Calendar.Component.month)
                setComponents.insert(Calendar.Component.day)
                //
                let dateComponents1:DateComponents = calendar.dateComponents(setComponents, from: d1)
                let dateComponents2:DateComponents = calendar.dateComponents(setComponents, from: d2)
                
                for i in 1...7 {
                
                    switch (i)
                    {
                        case 1: //Ano Maior
                            
                            if (dateComponents1.year! > dateComponents2.year!){
                                
                                if(rule == ToolBoxComparationRule.Greater || rule == ToolBoxComparationRule.GreaterOrEqual){
                                    return true;
                                }else{
                                    return false;
                                }
                            }
                            
                        case 2: //Ano Menor
                            
                            if (dateComponents1.year! < dateComponents2.year!){
                            
                                if(rule == ToolBoxComparationRule.Less || rule == ToolBoxComparationRule.LessOrEqual){
                                    return true;
                                }else{
                                    return false;
                                }
                            }
                           
                            
                        case 3: //Ano Igual / Mês Menor
                            
                            if (dateComponents1.month! > dateComponents2.month!){
                                
                                if(rule == ToolBoxComparationRule.Greater || rule == ToolBoxComparationRule.GreaterOrEqual){
                                    return true;
                                }else{
                                    return false;
                                }
                            }
                            
                        case 4: //Ano Igual / Mês Maior
                            
                            if (dateComponents1.month! < dateComponents2.month!){
                                
                                if(rule == ToolBoxComparationRule.Less || rule == ToolBoxComparationRule.LessOrEqual){
                                    return true;
                                }else{
                                    return false;
                                }
                            }
                            
                        case 5: //Ano Igual / Mês Igual / Dia Menor
                            
                            if (dateComponents1.day! > dateComponents2.day!){
                                
                                if(rule == ToolBoxComparationRule.Greater || rule == ToolBoxComparationRule.GreaterOrEqual){
                                    return true;
                                }else{
                                    return false;
                                }
                            }
                            
                        case 6: //Ano Igual / Mês Igual / Dia Meior
                            
                            if (dateComponents1.day! < dateComponents2.day!){
                                
                                if(rule == ToolBoxComparationRule.Less || rule == ToolBoxComparationRule.LessOrEqual){
                                    return true;
                                }else{
                                    return false;
                                }
                            }
                            
                        case 7: //Ano Igual / Mês Igual / Dia Igual
                            
                            if (dateComponents1.day! == dateComponents2.day!){
                                
                                if(rule == ToolBoxComparationRule.Equal || rule == ToolBoxComparationRule.GreaterOrEqual || rule == ToolBoxComparationRule.LessOrEqual){
                                    return true;
                                }else{
                                    return false;
                                }
                            }
                           
                        default:
                            
                            return false
                    }
                }
                return false
                
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    
    /** Retorna um texto no formato Mês/Ano (localizado pt-BR) para uma data referência. Ex.: JAN/2016. */
    class func dateHelper_MonthAndYearForReferenceDate(referenceDate:Date?, abbreviation:Bool) -> String{
    
        if let date:Date = referenceDate{
            
            let calendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
            //
            var setComponents = Set<Calendar.Component>()
            setComponents.insert(Calendar.Component.year)
            setComponents.insert(Calendar.Component.month)
            let dateComponents:DateComponents = calendar.dateComponents(setComponents, from: date)
            //
            let strResult:String =   String.init(format: "%@/%d", [(self.dateHelper_MonthNameForIndex(index:dateComponents.month!, abbreviation:true)), dateComponents.year!])
            //
            return strResult
            
        }else{
            return ""
        }
        
    }
    
    
    /** Retorna o texto correspondente (localizado pt-BR) ao referido mês (com opção de abreviação). */
    class func dateHelper_MonthNameForIndex(index:Int, abbreviation:Bool) -> String{
        
        switch index {
            case 1:
                return (abbreviation ? "JAN" : "Janeiro")
            case 2:
                return (abbreviation ? "FEV" : "Fevereiro")
            case 3:
                return (abbreviation ? "MAR" : "Março")
            case 4:
                return (abbreviation ? "ABR" : "Abril")
            case 5:
                return (abbreviation ? "MAI" : "Maio")
            case 6:
                return (abbreviation ? "JUN" : "Junho")
            case 7:
                return (abbreviation ? "JUL" : "Julho")
            case 8:
                return (abbreviation ? "AGO" : "Agosto")
            case 9:
                return (abbreviation ? "SET" : "Setembro")
            case 10:
                return (abbreviation ? "OUT" : "Outubro")
            case 11:
                return (abbreviation ? "NOV" : "Novembro")
            case 12:
                return (abbreviation ? "DEZ" : "Dezembro")
            default:
                return (abbreviation ? "-" : "-")
        }
    }
    
    /** Encontra o nome do dia da semana para determinado indice (localizado pt-BR). */
    class func dateHelper_DayOfTheWeekNameForIndex(indexDay:Int, abbreviation:Bool) -> String{
    
        switch indexDay {
        case 1:
            return (abbreviation ? "DOM" : "Domingo")
        case 2:
            return (abbreviation ? "SEG" : "Segunda-Feira")
        case 3:
            return (abbreviation ? "TER" : "Terça-Feira")
        case 4:
            return (abbreviation ? "QUA" : "Quarta-Feira")
        case 5:
            return (abbreviation ? "QUI" : "Quinta-Feira")
        case 6:
            return (abbreviation ? "SEX" : "Sexta-Feira")
        case 7:
            return (abbreviation ? "SAB" : "Sábado")
        default:
            return (abbreviation ? "-" : "-")
        }
    }
    

    /** Formata uma dada data para texto com máscara 'EEEE, dd 'de' MMMM 'de' yyyy, HH:mm:ss. */
    class func dateHelper_CompleteStringFromDate(referenceDay:Date?) -> String{
        
        if let rDate:Date = referenceDay{
         
            let dateFormatter:DateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "EEEE, dd 'de' MMMM 'de' yyyy, kk:mm:ss."
            //
            let strDate:String = dateFormatter.string(from: rDate)
            //
            return strDate
            
        }else{
            return ""
        }
    }
    
    
    /** Este método retorna 'Ontem', 'Hoje', 'Amanhã' para uma data referência no intervalo, vazio ("") para datas inválidas e o texto conforme 'stringFormat' para demais datas.*/
    class func dateHelper_IdentifiesYesterdayTodayTomorrowFromDate(referenceDate:Date?, stringFormat:String!) -> String{
        
        if let rDate:Date = referenceDate{
            
            let today:Date = Date.init()
            let tomorrow:Date = today.addingTimeInterval((60 * 60 * 24 * 1) * (+1))
            let yesterday:Date = today.addingTimeInterval((60 * 60 * 24 * 1) * (-1))
            
            let dateFormatter:DateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = stringFormat
            //
            let calendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
            dateFormatter.calendar = calendar
            
            let strToday:String = dateFormatter.string(from: today)
            let strTomorrow:String = dateFormatter.string(from: tomorrow)
            let strYesterday:String = dateFormatter.string(from: yesterday)
            //
            let strDateToCompare:String = dateFormatter.string(from: rDate)
            
            if (strToday == strDateToCompare){
                return "Hoje"
            }
            //
            if (strTomorrow == strDateToCompare){
                return "Amanhã"
            }
            //
            if (strYesterday == strDateToCompare){
                return "Ontem"
            }
            //
            return strDateToCompare
            
        }else{
            return ""
        }
    }
    
    
    /** Este método retorna 'Madrugada', 'Manhã', 'Tarde' ou 'Noite' para um horário referência. */
    class func dateHelper_IdentifiesDayPeriodFromDate(referenceDate:Date?) -> String{
        
        if let rDate:Date = referenceDate{
            
            let locale:Locale = Locale.current
            var calendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
            calendar.locale = locale
            //
            var setComponents = Set<Calendar.Component>()
            setComponents.insert(Calendar.Component.year)
            setComponents.insert(Calendar.Component.month)
            setComponents.insert(Calendar.Component.day)
            setComponents.insert(Calendar.Component.hour)
            setComponents.insert(Calendar.Component.minute)
            setComponents.insert(Calendar.Component.second)
            let dateComponents:DateComponents = calendar.dateComponents(setComponents, from: rDate)
            
            //As subdiviões podem ser alteradas para considerar mais opções ou horários personalizados
            
            if (dateComponents.hour! >= 18){
                
                return "Noite"
                
            }else if (dateComponents.hour! >= 12){
                
                return "Tarde"
            
            }else if (dateComponents.hour! >= 6){
                
                return "Dia"
            }else{
                
                return "Madrugada"
            }
            
        }else{
            return ""
        }
    }
    
    
    /** Este método retorna o formato de horário de acordo com o utilizado pelo sistema no momento ('HH:mm:ss' para 24 horas ou 'h:mm:ss a' para 12 horas). */
    class func dateHelper_SystemTimeUsingMask() -> String{
        
        let dateFormatter:DateFormatter = DateFormatter.init()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.long
        //
        let strFormat:String = dateFormatter.dateFormat
        
        if strFormat.range(of: "a") != nil{
            
            // user prefers 12 hour clock
            return "h:mm:ss a"
        }else{
            
            // user prefers 24 hour clock
            return "HH:mm:ss"
        }
        
    }
    
    
    /** Este método retorna uma data que é composta por outras duas datas. A primeira para 'dd/MM/yyyy' e a segunda para 'HH:mm:ss'.*/
    class func dateHelper_CombinedDateFromDates(dateReference:Date?, timeReference:Date?) -> Date?{
        
        if let dRef:Date = dateReference{
            
            if let tRef:Date = timeReference{
                
                var calendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
                calendar.locale = Locale.current
                //
                var setComponents1 = Set<Calendar.Component>()
                setComponents1.insert(Calendar.Component.year)
                setComponents1.insert(Calendar.Component.month)
                setComponents1.insert(Calendar.Component.day)
                let dateComponents:DateComponents = calendar.dateComponents(setComponents1, from: dRef)
                //
                var setComponents2 = Set<Calendar.Component>()
                setComponents2.insert(Calendar.Component.hour)
                setComponents2.insert(Calendar.Component.minute)
                setComponents2.insert(Calendar.Component.second)
                let timeComponents:DateComponents = calendar.dateComponents(setComponents2, from: tRef)
                //
                var finalComponents:DateComponents = DateComponents.init()
                finalComponents.setValue(dateComponents.year, for: Calendar.Component.year)
                finalComponents.setValue(dateComponents.month, for: Calendar.Component.month)
                finalComponents.setValue(dateComponents.day, for: Calendar.Component.day)
                finalComponents.setValue(timeComponents.hour, for: Calendar.Component.hour)
                finalComponents.setValue(timeComponents.minute, for: Calendar.Component.minute)
                finalComponents.setValue(timeComponents.second, for: Calendar.Component.second)
                //
                let fDate:Date = calendar.date(from: finalComponents)!
                //
                return fDate
                
            }else{
                return nil
            }
            
        }else{
            return nil
        }
    }
    
    
    /** Retorna um texto amigável para a data referência. Ex.: 'hoje, 08:15', 'ontem, 11:30', '12/09/2016, 17:11'.*/
    class func dateHelper_FriendlyStringFromDate(referenceDate:Date?, stringFormatForDate:String!) -> String{
        
        if let rDate = referenceDate{
            
            var strFriendly:String = self.dateHelper_IdentifiesYesterdayTodayTomorrowFromDate(referenceDate: rDate, stringFormat:stringFormatForDate)
            strFriendly = strFriendly.appending(", ")
            strFriendly = strFriendly.appending(self.dateHelper_StringFromDate(date: rDate, stringFormat: self.DATE_TIME_HHmm))
            //
            return strFriendly
            
        }else{
            return ""
        }
    }
    
    
    /** Converte o formato de uma data textual para outro formato.*/
    class func dateHelper_NewStringDateForText(originalDateText:String!, oldStringFormat:String!, newStringFormat:String!) -> String{
        
        let date:Date = self.dateHelper_DateFromString(dateString: originalDateText, stringFormat: oldStringFormat)!
        let strDate:String = self.dateHelper_StringFromDate(date: date, stringFormat: newStringFormat)
        //
        return strDate
        
    }
    
    //MARK: - • CONVERTER HELPER =======================================================================
    
    /** Converte um dicionário JSON em texto.*/
    class func converterHelper_StringJsonFromDictionary(dictionary:NSDictionary) -> String
    {
        if let dic:NSDictionary = dictionary
        {
            var jsonData:Data? = Data()
            do
            {
                jsonData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            }catch{
                print(error)
            }
            
            if(jsonData == nil)
            {
                return "{}"
            }
            else
            {
                return String.init(data: jsonData!, encoding: String.Encoding.utf8)!
            }
        }
        else
        {
            return ""
        }
        
    }
    
    /** Converte um texto em dicionário JSON.*/
    class func converterHelper_DictionaryFromStringJson(string:String) -> NSDictionary?
    {
        if(string.isEmpty)
        {
            return nil
        }
        
        let objectData:Data? = (string.data(using: String.Encoding.utf8))
        var json:NSDictionary?
        do
        {
            json = try (JSONSerialization.jsonObject(with: objectData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary)
        }catch{
            print(error)
        }
        
        if(json != nil)
        {
            return json!
        }
        
        return nil
        
    }
    
    /** Remove valores textuais '<null>', '(null)', 'null' do dicionário parâmetro, substituindo pela por um termo escolhido.*/
    class func converterHelper_NewDictionaryRemovingNullValuesFromDictionary(oldDictionary:NSDictionary, withString newString:String) -> NSDictionary?
    {
        if let dic:NSDictionary = oldDictionary
        {
            var replaced:NSMutableDictionary = NSMutableDictionary(dictionary: dic)
            
            for key in replaced.allKeys {
                
                var object:AnyObject = replaced.object(forKey: key) as AnyObject
                if(object is String)
                {
                    if(isNullString(valueString: (object as! String)))
                    {
                        replaced.setObject(newString, forKey: key as! NSCopying)
                    }
                }
                else if(object is NSNull)
                {
                    replaced.setObject(newString, forKey: key as! NSCopying)
                }
            }
            return NSDictionary.init(dictionary: replaced)
        }
        else
        {
            return nil
        }
    }
    
    /** Substitui o símbolo '+' do texto de um dicionário referência.*/
    class func converterHelper_NewDictionaryReplacingPlusSymbolFromDictionary(refDictionary:NSDictionary) -> NSDictionary?
    {
        if let dic:NSDictionary = refDictionary
        {
            let replaced:NSMutableDictionary = NSMutableDictionary.init(dictionary: dic)
            var dicString = converterHelper_StringJsonFromDictionary(dictionary: replaced)
            
            dicString = dicString.removingPercentEncoding!
            
            let resultDic = converterHelper_DictionaryFromStringJson(string: dicString)
            return resultDic
        }
        else
        {
            return nil
        }
    }
    
    /** Retorna uma url normalizada baseada em uma string.*/
    class func converterHelper_NormalizedURLString(string:String) -> NSURL?
    {
        if let paramString:String = string
        {
            let urlString = paramString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            return NSURL.init(string: urlString!)!
        }
        else
        {
            return nil
        }
        
    }
    
    /** Retorna o texto 'limpo' de uma html.*/
    class func converterHelper_PlainStringFromHTMLString(htmlString:String) -> String?
    {
        if let paramString:String = htmlString
        {
            var aString:NSAttributedString = NSAttributedString()
            
            do{
                aString = try NSAttributedString.init(data: paramString.data(using: String.Encoding.utf8)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute : NSNumber.init(value: String.Encoding.utf8.rawValue)], documentAttributes: nil)
            }
            catch
            {
                print(error)
            }
            
            return aString.string
        }
        else
        {
            return nil
        }
    }
    
    /** Formata um valor numérico para seu equivalente monetário. Utiliza a localidade padrão do sistema.*/
    class func converterHelper_MonetaryStringForValue(value:Double) -> String?
    {
        if let paramValue:Double = value
        {
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.currency
            return formatter.string(from: NSNumber.init(value: paramValue))
        }
        else
        {
            return nil
        }
    }
    
    /** Converte graus em radianos.*/
    class func converterHelper_DegreeToRadian(degree:CGFloat) -> CGFloat
    {
        return degree * CGFloat(M_PI) / 180.0
    }
    
    /** Converte radianos em graus.*/
    class func converterHelper_RadianToDegree(radius:CGFloat) -> CGFloat
    {
        return radius * 180.0 / CGFloat(M_PI)
    }
    
    /** Converte grau celsius para fahenheit.*/
    class func converterHelper_CelsiusToFahenheit(celcius:CGFloat) -> CGFloat
    {
        return (celcius-32.0) / 1.8
    }
    
    /** Converte fahenheit para grau celsius.*/
    class func converterHelper_FahenheitToCelsius(fahenheit:CGFloat) -> CGFloat
    {
        return (fahenheit*1.8)+32.0
    }
    
    /** Retorna o equivalente numérico para um dado texto (localizado pt-BR). Ex: "R$ 50,00", "2,3 L", "5 m³" etc.*/
    class func converterHelper_DecimalValueFromText(text:String) -> Double
    {
        var tempVE = text
        tempVE = tempVE.replacingOccurrences(of: ".", with: "")
        tempVE = tempVE.replacingOccurrences(of: " ", with: "")
        tempVE = tempVE.replacingOccurrences(of: ",", with: ".")
        tempVE = tempVE.replacingOccurrences(of: TOOLBOX_SYMBOL_DEFAULT_MONETARY, with: "")
        tempVE = tempVE.replacingOccurrences(of: TOOLBOX_SYMBOL_DEFAULT_VOLUME_LIQUID, with: "")
        tempVE = tempVE.replacingOccurrences(of: TOOLBOX_SYMBOL_DEFAULT_VOLUME_SOLID, with: "")
        tempVE = tempVE.replacingOccurrences(of: TOOLBOX_SYMBOL_DEFAULT_DISTANCE, with: "")
        
        let value:NSDecimalNumber = NSDecimalNumber(string: tempVE)
        
        return Double(value)
    }
    
    /** Formata um valor para texto, aplicando opcionalmente o símbolo monetário (localizado pt-BR).*/
    class func converterHelper_StringFromValue(value:Double, monetaryFormat monetary:Bool, decimalPrecision precision:Int) -> String
    {
        var texto:String
        
        let v = NSNumber.init(value: value)
        let formatter = NumberFormatter()
        let locale = Locale(identifier: "pt-BR")
        
        formatter.locale = locale
        formatter.numberStyle = .decimal
        formatter.roundingMode = .halfDown
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = precision
        formatter.minimumFractionDigits = precision
        formatter.minimumIntegerDigits = 1
        texto = formatter.string(from: v)!
        //
        if(monetary)
        {
            return String("\(TOOLBOX_SYMBOL_DEFAULT_MONETARY) \(texto)")
        }
        else
        {
            return texto
        }
        
    }
    
    
    //MARK: - • PRIVATE FUNCTIONS =======================================================================
    
    private class func toolBoxPrivate_TransformedValue(size: UInt64) -> String{
        
        var convertedValue:Double  = Double(size)
        var multiplyFactor:Int = 0;
        let tokens:Array = ["bytes", "KB", "MB", "GB", "TB"]
        
        while (convertedValue > 1024.0) {
            convertedValue /= 1024.0
            multiplyFactor += 1
        }
        
        return String(format: "%.2f %@", convertedValue, tokens[multiplyFactor])
    }
    
}
