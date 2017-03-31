//
//  ToolBox.swift
//  Project-Swift
//
//  Created by Erico GT on 3/21/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import UIKit
import Accelerate

//MARK: - • EXTENSIONS

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
    //
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
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
                
            //default:                                return ""
        }
    }
}

//MARK: - • ENUMS

enum ToolBoxComparationRule:Int {
    case Less = 1
    case Equal = 2
    case Greater = 3
    case LessOrEqual = 4
    case GreaterOrEqual = 5
}


enum ToolBoxValidationResult:Int {
    case Undefined = 0
    case Approved = 1
    case Disapproved = 2
}

enum ToolBoxGrayScaleEffect:Int {
    case Noir = 0
    case Mono = 1
    case Tonal = 2
}

class ToolBox: NSObject{
    
    //MARK: - • DEFINES (STATIC PROPERTIES)
    
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
    public static let CDATA_START:String = "<![CDATA["
    public static let CDATA_END:String = "]]>"
    //
    public static let SYMBOL_MONETARY:String = "R$"
    public static let SYMBOL_VOLUME_LIQUID:String = "L"
    public static let SYMBOL_VOLUME_SOLID:String = "m³"
    public static let SYMBOL_DISTANCE:String = "KM"
    
    //MARK: - • TOOL BOX =======================================================================
    
    /** Retorna dados informativos sobre a versão corrente do utilitário 'ToolBox'.*/
    class func toolBoxHelper_classVersionInfo() -> String!{
        
        //OBS: Favor não apagar as linhas anteriores. Apenas comente para referência futura.
        //return "Version: 1.0  |  Date: 21/03/2017  |  Autor: EricoGT  |  Note: Primeira versão em Swift.";
        //return "Version: 1.1  |  Date: 23/03/2017  |  Autor: EricoGT  |  Note: Acrescentados métodos até o grupo 'ValidationHelper'.";
        //
        return "Version: 2.0  |  Date: 30/03/2017  |  Autor: EricoGT  |  Note: Inclusão do grupo 'GRAPHIC'. Mescla do grupo 'CONVERTER', feito pelo Lucas.";
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
            return self.messureHelper_FormatedStringToDataSize(dataSize: fileSize)
            
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
            return self.messureHelper_FormatedStringToDataSize(dataSize: fileSize)
        }catch{
            return self.messureHelper_FormatedStringToDataSize(dataSize: 0)
        }
    }
    

    /** Busca o tamanho da memória livre disponível no dispositivo.*/
    class func deviceHelper_FreeMemorySpace() -> String{
        
        do{
            let attr = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            let fileSize:UInt64 = attr[FileAttributeKey.systemFreeSize] as! UInt64
            //
            return self.messureHelper_FormatedStringToDataSize(dataSize: fileSize)
        }catch{
            return self.messureHelper_FormatedStringToDataSize(dataSize: 0)
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
    
    
    //MARK: - • MESSURE HELPER =======================================================================
    
    
    /** Normaliza um valor para uma determinada precisão.*/
    class func messureHelper_NormalizeValue(value:Double, decimalPrecision:Int) -> Double{
        
        let normalizador:Double = Double(powf(10, Float(decimalPrecision)));
        let result:Double = (ceil(value * normalizador))/normalizador;
        //
        return result;
    }
    
    
    /** Verifica se dois números são iguais, utilizando uma precisão parâmetro como limitador.*/
    class func messureHelper_CheckEqualityFromValues(value1:Double, value2:Double, decimalPrecision:Int) -> Bool{
        
        //TODO:
//        NSString *vString1 = [self converterHelper_StringFromValue:value1 monetaryFormat:true decimalPrecision:precision];
//        NSString *vString2 = [self converterHelper_StringFromValue:value2 monetaryFormat:true decimalPrecision:precision];
//        //
//        double vDouble1 = [self converterHelper_DecimalValueFromText:vString1];
//        double vDouble2 = [self converterHelper_DecimalValueFromText:vString2];
//        //
//        return (vDouble1 == vDouble2);
        
        return false
    }
    
    
    /** Formata um tamanho para a unidade mais apropriada, relacionada ao tamanho em 'bytes'.*/
    class func messureHelper_FormatedStringToDataSize(dataSize:UInt64) -> String{
        
        var convertedValue:Double  = Double(dataSize)
        var multiplyFactor:Int = 0;
        let tokens:Array = ["bytes", "KB", "MB", "GB", "TB"]
        
        while (convertedValue > 1024.0) {
            convertedValue /= 1024.0
            multiplyFactor += 1
        }
        
        return String(format: "%.2f %@", convertedValue, tokens[multiplyFactor])
    }
    

    //MARK: - • VALIDATION HELPER =======================================================================
    
    
    /** Verifica se um email é compatível segundo o regex utilizado por padrão. Para saber mais: 'http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/'.*/
    class func validationHelper_EmailChecker(email:String!) -> ToolBoxValidationResult{
        
        // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
        //let stricterFilter:Bool = true
        
        let stricterFilterString:String = "^[_a-zA-Z0-9-]+([.]{1}[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+([.]{1}[a-zA-Z0-9-]+)*([.]{1}[a-zA-Z]{2,6})"
        //let laxString:String = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        let emailRegex:String = stricterFilterString //stricterFilter ? stricterFilterString : laxString
        //
        let emailTest:NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", emailRegex)
        //
        if (emailTest.evaluate(with: email) == false){
            return ToolBoxValidationResult.Disapproved
        }else{
            return ToolBoxValidationResult.Approved
        }        
    }
    
    
    /** Verifica se todos os caracteres de um texto pertencem ou não a uma dada lista de caracteres.*/
    class func validationHelper_TextCheck(text:String, validationList:Array<Character>, restrictForList:Bool) -> ToolBoxValidationResult{
        
        if(restrictForList) //somente aceita caracteres da lista
        {
            
            for char in text.characters {
                
                var ok:Bool = false
                
                for vChar in validationList {
                    
                    if (char == vChar){
                        
                        ok = true
                        break
                    }
                }
                
                if (!ok) {
                    return ToolBoxValidationResult.Disapproved
                }
            }
            
            return ToolBoxValidationResult.Approved
            
        }
        else //rejeita todos caracteres da lista
        {
            
            for char in text.characters {
                
                var ok:Bool = true
                
                for vChar in validationList {
                    
                    if (char == vChar){
                        
                        ok = false
                        break
                    }
                }
                
                if (!ok) {
                    return ToolBoxValidationResult.Disapproved
                }
            }
            
            return ToolBoxValidationResult.Approved
        }
    }
   
    
    
    /**
     * Cria uma lista de caracteres, contendo os elementos selecionados.
     * @param numbers     Acrescenta os numerais a lista [0-9].
     * @param capsLetters     Acrescenta letras maiúsculas a lista [A-Z].
     * @param minusLetters     Acrescenta letras maiúsculas a lista [a-z].
     * @param symbols     Acrescenta símbolos a lista [vários].
     * @param control     Acrescenta caracteres de controle a lista [\a, \b, \t, \n, \v, \f, \r, \e].
     * @return     Retorna uma lista vazia caso todos os paramêtros estejam negados.
     */
    class func validationHelper_NewListOfCharactersWith(numbers:Bool, capsLetters:Bool, minusLetters:Bool, symbols:Bool, controlCharacters:Bool) -> Array<Character>{
        
        var finalList:Array<Character> = Array()
        
        if (numbers){
            
            finalList.append(contentsOf: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
        }
        
        if (capsLetters){
            
            finalList.append(contentsOf: ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"])
        }
        
        if (minusLetters){
            
            finalList.append(contentsOf: ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"])
        }
        
        if (symbols){
            
            finalList.append(contentsOf: [" ", "!", "?", ".", ",", ";", ":", "\"", "\'", "<", ">", "[", "]", "(", ")", "{", "}", "#", "$", "%", "&", "*", "/", "\\","|", "-", "_", "+", "=", "^", "ª", "º"])
        }
        
        if (controlCharacters){
            
            finalList.append(contentsOf: ["\n", "\r", "\t"])
        }
        
        return finalList
    }
  
    /** Verifica o MIMEType para um determinado arquivo com extensão conhecida.*/
    class func validationHelper_MIMETypeForWebContent(url:String) -> String{
    
        let strArray:Array = url.components(separatedBy: ".")
        
        if (strArray.count > 0){
            
            let strMIME:String = strArray.last!
                
            if strMIME.uppercased() == "JPE" {return "image/jpeg"}
            if strMIME.uppercased() == "JPEG" {return "image/jpeg"}
            if strMIME.uppercased() == "JPG" {return "image/jpeg"}
            if strMIME.uppercased() == "BM" {return "image/bmp"}
            if strMIME.uppercased() == "BMP" {return "image/bmp"}
            if strMIME.uppercased() == "PNG" {return "image/png"}
            if strMIME.uppercased() == "GIF" {return "image/gif"}
            if strMIME.uppercased() == "TIFF" {return "image/tiff"}
        }
        
        return ""
    }
    
    
    /** Verifica se o texto equivale a verdadeiro ou falso.*/
    class func validationHelper_ValidateBolean(text:String?, comparingBoolean:Bool) ->Bool{
    
        guard text != nil else {
            return false
        }
        
        if(comparingBoolean)
        {
            if (text!.uppercased() == "TRUE") {return true}
            if (text!.uppercased() == "YES") {return true}
            if (text!.uppercased() == "ON") {return true}
            if (text!.uppercased() == "ONLINE") {return true}
            if (text!.uppercased() == "ENABLE") {return true}
            if (text!.uppercased() == "ACTIVATED") {return true}
            if (text!.uppercased() == "ONE") {return true}
            //
            if (text!.uppercased() == "VERDADEIRO") {return true}
            if (text!.uppercased() == "SIM") {return true}
            if (text!.uppercased() == "LIGADO") {return true}
            if (text!.uppercased() == "ATIVO") {return true}
            if (text!.uppercased() == "ATIVADO") {return true}
            if (text!.uppercased() == "HABILITADO") {return true}
            if (text!.uppercased() == "UM") {return true}
            //
            if (text!.uppercased() == "1") {return true}
            if (text!.uppercased() == "T") {return true}
            if (text!.uppercased() == "Y") {return true}
            if (text!.uppercased() == "S") {return true}
        }
        else
        {
            if (text!.uppercased() == "FALSE") {return true}
            if (text!.uppercased() == "NO") {return true}
            if (text!.uppercased() == "OFF") {return true}
            if (text!.uppercased() == "OFFLINE") {return true}
            if (text!.uppercased() == "DISABLED") {return true}
            if (text!.uppercased() == "DEACTIVATED") {return true}
            if (text!.uppercased() == "ZERO") {return true}
            //
            if (text!.uppercased() == "FALSO") {return true}
            if (text!.uppercased() == "NÃO") {return true}
            if (text!.uppercased() == "NAO") {return true}
            if (text!.uppercased() == "DESLIGADO") {return true}
            if (text!.uppercased() == "DESATIVADO") {return true}
            if (text!.uppercased() == "DESABILITADO") {return true}
            //
            if (text!.uppercased() == "0") {return true}
            if (text!.uppercased() == "F") {return true}
            if (text!.uppercased() == "N") {return true}
        }
        
        return false;
    }
    
    
    /** Verifica se um CPF é válido.*/
    class func validationHelper_Validate(CPF:String?) -> ToolBoxValidationResult{
    
        guard CPF != nil else {
            return ToolBoxValidationResult.Undefined
        }
        
        
        //VERIFICA SE CPF TEM 11 DIGITOS
        if (CPF!.characters.count != 11 || CPF! == ""){
            
            return ToolBoxValidationResult.Disapproved
        }
        
        
        //VERIFICA SEQUENCIA DE CARACTERES INVÁLIDAS
        if (CPF! == "00000000000") { return ToolBoxValidationResult.Disapproved }
        if (CPF! == "11111111111") { return ToolBoxValidationResult.Disapproved }
        if (CPF! == "22222222222") { return ToolBoxValidationResult.Disapproved }
        if (CPF! == "33333333333") { return ToolBoxValidationResult.Disapproved }
        if (CPF! == "44444444444") { return ToolBoxValidationResult.Disapproved }
        if (CPF! == "55555555555") { return ToolBoxValidationResult.Disapproved }
        if (CPF! == "66666666666") { return ToolBoxValidationResult.Disapproved }
        if (CPF! == "77777777777") { return ToolBoxValidationResult.Disapproved }
        if (CPF! == "88888888888") { return ToolBoxValidationResult.Disapproved }
        if (CPF! == "99999999999") { return ToolBoxValidationResult.Disapproved }
        
        
        //VALIDA CPF PELO DIGITO VERIFICADOR
        
        let nsCPF:NSString = CPF! as NSString
        
        var soma:Int = 0
        var peso:Int = 0
        //
        let digit_10:Int = Int(nsCPF.substring(with: NSRange(location: 9, length: 1)))!
        let digit_11:Int = Int(nsCPF.substring(with: NSRange(location: 10, length: 1)))!
        //
        var digit_10_correct:Int = 0;
        var digit_11_correct:Int = 0;
        
        //Verificação 10 Digito
        peso = 10
        
        for i in 0...8 {
            
            let x:Int = Int(nsCPF.substring(with: NSRange(location: i, length: 1)))!
            soma = soma + ( x * peso );
            peso = peso - 1;
        }
        
        if (soma % 11 < 2){
            digit_10_correct = 0;
        }else{
            digit_10_correct = 11 - (soma % 11);
        }
        
        
        //Verifição 11 Digito
        soma = 0
        peso = 11
        
        for i in 0...9 {
            
            let y:Int = Int(nsCPF.substring(with: NSRange(location: i, length: 1)))!
            soma = soma + ( y * peso );
            peso = peso - 1;
        }
        
        if (soma % 11 < 2){
            digit_11_correct = 0;
        }else{
            digit_11_correct = 11 - (soma % 11);
        }
        
                
        //Retorno
        if (digit_10_correct == digit_10 && digit_11_correct == digit_11){
            return ToolBoxValidationResult.Approved;
        }else{
            return ToolBoxValidationResult.Disapproved;
        }
    }
    
    
    
    /** Encapsula campos de um dicionário com '<![CDATA[]]>'.*/
    class func validationHelper_NormalizeDictionaryForCDATA(originalDictionary:Dictionary<String, Any>?, encapsulating:Bool) -> Dictionary<String, Any>?{
        
        if var oDic:Dictionary<String, Any> = originalDictionary{
            
            let keysList:Array = Array(oDic.keys)
            
            for key:String in keysList{
                
                if (encapsulating){
                    
                    if (oDic[key] is String){
                        
                        let str:String = oDic[key] as! String
                        oDic[key] = validationHelper_AddCDATA(string: str) //addCDATA
                    }
                    
                }else{
                    
                    if (oDic[key] is String){
                        
                        let str:String = oDic[key] as! String
                        oDic[key] = validationHelper_RemoveCDATA(string: str) //removeCDATA
                    }
                }
            }
            
            return oDic
            
        }else{
            return originalDictionary
        }
    }
    
    
    /** Valida um CNPJ digitado*/
    class func validationHelper_Validate(CNPJ:String?) -> ToolBoxValidationResult{
        
        guard CNPJ != nil else {
            return ToolBoxValidationResult.Undefined
        }
        
        let checkComums:Int = validationHelper_ComumsCNPJ(cnpj: CNPJ!)
        
        if (checkComums != 0){
            
            return ToolBoxValidationResult.Disapproved
        }else{
            
            let checkValidate:Bool = validationHelper_ValidateDigits(cnpj: CNPJ!)
            
            if (checkValidate){
                return ToolBoxValidationResult.Approved
            }else{
                return ToolBoxValidationResult.Disapproved
            }
        }
    }
    
    
    /** Verifica se um cartão de crédito é válido */
    class func validationHelper_Validate(CreditCard:String) -> Bool{
        
        let numbers = validationHelper_OnlyNumbers(string: CreditCard)
        if numbers.characters.count < 9 {
            return false
        }
        
        var reversedString = ""
        let range: Range<String.Index> = numbers.startIndex..<numbers.endIndex
        
        numbers.enumerateSubstrings(in: range, options: [.reverse, .byComposedCharacterSequences]) { (substring, substringRange, enclosingRange, stop) -> () in
            reversedString += substring!
        }
        
        var oddSum = 0, evenSum = 0
        let reversedArray = reversedString.characters
        
        for (i, s) in reversedArray.enumerated() {
            
            let digit = Int(String(s))!
            
            if i % 2 == 0 {
                evenSum += digit
            } else {
                oddSum += digit / 5 + (2 * digit) % 10
            }
        }
        return (oddSum + evenSum) % 10 == 0

    }
    
    
    
    //MARK: - • GRAPHIC HELPER =======================================================================
    
    
    /** Cria uma cor RGB através de um texto HEX.*/
    class func graphicHelper_ColorWithHexString(string:String) -> UIColor{
        
        let colorString:String = string.replacingOccurrences(of: "#", with: "").uppercased()
        var  alpha:CGFloat, red:CGFloat, blue:CGFloat, green:CGFloat
        
        switch colorString.characters.count {
            
        case 3: // #RGB
            alpha = 1.0;
            red   = graphicHelper_ColorComponentFrom(str: colorString, start: 0, length: 1)
            green = graphicHelper_ColorComponentFrom(str: colorString, start: 1, length: 1)
            blue  = graphicHelper_ColorComponentFrom(str: colorString, start: 2, length: 1)
        
        case 4: // #ARGB
            alpha = graphicHelper_ColorComponentFrom(str: colorString, start: 0, length: 1)
            red   = graphicHelper_ColorComponentFrom(str: colorString, start: 1, length: 1)
            green = graphicHelper_ColorComponentFrom(str: colorString, start: 2, length: 1)
            blue  = graphicHelper_ColorComponentFrom(str: colorString, start: 3, length: 1)
            
        case 6: // #RRGGBB
            alpha = 1.0;
            red   = graphicHelper_ColorComponentFrom(str: colorString, start: 0, length: 1)
            green = graphicHelper_ColorComponentFrom(str: colorString, start: 2, length: 1)
            blue  = graphicHelper_ColorComponentFrom(str: colorString, start: 4, length: 1)
            
        case 8: // #AARRGGBB
            alpha = graphicHelper_ColorComponentFrom(str: colorString, start: 0, length: 1)
            red   = graphicHelper_ColorComponentFrom(str: colorString, start: 2, length: 1)
            green = graphicHelper_ColorComponentFrom(str: colorString, start: 4, length: 1)
            blue  = graphicHelper_ColorComponentFrom(str: colorString, start: 6, length: 1)
            
            
        default:
            alpha = 0.0
            red = 0.0
            green = 0.0
            blue = 0.0
            
        }
        
        return UIColor.init(colorLiteralRed: Float(red), green: Float(green), blue: Float(blue), alpha: Float(alpha))
    }
    
    
    /** Reduz o tamanho de uma imagem, aplicando compressão JPEG para otimizar o tamanho da mesma. [Ver também método 'graphicHelper_CompressImage:usingQuality:']*/
    class func graphicHelper_NormalizeImage(image:UIImage, maximumDimension:CGFloat, quality:Float) -> UIImage{
        
        let qualityI = quality < 0 ? 0 : (quality > 1 ? 1 : quality)
        
        //Convertendo outros formatos para JPEG
        let iData:Data = UIImageJPEGRepresentation(image, CGFloat(qualityI))!
        let imageR:UIImage = UIImage.init(data: iData)!
        let max:CGFloat = imageR.size.width > imageR.size.height ? imageR.size.width : imageR.size.height
        
        //Desnecessário prosseguir:
        if (max <= maximumDimension){
            return imageR
        }
        
        //Precisa redimensionar:
        
        //Tamanhos:
        let largura:CGFloat = imageR.size.width;
        let altura:CGFloat = imageR.size.height;
        var novaLargura:CGFloat = 0;
        var novaAltura:CGFloat = 0;
        
       // maxDimension = abs(maxDimension);
        
        //Imagem de retorno:
        var newImage:UIImage
        let aspectRatio:CGFloat = largura / altura
        
        if(largura > altura){
            novaLargura = maximumDimension
            novaAltura = novaLargura / aspectRatio
        }
        else{
            novaAltura = maximumDimension
            novaLargura = novaAltura * aspectRatio
        }
        
        let rect:CGRect = CGRect.init(x: 0.0, y: 0.0, width: novaLargura, height: novaAltura)
        UIGraphicsBeginImageContext(rect.size);
        image.draw(in: rect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return newImage
    }
    
    
    /** Converte uma imagem para sua representação base64 string.*/
    class func graphicHelper_EncodeToBase64String(image:UIImage?) -> String{
        
        if let img:UIImage = image{
            return UIImageJPEGRepresentation(img, 1.0)!.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithLineFeed)
        }else{
            return ""
        }
    }


    /** Converte um texto base64 para a imagem correspondente.*/
    class func graphicHelper_DecodeBase64ToImage(strEncodeData:String?) -> UIImage?{
        
        if let str:String = strEncodeData{
            let data:Data = Data.init(base64Encoded: str, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
            return UIImage.init(data: data)
        }else{
            return nil
        }
    }

    
    /** Cria uma cópia de uma imagem fazendo sobreposição de cor.*/
    class func graphicHelper_TintImage(tintColor:UIColor?, templateImage:UIImage?) -> UIImage?{
        
        if let tColor:UIColor = tintColor{
            
            if let tImage:UIImage = templateImage{
                
                var newImage:UIImage? = tImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                UIGraphicsBeginImageContextWithOptions(tImage.size, false, newImage!.scale)
                tColor.set()
                newImage?.draw(in: CGRect.init(x: 0.0, y: 0.0, width: (newImage?.size.width)!, height: (newImage?.size.height)!))
                newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                //
                return newImage
                
            }else{
                return nil
            }
            
        }else{
            return nil
        }
    }
    
 
    /** Retorna uma imagem representação do Layer parâmetro.*/
    class func graphicHelper_Snapshot(layer:CALayer?) -> UIImage?{
        
        if let iLayer:CALayer = layer{
            
            UIGraphicsBeginImageContextWithOptions(iLayer.bounds.size, iLayer.isOpaque, UIScreen.main.scale);
            iLayer.render(in: UIGraphicsGetCurrentContext()!)
            let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            //
            return image
        }else{
            return nil
        }
    }
    
    
    
    /** Retorna uma imagem representação da View parâmetro.*/;
    class func graphicHelper_Snapshot(view:UIView?) -> UIImage?{
        
        return graphicHelper_Snapshot(layer:view?.layer)
    }
    
    
    /** Retorna uma imagem representação do ViewController parâmetro.*/
    class func graphicHelper_Snapshot(viewController:UIViewController?) -> UIImage?{
        
        return graphicHelper_Snapshot(layer:viewController?.view?.layer)
    }
    
    
    /** Adiciona o efeito BLUR em uma imagem referência.*/
    class func graphicHelper_ApplyBlurEffect(image:UIImage?, radius:CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage?) -> UIImage?{
        
        if let rImage:UIImage = image{
            
            // Check pre-conditions.
            if (rImage.size.width < 1 || rImage.size.height < 1) {
                print("*** error: invalid size: \(rImage.size.width) x \(rImage.size.height). Both dimensions must be >= 1: \(self)")
                return nil
            }
            guard let cgImage = rImage.cgImage else {
                print("*** error: image must be backed by a CGImage: \(self)")
                return nil
            }
            if maskImage != nil && maskImage!.cgImage == nil {
                print("*** error: maskImage must be backed by a CGImage: \(maskImage)")
                return nil
            }
            
            let __FLT_EPSILON__ = CGFloat(FLT_EPSILON)
            let screenScale = UIScreen.main.scale
            let imageRect = CGRect(origin: CGPoint.zero, size: rImage.size)
            var effectImage = rImage
            
            let hasBlur = radius > __FLT_EPSILON__
            let hasSaturationChange = fabs(saturationDeltaFactor - 1.0) > __FLT_EPSILON__
            
            if hasBlur || hasSaturationChange {
                func createEffectBuffer(_ context: CGContext) -> vImage_Buffer {
                    let data = context.data
                    let width = vImagePixelCount(context.width)
                    let height = vImagePixelCount(context.height)
                    let rowBytes = context.bytesPerRow
                    
                    return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
                }
                
                UIGraphicsBeginImageContextWithOptions(rImage.size, false, screenScale)
                guard let effectInContext = UIGraphicsGetCurrentContext() else { return  nil }
                
                effectInContext.scaleBy(x: 1.0, y: -1.0)
                effectInContext.translateBy(x: 0, y: -rImage.size.height)
                effectInContext.draw(cgImage, in: imageRect)
                
                var effectInBuffer = createEffectBuffer(effectInContext)
                
                
                UIGraphicsBeginImageContextWithOptions(rImage.size, false, screenScale)
                
                guard let effectOutContext = UIGraphicsGetCurrentContext() else { return  nil }
                var effectOutBuffer = createEffectBuffer(effectOutContext)
                
                
                if hasBlur {
                    // A description of how to compute the box kernel width from the Gaussian
                    // radius (aka standard deviation) appears in the SVG spec:
                    // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                    //
                    // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                    // successive box-blurs build a piece-wise quadratic convolution kernel, which
                    // approximates the Gaussian kernel to within roughly 3%.
                    //
                    // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                    //
                    // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                    //
                    let inputRadius = radius * screenScale
                    let d = floor(inputRadius * 3.0 * CGFloat(sqrt(2 * Double.pi) / 4 + 0.5))
                    var radius = UInt32(d)
                    if radius % 2 != 1 {
                        radius += 1 // force radius to be odd so that the three box-blur methodology works.
                    }
                    
                    let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                    
                    vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                    vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                    vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                }
                
                var effectImageBuffersAreSwapped = false
                
                if hasSaturationChange {
                    let s: CGFloat = saturationDeltaFactor
                    let floatingPointSaturationMatrix: [CGFloat] = [
                        0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                        0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                        0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                        0,                    0,                    0,  1
                    ]
                    
                    let divisor: CGFloat = 256
                    let matrixSize = floatingPointSaturationMatrix.count
                    var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
                    
                    for i: Int in 0 ..< matrixSize {
                        saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                    }
                    
                    if hasBlur {
                        vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                        effectImageBuffersAreSwapped = true
                    } else {
                        vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    }
                }
                
                if !effectImageBuffersAreSwapped {
                    effectImage = UIGraphicsGetImageFromCurrentImageContext()!
                }
                
                UIGraphicsEndImageContext()
                
                if effectImageBuffersAreSwapped {
                    effectImage = UIGraphicsGetImageFromCurrentImageContext()!
                }
                
                UIGraphicsEndImageContext()
            }
            
            // Set up output context.
            UIGraphicsBeginImageContextWithOptions(rImage.size, false, screenScale)
            
            guard let outputContext = UIGraphicsGetCurrentContext() else { return nil }
            
            outputContext.scaleBy(x: 1.0, y: -1.0)
            outputContext.translateBy(x: 0, y: -rImage.size.height)
            
            // Draw base image.
            outputContext.draw(cgImage, in: imageRect)
            
            // Draw effect image.
            if hasBlur {
                outputContext.saveGState()
                if let maskCGImage = maskImage?.cgImage {
                    outputContext.clip(to: imageRect, mask: maskCGImage);
                }
                outputContext.draw(effectImage.cgImage!, in: imageRect)
                outputContext.restoreGState()
            }
            
            // Add in color tint.
            if let color = tintColor {
                outputContext.saveGState()
                outputContext.setFillColor(color.cgColor)
                outputContext.fill(imageRect)
                outputContext.restoreGState()
            }
            
            // Output image is ready.
            let outputImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return outputImage
            
        }else{
            return nil
        }
    }
    
    
    /** Adiciona o efeito Branco e Preto em uma imagem referência.*/
    class func graphicHelper_ApplyGrayScaleEffect(image:UIImage?, type:ToolBoxGrayScaleEffect) -> UIImage?{
        
        if let nImage:UIImage = image{
            
            let context = CIContext(options: nil)
            //
            var effect:String
            switch type {
            case ToolBoxGrayScaleEffect.Noir:
                effect = "CIPhotoEffectNoir"
            case ToolBoxGrayScaleEffect.Mono:
                effect = "CIPhotoEffectMono"
            case ToolBoxGrayScaleEffect.Tonal:
                effect = "CIPhotoEffectTonal"
            }
            //
            let currentFilter = CIFilter(name: effect)
            currentFilter!.setValue(CIImage(image: nImage), forKey: kCIInputImageKey)
            let output = currentFilter!.outputImage
            let cgimg = context.createCGImage(output!,from: output!.extent)
            let processedImage = UIImage(cgImage: cgimg!)
            //
            return processedImage
        }else{
            return nil
        }
    }
    
    
    /** Adiciona o efeito DISTORTION (CIGlassDistortion) em uma imagem referência.*/
    class func graphicHelper_ApplyGlassDistortionEffect(image:UIImage?, maskImage:UIImage?) -> UIImage?{
        
        if let nImage:UIImage = image{
            
            let context = CIContext(options: nil)
            //
            let currentFilter = CIFilter(name: "CIGlassDistortion")
            currentFilter!.setValue(CIImage(image: nImage), forKey: kCIInputImageKey)
            //
            if let mImage:UIImage = maskImage{
                currentFilter!.setValue(CIImage(image: mImage), forKey: "inputTexture")
            }else{
                currentFilter!.setValue(CIImage(image: nImage), forKey: "inputTexture")
            }
            //
            let output = currentFilter!.outputImage
            let cgimg = context.createCGImage(output!,from: output!.extent)
            let processedImage = UIImage(cgImage: cgimg!)
            //
            return processedImage
        }else{
            return nil
        }
    }
    
    
    /** Adiciona o efeito ROTATION em uma view.*/
    class func graphicHelper_ApplyRotationEffect(view:UIView, duration:TimeInterval, repeatCount:Int){
        
        let animation:CABasicAnimation = CABasicAnimation.init(keyPath: "transform.rotation.y")
        animation.fromValue = 0
        animation.toValue = 2 * M_PI
        animation.duration = duration
        animation.repeatCount = Float(repeatCount)
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        //
        view.layer.add(animation, forKey: "transform.rotation.y")
    }

    
    /** Adiciona efeito parallax na View parâmetro.*/
    class func graphicHelper_ApplyParallaxEffect(view:UIView, deep:CGFloat){
        
        let effectX:UIInterpolatingMotionEffect = UIInterpolatingMotionEffect.init(keyPath: "center.x", type: UIInterpolatingMotionEffectType.tiltAlongHorizontalAxis)
        let effectY:UIInterpolatingMotionEffect = UIInterpolatingMotionEffect.init(keyPath: "center.y", type: UIInterpolatingMotionEffectType.tiltAlongVerticalAxis)
        //
        effectX.maximumRelativeValue = deep
        effectX.minimumRelativeValue = -deep
        effectY.maximumRelativeValue = deep
        effectY.minimumRelativeValue = -deep
        //
        view.addMotionEffect(effectX)
        view.addMotionEffect(effectY)
    }
    
    
    /** Remove todos efeitos parallax da View parâmetro.*/
    class func graphicHelper_RemoveParallaxEffect(view:UIView, recursive:Bool){
        
        let motionsList:Array = Array.init(view.motionEffects)
        for me in motionsList{
            view.removeMotionEffect(me)
        }
        
        if (recursive){
            for v in view.subviews{
                let motionsList:Array = Array.init(v.motionEffects)
                for me in motionsList{
                    v.removeMotionEffect(me)
                }
            }
        }
    }
    

    /** Adiciona uma animação de efeito ripple circular na View parâmetro.*/
    class func graphicHelper_ApplyCircleRippleEffectAnimation(view:UIView, color:UIColor, radius:CGFloat, duration:TimeInterval){
        
        let m:CGFloat = radius == 0 ? (view.bounds.size.width < view.bounds.size.height ? view.bounds.size.width : view.bounds.size.height) : radius
        
        var dif:CGFloat = 0.0
        var pathFrame:CGRect
        
        if (view.bounds.size.height > view.bounds.size.width){
            dif = view.bounds.size.height - view.bounds.size.width; //Y adjust
            pathFrame = CGRect(x: -(view.bounds.size.width / 2), y: -(view.bounds.size.height / 2) + (dif/2), width: m, height: m)
        }else{
            dif = view.bounds.size.width - view.bounds.size.height; //X adjust
            pathFrame = CGRect(x: -(view.bounds.size.width / 2) + (dif/2), y: -(view.bounds.size.height / 2), width: m, height: m)
        }
        
        let path:UIBezierPath = UIBezierPath.init(roundedRect: pathFrame, cornerRadius: m/2)
        let shapePosition:CGPoint = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 2)
            
        let circleShape:CAShapeLayer = CAShapeLayer.init()
        circleShape.path = path.cgPath
        circleShape.position = shapePosition
        circleShape.fillColor = color.cgColor
        circleShape.opacity = 0
            
        view.layer.addSublayer(circleShape)
            
        let scaleAnimation:CABasicAnimation = CABasicAnimation.init(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSValue.init(caTransform3D: CATransform3DIdentity)
        scaleAnimation.toValue = NSValue.init(caTransform3D: CATransform3DMakeScale(2.0, 2.0, 1.0))
            
        let alphaAnimation:CABasicAnimation = CABasicAnimation.init(keyPath: "opacity")
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
            
        let animationGroup = CAAnimationGroup.init()
        animationGroup.animations = [scaleAnimation, alphaAnimation];
        animationGroup.duration = duration
        animationGroup.repeatCount = 0.0
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
            
        circleShape.add(animationGroup, forKey: "ripple")
    }
    
    
    /** Adiciona uma animação de efeito ripple na View parâmetro.*/
    class func graphicHelper_ApplyRippleEffectAnimationForBounds(view:UIView, color:UIColor, sizeScale:CGFloat, duration:TimeInterval){
    
        let path:UIBezierPath = UIBezierPath.init(rect: view.frame)
        let shapePosition:CGPoint = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 2)
        
        let circleShape:CAShapeLayer = CAShapeLayer.init()
        circleShape.path = path.cgPath
        circleShape.position = shapePosition
        circleShape.fillColor = color.cgColor
        circleShape.opacity = 0
        
        view.layer.addSublayer(circleShape)
        
        let scaleAnimation:CABasicAnimation = CABasicAnimation.init(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSValue.init(caTransform3D: CATransform3DIdentity)
        scaleAnimation.toValue = NSValue.init(caTransform3D: CATransform3DMakeScale(sizeScale, sizeScale, 1.0))
        
        let alphaAnimation:CABasicAnimation = CABasicAnimation.init(keyPath: "opacity")
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        
        let animationGroup = CAAnimationGroup.init()
        animationGroup.animations = [scaleAnimation, alphaAnimation];
        animationGroup.duration = duration
        animationGroup.repeatCount = 0.0
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        
        circleShape.add(animationGroup, forKey: "ripple")    
    }
    
    
    /** Adiciona uma animação de batida de coração na View parâmetro.*/
    class func graphicHelper_ApplyHeartBeatAnimation(view:UIView, scale:CGFloat){
        
        var animations:Array = [CABasicAnimation]()
        
        // Step 1
        let scaleAnimation:CABasicAnimation = CABasicAnimation.init(keyPath: "transform.scale")
        scaleAnimation.toValue = scale
        scaleAnimation.duration = 0.3
        scaleAnimation.fillMode = kCAFillModeForwards
        animations.append(scaleAnimation)
        //
        let alphaAnimation:CABasicAnimation = CABasicAnimation.init(keyPath: "opacity")
        alphaAnimation.toValue = 1.0
        alphaAnimation.duration = 0.3
        alphaAnimation.fillMode = kCAFillModeForwards
        animations.append(alphaAnimation)
        
        // Step 2
        let scaleAnimation2:CABasicAnimation = CABasicAnimation.init(keyPath: "transform.scale")
        scaleAnimation2.toValue = 1
        scaleAnimation2.beginTime = 0.3
        scaleAnimation2.duration = 0.1
        scaleAnimation2.fillMode = kCAFillModeForwards
        animations.append(scaleAnimation2)

        // Step 3
        let scaleAnimation3:CABasicAnimation = CABasicAnimation.init(keyPath: "transform.scale")
        scaleAnimation3.toValue = scale
        scaleAnimation3.beginTime = 0.4
        scaleAnimation3.duration = 0.3
        scaleAnimation3.fillMode = kCAFillModeForwards
        animations.append(scaleAnimation3)
        //
        let alphaAnimation3:CABasicAnimation = CABasicAnimation.init(keyPath: "opacity")
        alphaAnimation3.toValue = 0.0
        alphaAnimation3.beginTime = 0.4
        alphaAnimation3.duration = 0.3
        alphaAnimation3.fillMode = kCAFillModeForwards
        animations.append(alphaAnimation3)
        
        let animationGroup = CAAnimationGroup.init()
        animationGroup.animations = animations;
        animationGroup.duration = 0.7
        animationGroup.repeatCount = 0.0
        animationGroup.fillMode = kCAFillModeBoth
        
        view.layer.add(animationGroup, forKey: "heart-beat")
    }
    

    /** Adiciona uma animação de incremento/decremento de tamanho na View parâmetro.*/
    class func graphicHelper_ApplyScaleBeatAnimation(view:UIView, scale:CGFloat, repeatCount:Int){
        
        let scaleAnimation:CABasicAnimation = CABasicAnimation.init(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = scale
        scaleAnimation.duration = 0.5
        scaleAnimation.fillMode = kCAFillModeForwards
        
        let alphaAnimation:CABasicAnimation = CABasicAnimation.init(keyPath: "opacity")
        alphaAnimation.fromValue = 1.0
        alphaAnimation.toValue = 0.0
        alphaAnimation.duration = 0.5
        alphaAnimation.fillMode = kCAFillModeForwards
        
        let animationGroup = CAAnimationGroup.init()
        animationGroup.animations = [scaleAnimation, alphaAnimation];
        animationGroup.duration = 0.5
        animationGroup.repeatCount = Float(repeatCount)
        animationGroup.fillMode = kCAFillModeBoth
        
       view.layer.add(animationGroup, forKey: "scale-beat")
    }
    
    
    /** Adiciona borda na image parâmetro.*/
    class func graphicHelper_ApplyBorder(image:UIImage?, borderColor:UIColor, borderWidth:CGFloat) -> UIImage?{
        
        if let oImage:UIImage = image{
            
            let size:CGSize = CGSize(width: oImage.size.width, height: oImage.size.height)
            UIGraphicsBeginImageContext(size);
            let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            oImage.draw(in: rect, blendMode: CGBlendMode.normal, alpha: 1.0)
            let context:CGContext = UIGraphicsGetCurrentContext()!
            //
            var alpha:CGFloat = 0.0
            var red:CGFloat = 0.0
            var green:CGFloat = 0.0
            var blue:CGFloat = 0.0

            borderColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            context.setStrokeColor(red: red, green: green, blue: blue, alpha: alpha)
            context.setLineWidth(borderWidth)
            context.stroke(rect)
            //
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            //
            return newImage
            
        }else{
            return nil
        }
        
    }
    

    /** Cria uma imagem flat num tamanho específico.*/
    class func graphicHelper_CreateFlatImage(size:CGSize, corners:UIRectCorner, cornerRadius:CGSize, color:UIColor) -> UIImage{
        
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        let path:UIBezierPath = UIBezierPath.init(roundedRect: rect , byRoundingCorners: corners, cornerRadii: cornerRadius)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        path.fill()
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //
        return image
    }
    
    
    /** Adiciona sombra a View parâmetro.*/
    class func graphicHelper_ApplyShadow(view:UIView, color:UIColor, offSet:CGSize, radius:CGFloat, opacity:Float){
        
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOffset = offSet
        view.layer.shadowRadius = radius
        view.layer.shadowOpacity = opacity
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    
    /** Remove sombra da View parâmetro.*/
    class func graphicHelper_RemoveShadow(view:UIView){
        
        view.layer.shadowColor = UIColor.clear.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 0.0
        view.layer.shadowOpacity = 0.0
        
    }
    
    
    /** Corta e redimensiona circularmente uma imagem.*/
    class func graphicHelper_CircularScaleAndCrop(image:UIImage?, frame:CGRect) -> UIImage?{
        
        if let cImage:UIImage = image{
            
            //Crop
            let imageRef:CGImage = cImage.cgImage!.cropping(to: frame)!
            let croppedImage:UIImage = UIImage(cgImage:imageRef)
            
            //Draw Ellipse
            UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.size.width, height: frame.size.height), false, 1.0);
            let context:CGContext = UIGraphicsGetCurrentContext()!
            
            context.beginPath()
            context.addEllipse(in: CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height))
            context.closePath()
            context.clip()
            
            croppedImage.draw(in: CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height))
            
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

            return newImage
        }else{
            return nil
        }
    }
    
    
    /** Corta parte da imagem deferência.*/
    class func graphicHelper_Crop(image:UIImage?, frame:CGRect) -> UIImage?{
        
        if let cImage:UIImage = image{
            
            let imageRef:CGImage = cImage.cgImage!.cropping(to: frame)!
            let croppedImage:UIImage = UIImage(cgImage:imageRef)
            return croppedImage            
            
        }else{
            return nil
        }
    }
    
    
    /** Aplica uma máscara na imagem base, gerando uma nova imagem 'vazada'. A máscara deve ser uma imagem sem alpha, em escala de cinza (o branco define a transparência, preto solidez).*/
    class func graphicHelper_ApplyMask(image:UIImage?, mask:UIImage?, opaque:Bool) -> UIImage?{
        
        if let originalImage:UIImage = image{
            
            if let maskImage:UIImage = mask{
             
                let cgOriginalImage:CGImage = originalImage.cgImage!
                let cgMaskImage:CGImage = maskImage.cgImage!
                let imageMask:CGImage = CGImage.init(maskWidth: cgMaskImage.width,
                                                height: cgMaskImage.height,
                                                bitsPerComponent: cgMaskImage.bitsPerComponent,
                                                bitsPerPixel: cgMaskImage.bitsPerPixel,
                                                bytesPerRow: cgMaskImage.bytesPerRow,
                                                provider: cgMaskImage.dataProvider!, decode: nil, shouldInterpolate: true)!
            
                let maskedImage:CGImage = cgOriginalImage.masking(imageMask)!
                let newImage:UIImage = UIImage.init(cgImage: maskedImage)
                //
                UIGraphicsBeginImageContextWithOptions(newImage.size, opaque, 0)
                newImage.draw(in: CGRect(x: 0.0, y: 0.0, width: newImage.size.width, height: newImage.size.height))
                let finalImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                //
                return finalImage
                
            }else{
                return nil
            }
        }else{
            return nil
        }
    }

    
    /** Mescla duas imagens (a 'top' sobre a 'bottom'). É possível definir posição, mistura, transparência e escala para a imagem superior (top).*/
    class func graphicHelper_MergeImages(bottomImage:UIImage?, topImage:UIImage?, position:CGPoint, blendMode:CGBlendMode, alpha:CGFloat, topImageScale:Float) -> UIImage?{
        
        if let bImage:UIImage = bottomImage{
            
            if let tImage:UIImage = topImage{
                
                let topNewWidth:CGFloat = tImage.size.width * CGFloat(topImageScale)
                let topNewHeight:CGFloat = tImage.size.height * CGFloat(topImageScale)
                
                UIGraphicsBeginImageContext(bImage.size)
                
                bImage.draw(in: CGRect(x: 0.0, y: 0.0, width: bImage.size.width, height: bImage.size.height))
                
                tImage.draw(at: position, blendMode: blendMode, alpha: alpha)
                
                let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                
                return newImage
                
            }else{
                return nil
            }
            
        }else{
            return nil
        }
    }
    
    
    /** Redimensiona a imagem parâmetro para um tamanho específico.*/
    class func graphicHelper_ResizeScaleToFill(image:UIImage?, newSize:CGSize) -> UIImage?{
        
        if let originalImage:UIImage = image{
         
            UIGraphicsBeginImageContext(newSize)
            originalImage.draw(in: CGRect(x: 0.0, y: 0.0, width: newSize.width, height: newSize.height))
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            //
            return newImage
            
        }else{
            return nil
        }
    }
    

    /** Redimensiona a imagem parâmetro baseando-se numa escala. Escala 0 (zero) ou negativa será ignorada.*/
    class func graphicHelper_ResizeAspectFit(image:UIImage?, scale:CGFloat) -> UIImage? {
        
        if let originalImage:UIImage = image{
            
            let newSize:CGSize = CGSize(width: originalImage.size.width * scale, height: originalImage.size.height * scale)
            UIGraphicsBeginImageContext(newSize)
            originalImage.draw(in: CGRect(x: 0.0, y: 0.0, width: newSize.width, height: newSize.height))
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            //
            return newImage
            
        }else{
            return nil
        }
    }
    
    
    /** Redimensiona a imagem parâmetro para caiba num dado tamanho, mantendo o aspecto original. O tamanho parâmetro 'rectSize' deve ser dado em points, conforme tamanho do componente (ex.: <UIImageView>.frame.size).*/
    class func graphicHelper_ResizeProportional(image:UIImage?, rectSizeView:CGSize) -> UIImage?{
        
        if let originalImage:UIImage = image{
            
            var w:CGFloat = originalImage.size.width
            var h:CGFloat = originalImage.size.height
            let ratio:CGFloat = w / h
            
            let scale = UIScreen.main.scale
            let maxWidth:CGFloat = rectSizeView.width * scale
            let maxHeight:CGFloat = rectSizeView.height * scale
            
            if (w > maxWidth){
                w = maxWidth
                h = w / ratio
            }else if (h > maxHeight){
                h = maxHeight
                w = h * ratio
            }
            
            let newSize:CGSize = CGSize(width: w, height: h)
            UIGraphicsBeginImageContext(newSize);
            originalImage.draw(in: CGRect(x: 0.0, y: 0.0, width: newSize.width, height: newSize.height))
            
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            return newImage
            
        }else{
            return nil
        }
    }
    

    /** Comprime uma imagem para reduzir sua qualidade. O parâmetro 'image' é transformado no formato JPEG ,na qualidade correspondente.*/
    class func graphicHelper_Compress(image:UIImage?, quality:CGFloat) -> UIImage?{
        
        if let originalImage:UIImage = image{
            
            let q:CGFloat = (quality < 0.0) ? 0.0 : (quality > 1.0 ? 1.0 : quality)
            
            if let data:Data = UIImageJPEGRepresentation(originalImage, q){
                let resultImage:UIImage = UIImage(data: data)!
                return resultImage
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
    
    /** Copia uma imagem, opcionalmente modificando sua qualidade. Para 'quality' 1, é utilizado PNG, inferior JPG.*/
    class func graphicHelper_Copy(image:UIImage?, quality:CGFloat) -> UIImage? {
        
        if let originalImage:UIImage = image{
            
            if (quality >= 1.0){
                let img:UIImage? = UIImage.init(data: UIImagePNGRepresentation(originalImage)!, scale: UIScreen.main.scale)
                return img
            }else{
                
                let img2:UIImage? = UIImage.init(data: UIImageJPEGRepresentation(originalImage, quality)!, scale: UIScreen.main.scale)
                return img2
            }
        }else{
            return nil
        }
    }
    
    /** Aplica filtro na imagem parâmetro. Certos filtros exigem parâmetros adicionais que devem ser passados pelo dicionário. Visitar o endereço para ver as opções: https://developer.apple.com/library/content/documentation/GraphicsImaging/Reference/CoreImageFilterReference/#//apple_ref/doc/uid/TP30000136-SW29.*/
    class func graphicHelper_ApplyFilter(filterName:String?, image:UIImage?, parameters:[String : Any]?, scale:Float) -> UIImage?{
        
        if (ToolBox.isNil(object: filterName as AnyObject?)){
            return nil
        }
        
        if (ToolBox.isNil(object: image)){
            return nil
        }
        
        let context = CIContext(options: nil)
        //
        let currentFilter = CIFilter(name: filterName!)
        //
        if let f:CIFilter = currentFilter{
            
            f.setValue(CIImage(image: image!), forKey: kCIInputImageKey)
            //
            if (!ToolBox.isNil(object: parameters as AnyObject?)){
                f.setValuesForKeys(parameters!)
            }
            //
            let output = currentFilter!.outputImage
            let cgimg = context.createCGImage(output!,from: output!.extent)
            let processedImage = UIImage(cgImage: cgimg!)
            //
            return processedImage
            
        }else{
            return nil
        }
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
                    if(ToolBox.isNil(object: object))
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
        tempVE = tempVE.replacingOccurrences(of: SYMBOL_MONETARY, with: "")
        tempVE = tempVE.replacingOccurrences(of: SYMBOL_VOLUME_LIQUID, with: "")
        tempVE = tempVE.replacingOccurrences(of: SYMBOL_VOLUME_SOLID, with: "")
        tempVE = tempVE.replacingOccurrences(of: SYMBOL_DISTANCE, with: "")
        
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
            return String("\(SYMBOL_MONETARY) \(texto)")
        }
        else
        {
            return texto
        }
        
    }
    
    //MARK: - • PRIVATE FUNCTIONS =======================================================================

    private class func graphicHelper_ColorComponentFrom(str:String, start:Int, length:Int) -> CGFloat{
        
        let string:NSString = str as NSString
        let substring:NSString = string.substring(with: NSRange.init(location: start, length: length)) as NSString
        let fullHex:NSString = length == 2 ? substring : NSString.init(format: "%@%@", [substring, substring])
        var hexComponent:UInt32 = 0
        //
        guard Scanner(string: fullHex as String).scanHexInt32(&hexComponent)
            else {
                return 0
        }
        
        return CGFloat(hexComponent) / 255.0
    }

    private class func validationHelper_ValidateDigits(cnpj:String) -> Bool{
        
        var sum:Int = 0
        var weight:Int = 0
        
        let validatorDigit13:Int = Int(String((cnpj[cnpj.index(cnpj.startIndex, offsetBy: 12)])))!
        let validatorDigit14:Int = Int(String((cnpj[cnpj.index(cnpj.startIndex, offsetBy: 13)])))!
        var validDigit13:Int = 0
        var validDigit14:Int = 0
        
        //Verificação 13 Digito
        
        weight = 2
        
        for i in stride(from: 11, to: 1, by: -1) {
            let actualInt:Int = Int(String((cnpj[cnpj.index(cnpj.startIndex, offsetBy: i)])))!
            sum = sum + (actualInt * weight)
            
            weight += 1
            
            if (weight == 10){
                weight = 2
            }
        }
        
        if(sum % 11 == 0 || sum % 11 == 1){
            validDigit13 = 0
        }else{
            validDigit13 = 11 - sum % 11
        }
        
        //Verificação 14 Digito
        
        sum = 0
        weight = 0
        
        for i in stride(from: 12, to: 1, by: -1) {
            
            sum = sum + (Int(String((cnpj[cnpj.index(cnpj.startIndex, offsetBy: i)])))! * weight)
            weight = weight + 1
            
            if weight == 10{
                weight = 2
            }
        }
        
        if(sum % 11 == 0 || sum % 11 == 1){
            validDigit14 = 0
        }else{
            validDigit14 = 11 - sum % 11
        }
        
        //Retorno
        if (validatorDigit13 == validDigit13 && validatorDigit14 == validDigit14){
            return true
        }else{
            return false
        }
    }
    
    private class func validationHelper_OnlyNumbers(string: String) -> String {
        let set = CharacterSet.decimalDigits.inverted
        let numbers = string.components(separatedBy: set)
        return numbers.joined(separator: "")
    }
    
    private class func validationHelper_AddCDATA(string:String) -> String{
        
        let newSTR:String = String.init(format: "%@%@%@", [ToolBox.CDATA_START, string, ToolBox.CDATA_END])
        
        return newSTR
    }
    
    private class func validationHelper_RemoveCDATA(string:String) -> String{
        
        var newSTR = string
        
        if (string.hasPrefix(ToolBox.CDATA_START)){
            
            newSTR = newSTR.replacingOccurrences(of: ToolBox.CDATA_START, with: "")
            
        }
        
        if (string.hasSuffix(ToolBox.CDATA_END)){
            
            newSTR = newSTR.replacingOccurrences(of: ToolBox.CDATA_END, with: "")
        }
        
        return newSTR
    }
    
    private class func validationHelper_ComumsCNPJ(cnpj:String) -> Int{
        
        /*
         0 - Validado
         1 - Não possui 14 digitos
         2 - CNPJ não permitido: Sequencia de números
         */
        
        if (cnpj.characters.count != 14 || cnpj == ""){
            return 1
        }else if (cnpj == "00000000000000"
            || cnpj == "11111111111111"
            || cnpj == "22222222222222"
            || cnpj == "33333333333333"
            || cnpj == "44444444444444"
            || cnpj == "55555555555555"
            || cnpj == "66666666666666"
            || cnpj == "77777777777777"
            || cnpj == "88888888888888"
            || cnpj == "99999999999999"){
            return 2
        }else{
            return 0
        }
    }
    

}
