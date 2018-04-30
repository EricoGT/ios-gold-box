//
//  ToolBox.m
//  AdAliveStore
//
//  Created by Erico GT on 9/22/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "ToolBox.h"

@implementation ToolBox{}

#pragma mark - • TOOL BOX

/** Versão e responsável (da versão) do utilitário 'ToolBox'.*/
+ (NSString*) toolBoxHelper_classVersionInfo
{
    //***********************************************************************************
    //OBS: Favor não apagar as linhas anteriores. Apenas comente para referência futura.
    //***********************************************************************************
    
    //return @"Version: 1.0  |  Date: 09/12/2016  |  Autor: EricoGT  |  Note: Primeiro registro de versão.";
    //return @"Version: 2.0  |  Date: 22/12/2016  |  Autor: EricoGT  |  Note: Vários métodos adicionados ao grupo 'graphics'.";
    //return @"Version: 3.0  |  Date: 16/02/2017  |  Autor: EricoGT  |  Note: Adição de novos métodos (date/converter/GZIP).";
    //return @"Version: 4.0  |  Date: 17/02/2017  |  Autor: EricoGT  |  Note: CopyImage.";
    //return @"Version: 5.0  |  Date: 20/02/2017  |  Autor: EricoGT  |  Note: Modelos devices atualizados.";
    //return @"Version: 6.0  |  Date: 07/03/2017  |  Autor: EricoGT  |  Note: Inclusão de método pata aplicação de CIFilter.";
    //return @"Version: 7.0  |  Date: 15/03/2017  |  Autor: EricoGT  |  Note: É possível inserir borda na imagem referência.";
    //return @"Version: 8.0  |  Date: 07/04/2017  |  Autor: EricoGT  |  Note: Novos itens no grupo messureHelper.";
    //return @"Version: 9.0  |  Date: 27/04/2017  |  Autor: EricoGT  |  Note: Aplicação de efeito PB (escala de cinza) substituído.";
    //return @"Version: 10.0  |  Date: 05/05/2017  |  Autor: EricoGT  |  Note: Inclusão de métodos no grupo 'data'.";
    //return @"Version: 11.0  |  Date: 09/11/2017  |  Autor: EricoGT  |  Note: Inclusão do método para converter UIColor em Hex.";
    //return @"Version: 12.0  |  Date: 04/12/2017  |  Autor: EricoGT  |  Note: Novos métodos no grupo 'text' para inserção e remoção de máscaras.";
    //return @"Version: 13.0  |  Date: 20/02/2018  |  Autor: EricoGT  |  Note: Melhorias do tratamento de máscaras.";
    
    return @"Version: 14.0  |  Date: 10/04/2018  |  Autor: EricoGT  |  Note: Inclusão de novos modelos de dispositivos (deviceModels).";
}

#pragma mark - • APPLICATION HELPER

+ (NSString*) applicationHelper_VersionBundle
{
    return [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

+ (NSString*) applicationHelper_InstalationDataForSimulator
{
    return [NSString stringWithFormat:@"\n\n---------- Logs ----------\nClasse: %@\nMétodo: %@\nLinha: %d\nDescrição: LOCAL SIMULATOR: %@\n---------- Logs ----------\n\n", [self class], NSStringFromSelector(_cmd), __LINE__, [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject]];
}

+ (NSString*) applicationHelper_FileSize:(NSString*)fileName
{
    if(fileName==nil || [fileName isEqualToString:@""])
    {
        return @"";
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *caminho = [documentsDir stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:caminho])
    {
        NSError *error = nil;
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:caminho error:&error];
        
        if (!error)
        {
            NSNumber *size = [attributes objectForKey:NSFileSize];
            
            return [self transformedValue:size];
        }
    }
    
    return @"";
}


+ (bool) applicationHelper_VerifyFile:(NSString*)fileName
{
    if(fileName == nil || [fileName isEqualToString:@""])
    {
        return false;
    }
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *dbPath = [documentsDir stringByAppendingPathComponent:fileName];
        
        return [fileManager fileExistsAtPath:dbPath];
    }
}

+ (bool) applicationHelper_SaveFile:(NSData*)data WithName:(NSString*)fileName
{
    bool result = false;
    
    if(data && fileName != nil && ![fileName isEqualToString:@""])
    {
        @try {
            NSURL *nsurl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
            //
            NSString *path = [nsurl.path stringByAppendingPathComponent:fileName];
            result =  [data writeToFile:path atomically:YES];
        }
        @catch (NSException *exception)
        {
            NSLog(@"Erro ao salvar arquivo: %@.", exception.description);
            result = false;
        }
        @finally {
            NSLog(@"Arquivo salvo: %i.", result);
        }
    }
    
    return result;
}

+ (NSData*) applicationHelper_LoadDataFromFile:(NSString*)fileName
{
    if(fileName != nil && ![fileName isEqualToString:@""])
    {
        NSURL *nsurl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSString *path = [nsurl.path stringByAppendingPathComponent:fileName];
        NSData *d = [NSData dataWithContentsOfFile:path];
        //
        return d;
    }
    else
    {
        return nil;
    }
}

+ (bool) applicationHelper_RenameFile:(NSString*)oldFileName To:(NSString*)newFileName
{
    if(oldFileName == nil || [oldFileName isEqualToString:@""] || newFileName == nil || [newFileName isEqualToString:@""])
    {
        return false;
    }
    else
    {
        bool ok = true;
        
        @try
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *filePathOld = [documentsDirectory stringByAppendingPathComponent:oldFileName];
            NSString *filePathNew = [documentsDirectory stringByAppendingPathComponent:newFileName];
            
            NSError * err = NULL;
            NSFileManager * fm = [[NSFileManager alloc] init];
            ok = [fm moveItemAtPath:filePathOld toPath:filePathNew error:&err];
            if(!ok)
            {
                NSLog(@"Error: %@", err);
            }
        }
        @catch (NSException *exception)
        {
            ok = false;
            NSLog(@"Exception: %@", exception.description);
        }
        
        return ok;
    }
}

+ (bool) applicationHelper_DeleteFile:(NSString*)fileName
{
    if(fileName == nil || [fileName isEqualToString:@""])
    {
        return false;
    }
    else
    {
        BOOL ok = TRUE;
        
        @try
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            //
            NSString* aPath = [documentsDirectory stringByAppendingPathComponent:fileName];
            //
            if([[NSFileManager defaultManager]isDeletableFileAtPath:aPath])
            {
                NSError * err = NULL;
                
                ok = [[NSFileManager defaultManager]removeItemAtPath:aPath error:&err];
                if(!ok)
                {
                    NSLog(@"Error: %@", err);
                }
            }
        }
        @catch (NSException *exception)
        {
            ok = FALSE;
            NSLog(@"Exception: %@", exception.description);
        }
        
        return ok;
    }
}

+ (bool) applicationHelper_CopyFile:(NSString*)fileName WithName:(NSString*)copyFileName
{
    if(fileName == nil || [fileName isEqualToString:@""] || copyFileName == nil || [copyFileName isEqualToString:@""])
    {
        return false;
    }
    else
    {
        bool ok = true;
        
        @try
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *filePathOld = [documentsDirectory stringByAppendingPathComponent:fileName];
            NSString *filePathNew = [documentsDirectory stringByAppendingPathComponent:copyFileName];
            
            NSError * err = NULL;
            NSFileManager * fm = [[NSFileManager alloc] init];
            ok = [fm copyItemAtPath:filePathOld toPath:filePathNew error:&err];
            if(!ok)
            {
                NSLog(@"Error: %@", err);
            }
        }
        @catch (NSException *exception)
        {
            ok = false;
            NSLog(@"Exception: %@", exception.description);
        }
        
        return ok;
    }
}

+ (bool) applicationHelper_CloneFileFromBundleToUserDirectory:(NSString*)fileName
{
    if(fileName == nil || [fileName isEqualToString:@""])
    {
        return false;
    }
    else
    {
        bool copiado = false;
        //
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        NSString *dbPath = [documentsDir stringByAppendingPathComponent:fileName];
        
        bool success = [fileManager fileExistsAtPath:dbPath];
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (success)
        {
            copiado = true;
        }
        else
        {
            NSLog(@"Erro ao copiar arquivo %@: %@", fileName, error.localizedDescription);
        }
        
        return copiado;
    }}

+(id) transformedValue:(id)value
{
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%.2f %@", convertedValue, [tokens objectAtIndex:multiplyFactor]];//????
}

#pragma mark - • DEVICE HELPER

+ (CGSize)deviceHelper_ScreenSize
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    return screenRect.size;
}

+ (NSString*)deviceHelper_Model
{
    NSString *deviceModel;
    struct utsname systemInfo;
    uname(&systemInfo);
    
    deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if(![deviceModel isEqualToString:@"<unknown>"])
    {
        //iPhone
        if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
        if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
        if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
        if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
        if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (GSM)";
        if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
        if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
        if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
        if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
        if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C (GSM)";
        if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C (GSM+CDMA)";
        if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S (GSM)";
        if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S (GSM+CDMA)";
        if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
        if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
        if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
        if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6S Plus";
        if ([deviceModel isEqualToString:@"iPhone8,3"])    return @"iPhone SE (GSM+CDMA)";
        if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE (GSM)";
        if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
        if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
        if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
        if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
        if ([deviceModel isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
        if ([deviceModel isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
        if ([deviceModel isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
        if ([deviceModel isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
        if ([deviceModel isEqualToString:@"iPhone10,3"])    return @"iPhone X";
        if ([deviceModel isEqualToString:@"iPhone10,6"])    return @"iPhone X";
        
        //iPod
        if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1";
        if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2";
        if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3";
        if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4";
        if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5";
        //if ([deviceModel isEqualToString:@"iPod6,1"])      return @"iPod Touch 6";
        if ([deviceModel isEqualToString:@"iPod7,1"])      return @"iPod Touch 6";
        
        //iPad
        if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
        if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
        if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
        if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
        if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
        if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
        if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
        if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
        if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
        if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
        if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
        if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
        if ([deviceModel isEqualToString:@"iPad6,11"])      return @"iPad (2017)";
        if ([deviceModel isEqualToString:@"iPad6,12"])      return @"iPad (2017)";
        
        //iPad Mini
        if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
        if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
        if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
        if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
        if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
        if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
        if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
        if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
        if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
        if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
        if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (Cellular)";
        
        //iPad Air
        if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
        if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
        if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
        if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
        if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
        
        //iPad Pro
        if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro (9.7 inch, Wi-Fi)";
        if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro (9.7 inch, Wi-Fi+LTE)";
        if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro (12.9 inch, Wi-Fi)";
        if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro (12.9 inch, Wi-Fi+LTE)";
        if ([deviceModel isEqualToString:@"iPad7,1"])      return @"iPad Pro 2G";
        if ([deviceModel isEqualToString:@"iPad7,2"])      return @"iPad Pro 2G";
        if ([deviceModel isEqualToString:@"iPad7,3"])      return @"iPad Pro (10.5 inch)";
        if ([deviceModel isEqualToString:@"iPad7,4"])      return @"iPad Pro (10.5 inch)";
        
        //Watch
        if ([deviceModel isEqualToString:@"Watch1,1"])      return @"Apple Watch 38mm case";
        if ([deviceModel isEqualToString:@"Watch1,2"])      return @"Apple Watch 42mm case";
        if ([deviceModel isEqualToString:@"Watch2,6"])      return @"Apple Watch Series 1 38mm case";
        if ([deviceModel isEqualToString:@"Watch2,7"])      return @"Apple Watch Series 1 42mm case";
        if ([deviceModel isEqualToString:@"Watch2,3"])      return @"Apple Watch Series 2 38mm case";
        if ([deviceModel isEqualToString:@"Watch2,4"])      return @"Apple Watch Series 2 42mm case";
        if ([deviceModel isEqualToString:@"Watch3,1"])      return @"Apple Watch Series 3 38mm case";
        if ([deviceModel isEqualToString:@"Watch3,2"])      return @"Apple Watch Series 3 42mm case";
        if ([deviceModel isEqualToString:@"Watch3,3"])      return @"Apple Watch Series 3 38mm case";
        if ([deviceModel isEqualToString:@"Watch3,4"])      return @"Apple Watch Series 3 42mm case";
        
        //simulador
        if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
        if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    }
    
    return deviceModel;
}

+ (NSString*)deviceHelper_Name
{
    return [[UIDevice currentDevice] name];
}

+ (NSString*)deviceHelper_StorageCapacity
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber *value = [fattributes objectForKey:NSFileSystemSize];
    return [self transformedValue:value];
}

+ (NSString*)deviceHelper_FreeMemorySpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber *value = [fattributes objectForKey:NSFileSystemFreeSize];
    return [self transformedValue:value];
}

+ (NSString*)deviceHelper_SystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString*)deviceHelper_SystemLanguage
{
    NSString *langID = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *lang = [[NSLocale currentLocale] displayNameForKey:NSLocaleLanguageCode value:langID];
    return lang;
}

+ (NSString*)deviceHelper_SystemCalendar
{
    return [[NSCalendar currentCalendar] calendarIdentifier];
}

+ (NSString*) deviceHelper_IdentifierForVendor
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

#pragma mark - • DATE HELPER

//--------------------------------------------------------------------------------------------
+ (NSDate*)dateHelper_DateFromString:(NSString*)stringDate withFormat:(NSString*)dateFormat
{
    if ([stringDate isEqualToString:@""] || stringDate==nil)
    {
        return nil;
    }
    else
    {
        stringDate = [stringDate stringByReplacingOccurrencesOfString:@" 0000" withString:@" +0000"];
        //
        NSDateFormatter* formatarTextoData = [[NSDateFormatter alloc]init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [formatarTextoData setTimeZone:[NSTimeZone defaultTimeZone]];
        [formatarTextoData setCalendar:calendar];
        [formatarTextoData setDateFormat:dateFormat];
        [formatarTextoData setLocale:enUSPOSIXLocale];
        NSDate* data = [formatarTextoData dateFromString:stringDate];
        //
        return data;
    }
}

//--------------------------------------------------------------------------------------------
+ (NSDate*)dateHelper_DateFromTimeStamp:(NSTimeInterval)interval
{
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

//--------------------------------------------------------------------------------------------
+ (NSString*)dateHelper_StringFromDate:(NSDate*)date withFormat:(NSString*)format
{
    if(date==nil)
    {
        return @"";
    }
    else
    {
        NSDateFormatter* formatarParaExibir = [[NSDateFormatter alloc]init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [formatarParaExibir setTimeZone:[NSTimeZone defaultTimeZone]];
        [formatarParaExibir setCalendar:calendar];
        [formatarParaExibir setDateFormat:format];
        [formatarParaExibir setLocale:enUSPOSIXLocale];
        NSString* dataConvertida = [formatarParaExibir stringFromDate:date];
        //
        return dataConvertida;
    }
}
//--------------------------------------------------------------------------------------------

+ (NSString*)dateHelper_StringFromDate:(NSDate*)date withFormat:(NSString*)format TimeZone:(NSTimeZone*)timeZone
{
    if(date==nil)
    {
        return @"";
    }
    else
    {
        NSDateFormatter* formatarParaExibir = [[NSDateFormatter alloc]init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        if(timeZone == nil)
        {
            [formatarParaExibir setTimeZone:[NSTimeZone defaultTimeZone]];
        }
        else
        {
            [formatarParaExibir setTimeZone:timeZone];
        }
        [formatarParaExibir setCalendar:calendar];
        [formatarParaExibir setDateFormat:format];
        [formatarParaExibir setLocale:enUSPOSIXLocale];
        NSString* dataConvertida = [formatarParaExibir stringFromDate:date];
        //
        return dataConvertida;
    }
}

//--------------------------------------------------------------------------------------------
+ (NSDate*)dateHelper_SimplifyDate:(NSDate*)date
{
    if(date == nil)
    {
        return nil;
    }
    else
    {
        NSString *textoData = [self dateHelper_StringFromDate:date withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL];
        return [self dateHelper_DateFromString:textoData withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL];
    }
}

//--------------------------------------------------------------------------------------------
+ (NSDate*)dateHelper_CopyDate:(NSDate*)date
{
    if(date == nil)
    {
        return nil;
    }
    else
    {
        return [[NSDate alloc] initWithTimeInterval:0 sinceDate:date];
    }
}

//--------------------------------------------------------------------------------------------
+ (NSString*)dateHelper_CalculateAgeFromDate:(NSDate*)initialDate toDate:(NSDate*)finalDate
{
    if(initialDate==nil || finalDate==nil)
    {
        return @"";
    }
    
    initialDate = [self dateHelper_DateFromString:[self dateHelper_StringFromDate:initialDate withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL] withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL];
    finalDate = [self dateHelper_DateFromString:[self dateHelper_StringFromDate:finalDate withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL] withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:unitFlags fromDate:initialDate toDate:finalDate options:0];
    NSInteger years = [components year];
    NSInteger months = [components month];
    NSInteger days = [components day];
    
    //---------------> Retornando a idade <---------------
    if(years == 0)
    {
        if(months == 0)
        {
            if(days == 0)
            {
                //Mesma data
                return @"";
            }
            else
            {
                if(days == 1)
                {
                    return [NSString stringWithFormat:@"%d dia",(int)days];
                }
                else
                {
                    return [NSString stringWithFormat:@"%d dias",(int)days];
                }
            }
        }
        else
        {
            if(months == 1)
            {
                if(days == 0)
                {
                    return [NSString stringWithFormat:@"%d mês",(int)months];
                }
                else
                {
                    if(days == 1)
                    {
                        return [NSString stringWithFormat:@"%d mês e %d dia",(int)months,(int)days];
                    }
                    else
                    {
                        return [NSString stringWithFormat:@"%d mês e %d dias",(int)months,(int)days];
                    }
                }
            }
            else
            {
                if(days == 0)
                {
                    return [NSString stringWithFormat:@"%d meses",(int)months];
                }
                else
                {
                    if(days == 1)
                    {
                        return [NSString stringWithFormat:@"%d meses e %d dia",(int)months,(int)days];
                    }
                    else
                    {
                        return [NSString stringWithFormat:@"%d meses e %d dias",(int)months,(int)days];
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
                    return [NSString stringWithFormat:@"%d ano",(int)years];
                }
                else
                {
                    if(days == 1)
                    {
                        return [NSString stringWithFormat:@"%d ano e %d dia",(int)years,(int)days];
                    }
                    else
                    {
                        return [NSString stringWithFormat:@"%d ano e %d dias",(int)years,(int)days];
                    }
                }
            }
            else
            {
                if(months == 1)
                {
                    if(days == 0)
                    {
                        return [NSString stringWithFormat:@"%d ano e %d mês",(int)years,(int)months];
                    }
                    else
                    {
                        if(days == 1)
                        {
                            return [NSString stringWithFormat:@"%d ano, %d mês e %d dia",(int)years,(int)months,(int)days];
                        }
                        else
                        {
                            return [NSString stringWithFormat:@"%d ano, %d mês e %d dias",(int)years,(int)months,(int)days];
                        }
                    }
                }
                else
                {
                    if(days == 0)
                    {
                        return [NSString stringWithFormat:@"%d ano e %d meses",(int)years,(int)months];
                    }
                    else
                    {
                        if(days == 1)
                        {
                            return [NSString stringWithFormat:@"%d ano, %d meses e %d dia",(int)years,(int)months,(int)days];
                        }
                        else
                        {
                            return [NSString stringWithFormat:@"%d ano, %d meses e %d dias",(int)years,(int)months,(int)days];
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
                    return [NSString stringWithFormat:@"%d anos",(int)years];
                }
                else
                {
                    if(days == 1)
                    {
                        return [NSString stringWithFormat:@"%d anos e %d dia",(int)years,(int)days];
                    }
                    else
                    {
                        return [NSString stringWithFormat:@"%d anos e %d dias",(int)years,(int)days];
                    }
                }
            }
            else
            {
                if(months == 1)
                {
                    if(days == 0)
                    {
                        return [NSString stringWithFormat:@"%d anos e %d mês",(int)years,(int)months];
                    }
                    else
                    {
                        if(days == 1)
                        {
                            return [NSString stringWithFormat:@"%d anos, %d mês e %d dia",(int)years,(int)months,(int)days];
                        }
                        else
                        {
                            return [NSString stringWithFormat:@"%d anos, %d mês e %d dias",(int)years,(int)months,(int)days];
                        }
                    }
                }
                else
                {
                    if(days == 0)
                    {
                        return [NSString stringWithFormat:@"%d anos e %d meses",(int)years,(int)months];
                    }
                    else
                    {
                        if(days == 1)
                        {
                            return [NSString stringWithFormat:@"%d anos, %d meses e %d dia",(int)years,(int)months,(int)days];
                        }
                        else
                        {
                            return [NSString stringWithFormat:@"%d anos, %d meses e %d dias",(int)years,(int)months,(int)days];
                        }
                    }
                }
            }
        }
    }
}

//--------------------------------------------------------------------------------------------
+ (NSString*)dateHelper_CalculateTimeFromDate:(NSDate*)initialDate toDate:(NSDate*)finalDate
{
    if(initialDate==nil || finalDate==nil)
    {
        return @"";
    }
    
    NSTimeInterval timeT = [initialDate timeIntervalSinceDate:finalDate];
    
    timeT = fabs(timeT);
    
    NSInteger hoursBetweenDates = timeT / 3600; //60 * 60
    
    NSInteger minutesLeft = (long)timeT % 3600;
    
    minutesLeft = minutesLeft / 60;
    
    if(hoursBetweenDates == 0)
    {
        if(minutesLeft == 0)
        {
            return @"menos de 1 minuto";
        }
        else if(minutesLeft == 1)
        {
            return @"1 minuto";
        }
        else
        {
            return [NSString stringWithFormat:@"%lu minutos", (long)minutesLeft];
        }
    }
    else if(hoursBetweenDates == 1)
    {
        if(minutesLeft == 0)
        {
            return @"1 hora";
        }
        else if(minutesLeft == 1)
        {
            return @"1 hora e 1 minuto";
        }
        else
        {
            return [NSString stringWithFormat:@"1 hora e %lu minutos", (long)minutesLeft];
        }
    }
    else
    {
        if(minutesLeft == 0)
        {
            return [NSString stringWithFormat:@"%lu horas", (long)hoursBetweenDates];
        }
        else if(minutesLeft == 1)
        {
            return [NSString stringWithFormat:@"%lu horas e 1 minuto", (long)hoursBetweenDates];
        }
        else
        {
            return [NSString stringWithFormat:@"%lu horas e %lu minutos", (long)hoursBetweenDates, (long)minutesLeft];
        }
    }
}

//--------------------------------------------------------------------------------------------
+ (NSInteger)dateHelper_CalculateTotalDaysBetweenInitialDate:(NSDate*)initialDate andFinalDate:(NSDate*)finalDate
{
    if(initialDate == nil || finalDate == nil)
    {
        return 0;
    }
    else
    {
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:initialDate toDate:finalDate options:0];
        return [components day];
    }
}

//--------------------------------------------------------------------------------------------
+ (NSInteger)dateHelper_CalculateTotalHoursBetweenInitialDate:(NSDate*)initialDate andFinalDate:(NSDate*)finalDate
{
    if(initialDate == nil || finalDate == nil)
    {
        return 0;
    }
    else
    {
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitHour fromDate:initialDate toDate:finalDate options:0];
        
        return [components hour];
    }
}

//--------------------------------------------------------------------------------------------
+ (NSDate*)dateHelper_NewDateForReferenceDate:(NSDate*)referenceDate offSet:(long)offSet forCalendarUnit:(NSCalendarUnit)unitCalendar
{
    if(referenceDate == nil)
    {
        return nil;
    }
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *calendarComponent = [NSDateComponents new];
    [calendarComponent setValue:offSet forComponent:unitCalendar];
    NSDate *newDate = [gregorianCalendar dateByAddingComponents:calendarComponent toDate:referenceDate options:0];
    return newDate;
}

//--------------------------------------------------------------------------------------------
+ (NSDate*)dateHelper_FirtsDayOfMonthForReferenceDate:(NSDate*)referenceDate
{
    if(referenceDate == nil)
    {
        return nil;
    }
    else
    {
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comp = [gregorianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:referenceDate];
        [comp setDay:1];
        return [gregorianCalendar dateFromComponents:comp];
    }
}

//--------------------------------------------------------------------------------------------
+ (NSDate*)dateHelper_LastDayOfMonthForReferenceDate:(NSDate*)referenceDate
{
    if(referenceDate == nil)
    {
        return nil;
    }
    else
    {
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSRange dayRange = [gregorianCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:referenceDate];
        NSInteger dayCount = dayRange.length;
        NSDateComponents *comp = [gregorianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:referenceDate];
        [comp setDay:dayCount];
        return [gregorianCalendar dateFromComponents:comp];
    }
    
}

//--------------------------------------------------------------------------------------------
+ (int)dateHelper_ActualYear
{
    NSDate* dataAtual=  [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitYear fromDate:dataAtual];
    return (int)[dateComponent year];
}

//--------------------------------------------------------------------------------------------
+ (long)dateHelper_ValueForUnit:(NSCalendarUnit)calendarUnit referenceDate:(NSDate*)date
{
    if(date == nil)
    {
        return -1;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:calendarUnit fromDate:date];
    return [dateComponent valueForComponent:calendarUnit];
    
    /*
    switch (calendarUnit)
    {
        case NSCalendarUnitYear:
        {
            NSDateComponents *dateComponent = [calendar components:NSCalendarUnitYear fromDate:date];
            return (int)[dateComponent year];
        }break;
            
        case NSCalendarUnitMonth:
        {
            NSDateComponents *dateComponent = [calendar components:NSCalendarUnitMonth fromDate:date];
            return (int)[dateComponent month];
        }break;
            
        case NSCalendarUnitDay:
        {
            NSDateComponents *dateComponent = [calendar components:NSCalendarUnitDay fromDate:date];
            return (int)[dateComponent day];
        }break;
            
        case NSCalendarUnitHour:
        {
            NSDateComponents *dateComponent = [calendar components:NSCalendarUnitHour fromDate:date];
            return (int)[dateComponent hour];
        }break;
            
        case NSCalendarUnitMinute:
        {
            NSDateComponents *dateComponent = [calendar components:NSCalendarUnitMinute fromDate:date];
            return (int)[dateComponent minute];
        }break;
            
        case NSCalendarUnitSecond:
        {
            NSDateComponents *dateComponent = [calendar components:NSCalendarUnitSecond fromDate:date];
            return (int)[dateComponent second];
        }break;
            
        case NSCalendarUnitWeekday:
        {
            NSDateComponents *dateComponent = [calendar components:NSCalendarUnitWeekday fromDate:date];
            return (int)[dateComponent weekday];
        }break;
            
        default:
        {
            return -1;
        }break;
    }
     */
}

//--------------------------------------------------------------------------------------------
+ (long int)dateHelper_TimeStampInSecondsFromDate:(NSDate*)date;
{
    if(date == nil)
    {
        return 0;
    }
    
    time_t unixTime = (time_t) [date timeIntervalSince1970];
    long int totalEmSegundos = unixTime;
    
    return totalEmSegundos;
}

//--------------------------------------------------------------------------------------------
+ (NSTimeInterval)dateHelper_TimeStampFromDate:(NSDate*)date
{
    return [date timeIntervalSince1970];
}

//--------------------------------------------------------------------------------------------
+ (NSString*)dateHelper_TimeStampCompleteIOSfromDate:(NSDate*)date
{
    if(date == nil)
    {
        return @"";
    }
    
    NSString *nString = [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    nString = [nString stringByReplacingOccurrencesOfString:@"." withString:@""];
    nString = [nString stringByReplacingOccurrencesOfString:@"," withString:@""];
    //
    return nString;
}

//--------------------------------------------------------------------------------------------
+ (bool)dateHelper_CompareDate:(NSDate*)date1 withDate:(NSDate*)date2 usingRule:(enumComparationRules)rule
{
    if(date1 == nil)
    {
        if(date2 == nil)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    else
    {
        if(date2 == nil)
        {
            return false;
        }
        else
        {
            NSCalendar* calendar = [NSCalendar currentCalendar];
            unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
            NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
            NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
            
            for(int i=1; i< 8; i++)
            {
                switch (i)
                {
                    case 1: //Ano Maior
                    {
                        if([comp1 year] > [comp2 year])
                        {
                            if(rule==tbComparationRule_Greater || rule==tbComparationRule_GreaterOrEqual)
                            {
                                return TRUE;
                            }
                            else
                            {
                                return FALSE;
                            }
                        }
                    }break;
                        
                    case 2: //Ano Menor
                    {
                        if([comp1 year] < [comp2 year])
                        {
                            if(rule==tbComparationRule_Less || rule==tbComparationRule_LessOrEqual)
                            {
                                return TRUE;
                            }
                            else
                            {
                                return FALSE;
                            }
                        }
                    }break;
                        
                    case 3: //Ano Igual / Mês Menor
                    {
                        if([comp1 month] > [comp2 month])
                        {
                            if(rule==tbComparationRule_Greater || rule==tbComparationRule_GreaterOrEqual)
                            {
                                return TRUE;
                            }
                            else
                            {
                                return FALSE;
                            }
                        }
                    }break;
                        
                    case 4: //Ano Igual / Mês Maior
                    {
                        if([comp1 month] < [comp2 month])
                        {
                            if(rule==tbComparationRule_Less || rule==tbComparationRule_LessOrEqual)
                            {
                                return TRUE;
                            }
                            else
                            {
                                return FALSE;
                            }
                        }
                    }break;
                        
                    case 5: //Ano Igual / Mês Igual / Dia Menor
                    {
                        if([comp1 day] > [comp2 day])
                        {
                            if(rule==tbComparationRule_Greater || rule==tbComparationRule_GreaterOrEqual)
                            {
                                return TRUE;
                            }
                            else
                            {
                                return FALSE;
                            }
                        }
                    }break;
                        
                    case 6: //Ano Igual / Mês Igual / Dia Meior
                    {
                        if([comp1 day] < [comp2 day])
                        {
                            if(rule==tbComparationRule_Less || rule==tbComparationRule_LessOrEqual)
                            {
                                return TRUE;
                            }
                            else
                            {
                                return FALSE;
                            }
                        }
                    }break;
                        
                    case 7: //Ano Igual / Mês Igual / Dia Igual
                    {
                        if([comp1 day] == [comp2 day])
                        {
                            if(rule==tbComparationRule_Equal || rule==tbComparationRule_GreaterOrEqual || rule==tbComparationRule_LessOrEqual)
                            {
                                return TRUE;
                            }
                            else
                            {
                                return FALSE;
                            }
                        }
                    }
                        
                    default:
                    {
                        return FALSE;
                    }break;
                }
            }
            return FALSE;
        }
    }
}

//--------------------------------------------------------------------------------------------
+ (NSString*)dateHelper_MonthAndYearForReferenceDate:(NSDate*)referenceDate usingAbbreviation:(bool)abbreviation
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:referenceDate];
    
    return [NSString stringWithFormat:@"%@/%d",[self dateHelper_StringMonthForIndex:[dateComponent month] abbreviation:abbreviation], (int)[dateComponent year]];
}

//--------------------------------------------------------------------------------------------
+ (NSString*)dateHelper_StringMonthForIndex:(int)index abbreviation:(bool)abbreviation
{
    switch (index)
    {
        case 1:{return (abbreviation ? @"JAN" : @"Janeiro");}break;
        case 2:{return (abbreviation ? @"FEV" : @"Fevereiro");}break;
        case 3:{return (abbreviation ? @"MAR" : @"Março");}break;
        case 4:{return (abbreviation ? @"ABR" : @"Abril");}break;
        case 5:{return (abbreviation ? @"MAI" : @"Maio");}break;
        case 6:{return (abbreviation ? @"JUN" : @"Junho");}break;
        case 7:{return (abbreviation ? @"JUL" : @"Julho");}break;
        case 8:{return (abbreviation ? @"AGO" : @"Agosto");}break;
        case 9:{return (abbreviation ? @"SET" : @"Setembro");}break;
        case 10:{return (abbreviation ? @"OUT" : @"Outubro");}break;
        case 11:{return (abbreviation ? @"NOV" : @"Novembro");}break;
        case 12:{return (abbreviation ? @"DEZ" : @"Dezembro");}break;
        default:{return (abbreviation ? @"IND" : @"Indefinido");}break;
    }
}

//--------------------------------------------------------------------------------------------
+ (NSString*)dateHelper_DayOfTheWeekNameForIndex:(int)indexDay usingAbbreviation:(bool)abbreviation
{
    switch (indexDay)
    {
        case 1:{return (abbreviation ? @"DOM" : @"Domingo");}break;
        case 2:{return (abbreviation ? @"SEG" : @"Segunda-Feira");}break;
        case 3:{return (abbreviation ? @"TER" : @"Terça-Feira");}break;
        case 4:{return (abbreviation ? @"QUA" : @"Quarta-Feira");}break;
        case 5:{return (abbreviation ? @"QUI" : @"Quinta-Feira");}break;
        case 6:{return (abbreviation ? @"SEX" : @"Sexta-Feira");}break;
        case 7:{return (abbreviation ? @"SAB" : @"Sábado");}break;
        default:{return (abbreviation ? @"IND" : @"Indefinido");}break;
    }
}

//--------------------------------------------------------------------------------------------
+ (NSString*)dateHelper_MonthNameForIndex:(int)indexMonth usingAbbreviation:(bool)abbreviation
{
    return [self dateHelper_StringMonthForIndex:indexMonth abbreviation:abbreviation];
}

//--------------------------------------------------------------------------------------------
+ (NSString*)dateHelper_CompleteStringFromDate:(NSDate*)referenceDate
{
    if(referenceDate==nil)
    {
        return @"";
    }
    else
    {
        //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"EEEE, dd 'de' MMMM 'de' yyyy, kk:mm:ss."];
        //[dateFormatter setDateStyle:NSDateFormatterLongStyle];
        //[dateFormatter setTimeStyle:NSDateFormatterLongStyle];
        NSString *myDateString = [dateFormatter stringFromDate:referenceDate];
        
        return myDateString;
    }
}

//--------------------------------------------------------------------------------------------
+ (NSString*)dateHelper_IdentifiesYesterdayTodayTomorrowFromDate:(NSDate*)referenceDate
{
    if(referenceDate==nil)
    {
        return @"";
    }
    else
    {
        NSDate *dhoje = [NSDate date];
        NSDate *dontem = [dhoje dateByAddingTimeInterval:(60*60*24*1)*(-1)];
        NSDate *damanha = [dhoje dateByAddingTimeInterval:(60*60*24*1)*(+1)];
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [df setCalendar:calendar];
        [df setDateFormat:@"dd/MM/yyyy"];
        
        NSString *dataHoje = [df stringFromDate:dhoje];
        NSString *dataOntem = [df stringFromDate:dontem];
        NSString *dataAmanha = [df stringFromDate:damanha];
        //
        NSString *dataRegistro = [df stringFromDate:referenceDate];
        if([dataRegistro isEqualToString:dataHoje])
        {
            return NSLocalizedString(@"LABEL_CHAT_TODAY", @"");
        }
        //
        if([dataRegistro isEqualToString:dataOntem])
        {
            return NSLocalizedString(@"LABEL_CHAT_YESTERDAY", @"");
        }
        //
        if([dataRegistro isEqualToString:dataAmanha])
        {
            return NSLocalizedString(@"LABEL_CHAT_TOMORROW", @"");
        }
        
        return dataRegistro;
    }
}

//--------------------------------------------------------------------------------------------
+ (NSString*)dateHelper_IdentifiesDayPeriodFromDate:(NSDate*)referenceDate
{
    if(referenceDate == nil)
    {
        return nil;
    }
    else
    {
        NSLocale *brLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
        //
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [gregorian setLocale:brLocale];
        NSDateComponents *components = [gregorian components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:referenceDate];
        
        if([components hour]>=18)
        {
            return @"Noite";
        }
        else
        {
            if([components hour]>=12)
            {
                return @"Tarde";
            }
            else
            {
                if([components hour]>=6)
                {
                    return @"Dia";
                }
                else
                {
                    return @"Madrugada";
                }
            }
        }
    }
}

//--------------------------------------------------------------------------------------------
+ (NSString*)dateHelper_SystemTimeUsingMask
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    
    if([[dateFormatter dateFormat] rangeOfString:@"a"].location != NSNotFound)
    {
        // user prefers 12 hour clock
        return @"h:mm:ss a";
    }
    else
    {
        // user prefers 24 hour clock
        return @"HH:mm:ss";
    }
}

//--------------------------------------------------------------------------------------------
+ (NSDate *)dateHelper_CompleteDateFromDate:(NSDate *)date andHour:(NSDate *)hour
{
    
    NSDateComponents *final = [[NSDateComponents alloc] init];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setLocale: [NSLocale currentLocale]];
    NSDateComponents *refDate = [gregorian components:  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    NSDateComponents *refHour = [gregorian components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:hour];
    
    [final setDay: refDate.day];
    [final setMonth: refDate.month];
    [final setYear: refDate.year];
    [final setMinute: refHour.minute];
    [final setHour: refHour.hour];
    
    NSDate *finalDate = [gregorian dateFromComponents:final];
    return finalDate;
    
}

//--------------------------------------------------------------------------------------------
+ (NSString*)dateHelper_FriendlyStringFromDate:(NSDate*)date
{
    if (date == nil){
        return @"-";
    }else{
        
        NSDate *dhoje = [NSDate date];
        NSDate *dontem = [dhoje dateByAddingTimeInterval:(60*60*24*1)*(-1)];
        NSDate *dsemana = [dhoje dateByAddingTimeInterval:(60*60*24*1)*(-7)];
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [df setCalendar:calendar];
        [df setDateFormat:@"dd/MM/yyyy"];
        
        NSString *dataHoje = [df stringFromDate:dhoje];
        NSString *dataOntem = [df stringFromDate:dontem];
        
        NSString *dataRegistro = [df stringFromDate:date];
        //Se hoje:
        if([dataRegistro isEqualToString:dataHoje])
        {
            return [NSString stringWithFormat:@"%@, %@",NSLocalizedString(@"TOOL_BOX_CALENDAR_LABEL_TODAY", @""), [self dateHelper_StringFromDate:date withFormat:@"HH:mm"]];
        }
        //Se ontem:
        if([dataRegistro isEqualToString:dataOntem])
        {
            return [NSString stringWithFormat:@"%@, %@",NSLocalizedString(@"TOOL_BOX_CALENDAR_LABEL_YESTERDAY", @""), [self dateHelper_StringFromDate:date withFormat:@"HH:mm"]];
        }
        //Verifica espaço dentro da mesma semana:
        if ([date timeIntervalSinceDate:dsemana] >= 0){
            
            NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
            long weekday = [comps weekday];
            //
            NSString *dayName = [self dateHelper_StringFromDate:date withFormat:@"dd/MM/yyyy"];
            switch (weekday) {
                case 1:{dayName = NSLocalizedString(@"TOOL_BOX_CALENDAR_DAYOFWEEK_DAY_1", @"");}break; //dia 1 é domingo
                case 2:{dayName = NSLocalizedString(@"TOOL_BOX_CALENDAR_DAYOFWEEK_DAY_2", @"");}break;
                case 3:{dayName = NSLocalizedString(@"TOOL_BOX_CALENDAR_DAYOFWEEK_DAY_3", @"");}break;
                case 4:{dayName = NSLocalizedString(@"TOOL_BOX_CALENDAR_DAYOFWEEK_DAY_4", @"");}break;
                case 5:{dayName = NSLocalizedString(@"TOOL_BOX_CALENDAR_DAYOFWEEK_DAY_5", @"");}break;
                case 6:{dayName = NSLocalizedString(@"TOOL_BOX_CALENDAR_DAYOFWEEK_DAY_6", @"");}break;
                case 7:{dayName = NSLocalizedString(@"TOOL_BOX_CALENDAR_DAYOFWEEK_DAY_7", @"");}break;
            }
            
            return [NSString stringWithFormat:@"%@, %@", dayName, [ToolBox dateHelper_StringFromDate:date withFormat:@"HH:mm"]];
            
        }else{
            //Data completa
            return [ToolBox dateHelper_StringFromDate:date withFormat:@"dd/MM/yyyy, HH:mm"];
        }
    }
    
    return @"-";
}

//--------------------------------------------------------------------------------------------
+ (NSString*)dateHelper_NewStringDateForText:(NSString*)dateText originalFormat:(NSString*)originalFormat newFormat:(NSString*)newFormat
{
    if (([dateText isEqualToString:@""] || dateText==nil) || ([originalFormat isEqualToString:@""] || originalFormat==nil) || ([newFormat isEqualToString:@""] || newFormat==nil))
    {
        return nil;
    }
    else
    {
        NSDate *date = [self dateHelper_DateFromString:dateText withFormat:originalFormat];
        NSString *strDate = [self dateHelper_StringFromDate:date withFormat:newFormat];
        return strDate;
    }
}

#pragma mark - • MESSURE HELPER


+ (double)messureHelper_NormalizeValue:(double)value decimalPrecision:(int)precision
{
    double normalizador = powf(10, precision);
    double result = (ceil(value * normalizador))/normalizador;
    return result;
}

+ (bool)messureHelper_CheckEqualityFromValue:(double)value1 andValue:(double)value2 decimalPrecision:(int)precision
{
    NSString *vString1 = [self converterHelper_StringFromValue:value1 monetaryFormat:true decimalPrecision:precision];
    NSString *vString2 = [self converterHelper_StringFromValue:value2 monetaryFormat:true decimalPrecision:precision];
    //
    double vDouble1 = [self converterHelper_DecimalValueFromText:vString1];
    double vDouble2 = [self converterHelper_DecimalValueFromText:vString2];
    //
    return (vDouble1 == vDouble2);
}

+ (NSString*)messureHelper_FormatSizeString:(double)size
{
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",nil];
    
    while (size > 1024) {
        size /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%.2f %@", size, [tokens objectAtIndex:multiplyFactor]];
}

+ (CGFloat) messureHelper_HeightForText:(NSString*)text constrainedWidth:(CGFloat)cWitdh textFont:(UIFont*)font
{
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(cWitdh, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                                       attributes:@{NSFontAttributeName:font}
                                                          context:nil];
    
    return textRect.size.height;
}

+ (CGFloat) messureHelper_WidthOrHeightForText:(NSString*)text constrainedWidth:(CGFloat)cWitdh  constrainedHeight:(CGFloat)cHeight textFont:(UIFont*)font
{
    if (cWitdh != 0.0 && cHeight != 0.0){
        //Ambos os parâmetros não podem ser usados ao mesmo tempo
        return 0.0;
    }else if(cWitdh == 0.0 && cHeight == 0.0){
        //Ambos os parâmetros não podem ser zero
        return 0.0;
    }else{
        
        if (cWitdh == 0.0){
            //Retorna a largura
            CGRect textRect = [text boundingRectWithSize:CGSizeMake(cWitdh, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName:font}
                                                 context:nil];
            return textRect.size.width;
        }else{
            //Retorna a altura
            CGRect textRect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, cHeight)
                                                 options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName:font}
                                                 context:nil];
            return textRect.size.height;
        }
    }
}

#pragma mark - • VALIDATION HELPER

+ (enumValidationResult)validationHelper_EmailChecker:(NSString*)email
{
    if(email == nil || [email isEqualToString:@""])
    {
        return tbValidationResult_Undefined;
    }
    else
    {
        //Antigos
        //iOS: [A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}
        //Android: "[a-zA-Z0-9_.-]+@[a-zA-Z0-9_.-]*\\.+[a-zA-Z]{2,4}"
        
        BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
        NSString *stricterFilterString = @"^[_a-zA-Z0-9-]+([.]{1}[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+([.]{1}[a-zA-Z0-9-]+)*([.]{1}[a-zA-Z]{2,6})";
        NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if([emailTest evaluateWithObject:email]==false)
        {
            return tbValidationResult_Disapproved;
        }
        return tbValidationResult_Approved;
    }
}

+ (enumValidationResult)validationHelper_TextCheck:(NSString*)text withList:(NSArray*)validationList restricting:(bool)restrictForList
{
    if((text == nil || validationList == nil) || validationList.count==0 || [text isEqualToString:@""])
    {
        return tbValidationResult_Undefined;
    }
    else
    {
        if(restrictForList) //somente aceita caracteres da lista
        {
            for(int i=0; i<text.length; i++)
            {
                bool ok2 = false;
                
                for(int j=0; j<validationList.count; j++)
                {
                    NSString* s = [validationList objectAtIndex:j];
                    
                    if([[NSString stringWithFormat:@"%c",[text characterAtIndex:i]] isEqualToString:[NSString stringWithFormat:@"%c",[s characterAtIndex:0]]])
                    {
                        ok2 = true;
                        break;
                    }
                }
                
                if(!ok2)
                {
                    return tbValidationResult_Disapproved;
                }
            }
            
            return tbValidationResult_Approved;
        }
        else //rejeita todos caracteres da lista
        {
            for(int i=0; i<text.length; i++)
            {
                bool ok2 = true;
                
                for(int j=0; j<validationList.count; j++)
                {
                    NSString* s = [validationList objectAtIndex:j];
                    
                    if([[NSString stringWithFormat:@"%c",[text characterAtIndex:i]] isEqualToString:[NSString stringWithFormat:@"%c",[s characterAtIndex:0]]])
                    {
                        ok2 = false;
                        break;
                    }
                }
                
                if(!ok2)
                {
                    return tbValidationResult_Disapproved;
                }
            }
            
            return tbValidationResult_Approved;
        }
    }
}

+ (NSArray*)validationHelper_NewListOfCharactersWithNumbers:(bool)numbers capsLetters:(bool)capsLetters minusLetters:(bool)minusLetters symbols:(bool)symbols controlCharacters:(bool)control
{
    NSMutableArray *lista = [NSMutableArray new];
    
    if(numbers)
    {
        [lista addObjectsFromArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"]];
    }
    
    if(capsLetters)
    {
        [lista addObjectsFromArray:@[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"]];
    }
    
    if(minusLetters)
    {
        [lista addObjectsFromArray:@[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z"]];
    }
    
    if(symbols)
    {
        [lista addObjectsFromArray:@[@" ", @"!", @"?", @".", @",", @";", @":", @"\"", @"\'", @"<", @">", @"[", @"]", @"(", @")", @"{", @"}", @"@", @"#", @"$", @"%", @"&", @"*", @"/", @"\\",@"|", @"-", @"_", @"+", @"=", @"^", @"ª", @"º"]];
    }
    
    if(control)
    {
        [lista addObjectsFromArray:@[@"\a", @"\b", @"\t", @"\n", @"\v", @"\f", @"\r", @"\e"]];
    }
    
    return [NSArray arrayWithArray:lista];
}

+ (NSString*)validationHelper_MIMETypeForWebContent:(NSString*)url
{
    if(url==nil || [url isEqualToString:@""])
    {
        return @"";
    }
    
    NSArray *lista = [[NSArray alloc]initWithArray:[url componentsSeparatedByString:@"."]];
    
    if(lista.count>0)
    {
        NSString *s = [lista objectAtIndex:lista.count-1];
        
        if([[s uppercaseString] isEqualToString:@"JPE"]){ return @"image/jpeg";}
        
        if([[s uppercaseString] isEqualToString:@"JPEG"]){ return @"image/jpeg";}
        
        if([[s uppercaseString] isEqualToString:@"JPG"]){ return @"image/jpeg";}
        
        if([[s uppercaseString] isEqualToString:@"BM"]){ return @"image/bmp";}
        
        if([[s uppercaseString] isEqualToString:@"BMP"]){ return @"image/bmp";}
        
        if([[s uppercaseString] isEqualToString:@"PNG"]){ return @"image/png";}
        
        if([[s uppercaseString] isEqualToString:@"GIF"]){ return @"image/gif";}
    }
    
    return @"";
}

+ (bool)validationHelper_ValidateBoleanForText:(NSString*)text comparing:(bool)comparationValue
{
    if(text == nil || [text isEqualToString:@""])
    {
        return false;
    }
    
    if(comparationValue)
    {
        if([[text uppercaseString] isEqualToString:@"1"]){return true;}
        //
        if([[text uppercaseString] isEqualToString:@"TRUE"]){return true;}
        //
        if([[text uppercaseString] isEqualToString:@"YES"]){return true;}
        //
        if([[text uppercaseString] isEqualToString:@"ON"]){return true;}
        //
        if([[text uppercaseString] isEqualToString:@"ENABLE"]){return true;}
        
        
        if([[text uppercaseString] isEqualToString:@"VERDADEIRO"]){return true;}
        //
        if([[text uppercaseString] isEqualToString:@"SIM"]){return true;}
        //
        if([[text uppercaseString] isEqualToString:@"LIGADO"]){return true;}
        //
        if([[text uppercaseString] isEqualToString:@"ATIVO"]){return true;}
        //
        if([[text uppercaseString] isEqualToString:@"ATIVADO"]){return true;}
        
        
        if([[text uppercaseString] isEqualToString:@"T"]){return true;}
        if([[text uppercaseString] isEqualToString:@"Y"]){return true;}
        if([[text uppercaseString] isEqualToString:@"S"]){return true;}
    }
    else
    {
        if([[text uppercaseString] isEqualToString:@"0"]){return true;}
        //
        if([[text uppercaseString] isEqualToString:@"FALSE"]){return true;}
        //
        if([[text uppercaseString] isEqualToString:@"NO"]){return true;}
        //
        if([[text uppercaseString] isEqualToString:@"OFF"]){return true;}
        //
        if([[text uppercaseString] isEqualToString:@"DISABLE"]){return true;}
        
        
        if([[text uppercaseString] isEqualToString:@"FALSO"]){return true;}
        //
        if([[text uppercaseString] isEqualToString:@"NÃO"]){return true;}
        //
        if([[text uppercaseString] isEqualToString:@"NAO"]){return true;}
        //
        if([[text uppercaseString] isEqualToString:@"DESLIGADO"]){return true;}
        //
        if([[text uppercaseString] isEqualToString:@"DESATIVADO"]){return true;}
        
        
        if([[text uppercaseString] isEqualToString:@"F"]){return true;}
        if([[text uppercaseString] isEqualToString:@"N"]){return true;}
    }
    
    return false;
}

+ (enumValidationResult)validationHelper_ValidateCPF:(NSString*)cpfText
{
    //VERIFICA SE CPF TEM 11 DIGITOS
    if ([cpfText length] != 11 || [cpfText isEqualToString:@""])
    {
        return tbValidationResult_Disapproved;
    }
    else
    {
        //VERIFICA SEQUENCIA DE CARACTERES INVÁLIDAS
        if ([cpfText isEqualToString:@"00000000000"] || [cpfText isEqualToString:@"11111111111"] || [cpfText isEqualToString:@"22222222222"] || [cpfText isEqualToString:@"33333333333"] || [cpfText isEqualToString:@"44444444444"] || [cpfText isEqualToString:@"55555555555"] || [cpfText isEqualToString:@"66666666666"] || [cpfText isEqualToString:@"77777777777"] || [cpfText isEqualToString:@"88888888888"] || [cpfText isEqualToString:@"99999999999"])
        {
            return tbValidationResult_Disapproved;
        }
        //VALIDA CPF PELO DIGITO VERIFICADOR
        else
        {
            long soma = 0;
            int peso;
            long digito_verificador_10 = [[cpfText substringWithRange:NSMakeRange(9, 1)] integerValue];
            long digito_verificador_11 = [[cpfText substringWithRange:NSMakeRange(10, 1)] integerValue];
            int digito_verificador_10_correto;
            int digito_verificador_11_correto;
            
            //Verificação 10 Digito
            peso=10;
            for (int i=0; i<9; i++)
            {
                soma = soma + ( [[cpfText substringWithRange:NSMakeRange(i, 1)] integerValue] * peso );
                peso = peso-1;
            }
            
            if (soma % 11 < 2)
            {
                digito_verificador_10_correto = 0;
            }
            else
            {
                digito_verificador_10_correto = 11 - (soma % 11);
            }
            
            //Verifição 11 Digito
            soma=0;
            peso=11;
            for (int i=0; i<10; i++)
            {
                soma = soma + ( [[cpfText substringWithRange:NSMakeRange(i, 1)] integerValue] * peso );
                peso = peso-1;
            }
            
            if (soma % 11 < 2)
            {
                digito_verificador_11_correto = 0;
            }
            else
            {
                digito_verificador_11_correto = 11 - (soma % 11);
            }
            
            //Retorno
            if (digito_verificador_10_correto == digito_verificador_10 && digito_verificador_11_correto == digito_verificador_11)
            {
                return tbValidationResult_Approved;
            }
            else
            {
                return tbValidationResult_Disapproved;
            }
        }
    }
}

+ (NSDictionary*)validationHelper_NormalizeDictionaryForCDATA:(NSDictionary*)dictionary encapsulating:(bool)encapsulating
{
    if(dictionary == nil || [dictionary isKindOfClass:[NSNull class]])
    {
        return dictionary;
    }
    
    NSArray *keysList = [dictionary allKeys];
    
    for (NSString *key in keysList)
    {
        if(encapsulating)
        {
            if([[dictionary valueForKey:key] isKindOfClass:[NSString class]])
            {
                [dictionary setValue:[self addCDATA:[dictionary valueForKey:key]] forKey:key];
            }
        }
        else
        {
            if([[dictionary valueForKey:key] isKindOfClass:[NSString class]])
            {
                [dictionary setValue:[self addCDATA:[dictionary valueForKey:key]] forKey:key];
            }
        }
        
    }
    
    return dictionary;
}

+(NSString*)addCDATA:(NSString*)texto;
{
    if(texto == nil || [texto isEqualToString:@""])
    {
        return texto;
    }
    
    texto = [texto stringByReplacingOccurrencesOfString:CDATA_END withString:[NSString stringWithFormat:@"]]%@%@>",CDATA_END, CDATA_START]];
    texto = [NSString stringWithFormat:@"%@%@%@", CDATA_START,texto,CDATA_END];
    
    return texto;
}

+(BOOL)validationHelper_validateCNPJ:(NSString *)cnpj
{
    int retornoVerificarComuns = [self verificarComunsCNPJ:cnpj];
    bool retornoValidarDigitos = false;
    
    switch (retornoVerificarComuns) {
            
        case 0:
        {
            retornoValidarDigitos = [self validarDigitosCNPJ:cnpj];
        }
            break;
            
        case 1:
            retornoValidarDigitos = false;
            break;
            
        case 2:
            retornoValidarDigitos = false;
            break;
    }
    return retornoValidarDigitos;
}

+(BOOL)validarDigitosCNPJ:(NSString *)cnpj {
    
    NSInteger soma = 0;
    NSInteger peso;
    NSInteger digito_verificador_13 = [[cnpj substringWithRange:NSMakeRange(12, 1)] integerValue];
    NSInteger digito_verificador_14 = [[cnpj substringWithRange:NSMakeRange(13, 1)] integerValue];
    NSInteger digito_verificador_13_correto;
    NSInteger digito_verificador_14_correto;
    
    //Verificação 13 Digito
    peso=2;
    for (int i=11; i>=0; i--) {
        
        soma = soma + ( [[cnpj substringWithRange:NSMakeRange(i, 1)] integerValue] * peso);
        
        peso = peso+1;
        
        if (peso == 10) {
            peso = 2;
        }
    }
    
    if (soma % 11 == 0 || soma % 11 == 1) {
        digito_verificador_13_correto = 0;
    }
    else{
        digito_verificador_13_correto = 11 - soma % 11;
    }
    
    //Verificação 14 Digito
    soma=0;
    peso=2;
    for (int i=12; i>=0; i--) {
        
        soma = soma + ( [[cnpj substringWithRange:NSMakeRange(i, 1)] integerValue] * peso);
        
        peso = peso+1;
        
        if (peso == 10) {
            peso = 2;
        }
    }
    
    if (soma % 11 == 0 || soma % 11 == 1) {
        digito_verificador_14_correto = 0;
    }
    else{
        digito_verificador_14_correto = 11 - soma % 11;
    }
    
    //Retorno
    if (digito_verificador_13_correto == digito_verificador_13 && digito_verificador_14_correto == digito_verificador_14) {
        return YES;
    }
    else{
        return NO;
    }
    
}

+(int)verificarComunsCNPJ:(NSString *)cnpj {
    /*
     0 - Validado
     1 - Não possui 14 digitos
     2 - CNPJ não permitido: Sequencia de números
     */
    if ([cnpj length] != 14 || [cnpj isEqualToString:@""]) {
        return 1;
    } else if (   [cnpj isEqualToString:@"00000000000000"]
               || [cnpj isEqualToString:@"11111111111111"]
               || [cnpj isEqualToString:@"22222222222222"]
               || [cnpj isEqualToString:@"33333333333333"]
               || [cnpj isEqualToString:@"44444444444444"]
               || [cnpj isEqualToString:@"55555555555555"]
               || [cnpj isEqualToString:@"66666666666666"]
               || [cnpj isEqualToString:@"77777777777777"]
               || [cnpj isEqualToString:@"88888888888888"]
               || [cnpj isEqualToString:@"99999999999999"]){
        return 2;
    }
    else{
        return 0;
    }
}


/** Verifica digito validador do cartão de crédito **/
+ (BOOL)validationHelper_ValidateCreditCard:(NSString *)cardNumberString
{
    int checkSum = 0;
    uint8_t *cardDigitArray = (uint8_t *)[cardNumberString dataUsingEncoding:NSUTF8StringEncoding].bytes;
    int digitsCount = (int)cardNumberString.length;
    BOOL odd = cardNumberString.length % 2;
    
    for (int digitIndex=0; digitIndex<digitsCount; digitIndex++) {
        uint8_t cardDigit = cardDigitArray[digitIndex] - '0';
        if (digitIndex % 2 == odd) {
            cardDigit = cardDigit * 2;
            cardDigit = cardDigit / 10 + cardDigit % 10;
        }
        checkSum += cardDigit;
    }
    
    return (checkSum % 10 == 0);
}

#pragma mark - • TEXT HELPER

/** Aplica criptografia MD5 para um texto parâmetro.*/
+ (NSString*)textHelper_HashMD5forText:(NSString*)text
{
    if(text == nil || [text isEqualToString:@""])
    {
        return @"";
    }
    
    const char* senhaCripto = [text UTF8String];
    unsigned char resultado[CC_MD5_DIGEST_LENGTH];
    CC_MD5(senhaCripto, (int)strlen(senhaCripto), resultado);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",resultado[i]];
    }
    
    return ret;
}

/** Aplica criptografia SHA512 para um texto parâmetro.*/
+ (NSString*)textHelper_HashSHA512forText:(NSString*)text
{
    if(text == nil || [text isEqualToString:@""])
    {
        return @"";
    }
    
    //    const char *cstr = [texto UTF8String];
    //    NSData *data = [NSData dataWithBytes:cstr length:texto.length];
    //    unsigned char digest[CC_SHA512_DIGEST_LENGTH];
    //    CC_SHA512(data.bytes, data.length, digest);
    //    NSMutableString* output = [NSMutableString  stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    //
    const char *cstr = [text cStringUsingEncoding:NSUTF8StringEncoding]; // NSUTF8StringEncoding
    NSData *data = [NSData dataWithBytes:cstr length:text.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString  stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

+ (bool)textHelper_CheckRelevantContentInString:(NSString*)text
{
    if(text == nil || [text isEqualToString:@""]){
        return false;
    }
    
    NSCharacterSet *inverted1 = [[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet];
    NSRange range = [text rangeOfCharacterFromSet:inverted1];
    
    if (range.location == NSNotFound){
        
        return false;
    }else{
        
        NSCharacterSet *inverted2 = [[NSCharacterSet illegalCharacterSet] invertedSet];
        NSRange range2 = [text rangeOfCharacterFromSet:inverted2];
        
        if (range2.location == NSNotFound){
            
            return false;
            
        }else{
            return true;
        }
    }
}

+ (NSString*)textHelper_Inverter:(NSString*)text
{
    if(text == nil){
        return @"";
    }
    
    if ([text isEqualToString:@""]){
        return @"";
    }
    
    NSMutableString *mutableReverseString = [[NSMutableString alloc] initWithCapacity:text.length];
    
    NSInteger i = text.length;
    while (i > 0) {
        NSRange range = [text rangeOfComposedCharacterSequenceAtIndex:i-1];
        NSString *characterString = [text substringWithRange:range];
        [mutableReverseString appendString:characterString];
        i = range.location;
    }
    
    NSString *outputString = [mutableReverseString copy];
    return outputString;
}

+ (bool)textHelper_CheckOccurrencesOfChar:(char)character inText:(NSString*)text usingOptions:(NSStringCompareOptions)options
{
    if (text == nil || [text isEqualToString:@""]){
        return false;
    }
    
    NSRange range = [text rangeOfString:[NSString stringWithFormat:@"%c",character] options:options];
    if (range.location != NSNotFound)
    {
        return true;
    }
    
    return false;
}

+(NSString*)textHelper_UpdateMaskToText:(NSString*)text usingMask:(NSString*)mask
{
    if (text != nil){
        if (mask != nil){
            
            NSString *clearText = [ToolBox textHelper_RemoveMaskToText:text usingCharacters:TOOLBOX_TEXT_MASK_DEFAULT_CHARS_SET];
            NSString *newText = [ToolBox textHelper_ApplyMaskToText:clearText usingMask:mask];
            return newText;
            
        }else{
            return text;
        }
    }else{
        return nil;
    }
}

+(NSString*)textHelper_ApplyMaskToText:(NSString*)text usingMask:(NSString*)mask
{
    NSUInteger onOriginal = 0, onFilter = 0, onOutput = 0;
    char outputString[([mask length])];
    BOOL done = NO;
    
    while(onFilter < [mask length] && !done)
    {
        char filterChar = [mask characterAtIndex:onFilter];
        char originalChar = onOriginal >= text.length ? '\0' : [text characterAtIndex:onOriginal];
        switch (filterChar) {
            case '#':
            {
                if(originalChar=='\0')
                {
                    // We have no more input numbers for the filter.  We're done.
                    done = YES;
                    break;
                }
                if(isdigit(originalChar))
                {
                    outputString[onOutput] = originalChar;
                    onOriginal++;
                    onFilter++;
                    onOutput++;
                }
                else
                {
                    onOriginal++;
                }
            }break;
            default:
            {
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput++;
                onFilter++;
                if(originalChar == filterChar)
                    onOriginal++;
            }break;
        }
    }
    outputString[onOutput] = '\0'; // Cap the output string
    NSString *result = [NSString stringWithUTF8String:outputString];
    return result;
}

+(NSString*)textHelper_RemoveMaskToText:(NSString*)text usingCharacters:(NSString*)charactersString
{
    if (text != nil && charactersString != nil){
        NSString *resultString = [NSString stringWithFormat:@"%@", text];
        //
        for (int i = 0; i < [charactersString length]; i++) {
            NSString *ch = [charactersString substringWithRange:NSMakeRange(i, 1)];
            resultString = [resultString stringByReplacingOccurrencesOfString:ch withString:@""];
        }
        //
        return resultString;
    }else{
        return text;
    }
}

#pragma mark - • GRAPHIC HELPER

+ (UIColor*)graphicHelper_colorWithHexString:(NSString*)string
{
    NSString *colorString = [[string stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", string];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (NSString*)graphicHelper_hexStringFromUIColor:(UIColor*)uiColor
{
    if (uiColor){
        const CGFloat *components = CGColorGetComponents(uiColor.CGColor);
        
        CGFloat r = components[0];
        CGFloat g = components[1];
        CGFloat b = components[2];
        NSString *color = [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
        //
        return color;
    }
    
    return @"";
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (UIImage*)graphicHelper_NormalizeImageOrientationToUp:(UIImage*)imageIn
{
    if (imageIn.CGImage != nil){
        
        //int kMaxResolution = 1500; // Or whatever
        
        CGImageRef        imgRef    = imageIn.CGImage;
        //CGFloat           width     = CGImageGetWidth(imgRef);
        //CGFloat           height    = CGImageGetHeight(imgRef);
        CGAffineTransform transform = CGAffineTransformIdentity;
        CGRect            bounds    = CGRectMake( 0, 0, CGImageGetWidth(imgRef), CGImageGetHeight(imgRef) );
        
        /*
         if ( width > kMaxResolution || height > kMaxResolution )
         {
         CGFloat ratio = width/height;
         
         if (ratio > 1)
         {
         bounds.size.width  = kMaxResolution;
         bounds.size.height = bounds.size.width / ratio;
         }
         else
         {
         bounds.size.height = kMaxResolution;
         bounds.size.width  = bounds.size.height * ratio;
         }
         }
         */
        
        CGFloat            scaleRatio   = bounds.size.width / bounds.size.height;
        CGSize             imageSize    = CGSizeMake( CGImageGetWidth(imgRef), CGImageGetHeight(imgRef) );
        UIImageOrientation orient       = imageIn.imageOrientation;
        CGFloat            boundHeight;
        
        switch(orient)
        {
            case UIImageOrientationUp:                                        //EXIF = 1
                transform = CGAffineTransformIdentity;
                break;
                
            case UIImageOrientationUpMirrored:                                //EXIF = 2
                transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
                transform = CGAffineTransformScale(transform, -1.0, 1.0);
                break;
                
            case UIImageOrientationDown:                                      //EXIF = 3
                transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
                transform = CGAffineTransformRotate(transform, M_PI);
                break;
                
            case UIImageOrientationDownMirrored:                              //EXIF = 4
                transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
                transform = CGAffineTransformScale(transform, 1.0, -1.0);
                break;
                
            case UIImageOrientationLeftMirrored:                              //EXIF = 5
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
                transform = CGAffineTransformScale(transform, -1.0, 1.0);
                transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
                break;
                
            case UIImageOrientationLeft:                                      //EXIF = 6
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
                transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
                break;
                
            case UIImageOrientationRightMirrored:                             //EXIF = 7
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransformMakeScale(-1.0, 1.0);
                transform = CGAffineTransformRotate(transform, M_PI / 2.0);
                break;
                
            case UIImageOrientationRight:                                     //EXIF = 8
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
                transform = CGAffineTransformRotate(transform, M_PI / 2.0);
                break;
                
            default:
                [NSException raise: NSInternalInconsistencyException
                            format: @"Invalid image orientation"];
                
        }
        
        UIGraphicsBeginImageContext( bounds.size );
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if ( orient == UIImageOrientationRight || orient == UIImageOrientationLeft )
        {
            CGContextScaleCTM(context, -scaleRatio, scaleRatio);
            CGContextTranslateCTM(context, - CGImageGetHeight(imgRef), 0);
        }
        else
        {
            CGContextScaleCTM(context, scaleRatio, -scaleRatio);
            CGContextTranslateCTM(context, 0, - CGImageGetHeight(imgRef));
        }
        
        CGContextConcatCTM( context, transform );
        
        CGContextDrawImage( UIGraphicsGetCurrentContext(), CGRectMake( 0, 0, CGImageGetWidth(imgRef), CGImageGetHeight(imgRef) ), imgRef );
        UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return( imageCopy );
        
    }else{
        return nil;
    }
}

+ (UIImage*)graphicHelper_NormalizeImage:(UIImage*)image maximumDimension:(int)maxDimension quality:(float)quality;
{
    //Condições adversas:
    if(image == nil || maxDimension == 0)
    {
        return nil;
    }
    
    //Convertendo outros formatos para JPEG
    quality = (quality < 0 ? 0 : (quality > 1 ? 1 : quality));
    NSData *iData = UIImageJPEGRepresentation(image, quality);
    UIImage *imageR = [UIImage imageWithData:iData];
    
    //Desnecessário prosseguir:
    if(MAX((int)imageR.size.width, (int)imageR.size.height) <= maxDimension)
    {
        return imageR;
    }
    
    //Precisa redimensionar:
    
    //Tamanhos:
    float largura = imageR.size.width;
    float altura = imageR.size.height;
    float novaLargura = 0;
    float novaAltura = 0;
    
    maxDimension = abs(maxDimension);
    
    //Imagem de retorno:
    UIImage *newImage;
    
    float aspectRatio = largura / altura;
    
    if(largura > altura){
        novaLargura = (float)maxDimension;
        novaAltura = novaLargura / aspectRatio;
    }
    else{
        novaAltura = (float)maxDimension;
        novaLargura = novaAltura * aspectRatio;
    }
    
    @try{
        //Desenhando efetivamente
        CGRect rect = CGRectMake(0.0, 0.0, novaLargura, novaAltura);
        UIGraphicsBeginImageContext(rect.size);
        [image drawInRect:rect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    @catch (NSException *exception){
        //Exceção manual do Google Analytics:
        NSLog(@"Erro ao otimizar imagem: %@", [exception reason]);
    }
    @finally
    {
        return newImage;
    }
}

+ (NSString *) graphicHelper_EncodeToBase64String:(UIImage *)image
{
    if (image != nil){
        return [UIImageJPEGRepresentation(image, 1.0) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    else{
        return nil;
    }
}

+ (UIImage *) graphicHelper_DecodeBase64ToImage:(NSString *)strEncodeData
{
    if (strEncodeData != nil && ![strEncodeData isEqualToString:@""]){
        NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
        return [UIImage imageWithData:data];
    }else{
        return nil;
    }
}

+ (UIImage *) graphicHelper_ImageWithTintColor:(UIColor*)color andImageTemplate:(UIImage*)image
{
    if (color == nil || image == nil){
        return nil;
    }else{
        UIImage *newImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIGraphicsBeginImageContextWithOptions(image.size, NO, newImage.scale);
        [color set];
        [newImage drawInRect:CGRectMake(0, 0, image.size.width, newImage.size.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //
        return newImage;
    }
}

+ (UIImage*) graphicHelper_Snapshot_Layer:(CALayer*)layer
{
    if (layer != nil){
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.opaque, [UIScreen mainScreen].scale);
        //renderiza a view parâmetro no contexto
        [layer renderInContext:UIGraphicsGetCurrentContext()];
        //captura a imagem resultante
        UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
        //finaliza o contexto
        UIGraphicsEndImageContext();
        
        return image;
    }
    return nil;
}

+ (UIImage*) graphicHelper_Snapshot_View:(UIView*)view
{
    if (view != nil){
        return [self graphicHelper_Snapshot_Layer:view.layer];
    }
    
    return nil;
}

+ (UIImage*) graphicHelper_Snapshot_ViewController:(UIViewController*)viewController
{
    if (viewController != nil){
        return [self graphicHelper_Snapshot_Layer:viewController.view.layer];
    }
    
    return nil;
}

+ (UIImage*)graphicHelper_ApplyBlurEffectInImage:(UIImage*)image withRadius:(CGFloat)radius
{
    if (image != nil){
        return [self applyBlurInImage:image withRadius:radius tintColor:nil saturationDeltaFactor:1 maskImage:nil];
    }
    
    return nil;
}

/** Adiciona o efeito BLUR em uma imagem referência.*/
+ (UIImage*) graphicHelper_ApplyGrayScaleEffectInImage:(UIImage*)image withType:(enumGrayScaleEffect)type
{
    if (image.CGImage == nil){
        return nil;
    }else{
        
        UIImageOrientation orientation = image.imageOrientation;
        CIImage* ciImage = [CIImage imageWithCGImage:image.CGImage];
        CIContext *context = [CIContext contextWithOptions:nil];
        //
        NSString *strFilterName;
        switch (type) {
            case tbGrayScaleEffect_Noir:{strFilterName = @"CIPhotoEffectNoir";}break;
            case tbGrayScaleEffect_Mono:{strFilterName = @"CIPhotoEffectMono";}break;
            case tbGrayScaleEffect_Tonal:{strFilterName = @"CIPhotoEffectTonal";}break;
            default:{strFilterName = @"CIPhotoEffectMono";}break;
        }
        CIFilter *ciFilter = [CIFilter filterWithName:strFilterName];
        [ciFilter setValue:ciImage forKey:kCIInputImageKey];
        //
        CIImage *outputImage = [ciFilter outputImage];
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *newImage = [UIImage imageWithCGImage:cgimg scale:1.0 orientation:orientation];
        CGImageRelease(cgimg);
        context = nil;
        return newImage;
    }
}

+ (UIImage*) graphicHelper_ApplyDistortionEffectInImage:(UIImage*)image
{
    if (image == nil){
        return nil;
    }else{
        // Create CIFilter object
        CIImage *ciImage = [[CIImage alloc] initWithImage:image];
        
        NSDictionary *params = @{
                                 kCIInputImageKey: ciImage,
                                 };
        
        CIFilter *filter = [CIFilter filterWithName:@"CIGlassDistortion" withInputParameters:params];
        [filter setDefaults];
        
        // param for distortion
        if ([filter respondsToSelector:NSSelectorFromString(@"inputTexture")]) {
            CIImage *ciTextureImage = [[CIImage alloc] initWithImage:image];
            [filter setValue:ciTextureImage forKey:@"inputTexture"];
        }
        
        // Apply filter
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *outputImage = [filter outputImage];
        CGImageRef cgImage = [context createCGImage:outputImage
                                           fromRect:[outputImage extent]];
        UIImage *imageResult = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
        return imageResult;
    }
}

+ (void) graphicHelper_ApplyRotationEffectInView:(UIView*)view withDuration:(CFTimeInterval)time repeatCount:(float)count
{
    if (view){
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        animation.fromValue = [NSNumber numberWithFloat:0];
        animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
        animation.duration = time;
        animation.repeatCount = count == 0 ? HUGE_VALF : count;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [view.layer addAnimation:animation forKey:@"transform.rotation.y"];
    }
}

+ (void) graphicHelper_ApplyParallaxEffectInView:(UIView*)view with:(CGFloat)deep
{
    if (view){
        UIInterpolatingMotionEffect *effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        UIInterpolatingMotionEffect *effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        //
        effectX.maximumRelativeValue = @(deep);
        effectX.minimumRelativeValue = @(-deep);
        effectY.maximumRelativeValue = @(deep);
        effectY.minimumRelativeValue = @(-deep);
        //
        [view addMotionEffect:effectX];
        [view addMotionEffect:effectY];
    }
}

+ (void) graphicHelper_RemoveParallaxEffectInView:(UIView*)view
{
    if (view){
        NSArray *listaParallax = [[NSArray alloc]initWithArray:[view motionEffects]];
        for(UIMotionEffect *me in listaParallax)
        {
            [view removeMotionEffect:me];
        }
    }
}

+ (void) graphicHelper_ApplyRippleEffectAnimationInView:(UIView*)view withColor:(UIColor*)color andRadius:(CGFloat)radius
{
    if (view){
        double m = (radius == 0.0 ? MIN(view.bounds.size.height, view.bounds.size.width) : radius);
        
        CGFloat dif = 0.0;
        CGRect pathFrame;
        
        if (view.bounds.size.height > view.bounds.size.width){
            dif = view.bounds.size.height - view.bounds.size.width; //Y adjust
            pathFrame = CGRectMake(-CGRectGetMidX(view.bounds), -CGRectGetMidY(view.bounds) + (dif/2), m, m);
        }else{
            dif = view.bounds.size.width - view.bounds.size.height; //X adjust
            pathFrame = CGRectMake(-CGRectGetMidX(view.bounds) + (dif/2), -CGRectGetMidY(view.bounds), m, m);
        }
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:m/2];
        CGPoint shapePosition = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
        
        CAShapeLayer *circleShape = [CAShapeLayer layer];
        circleShape.path = path.CGPath;
        circleShape.position = shapePosition;
        circleShape.fillColor = color.CGColor;
        circleShape.opacity = 0;
        
        [view.layer addSublayer:circleShape];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 1)];
        
        CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alphaAnimation.fromValue = @1;
        alphaAnimation.toValue = @0;
        
        CAAnimationGroup *animation = [CAAnimationGroup animation];
        animation.animations = @[scaleAnimation, alphaAnimation];
        animation.duration = 1.0f;
        animation.repeatCount = 0;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [circleShape addAnimation:animation forKey:nil];
    }
}

+ (void) graphicHelper_ApplyRippleEffectAnimationForBoundsInView:(UIView*)view withColor:(UIColor*)color sizeScale:(CGFloat)scale andDuration:(float)duration
{
    if (view){
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.frame];
        CGPoint shapePosition = CGPointZero;
        
        CAShapeLayer *circleShape = [CAShapeLayer layer];
        circleShape.path = path.CGPath;
        circleShape.position = shapePosition;
        circleShape.fillColor = color.CGColor;
        circleShape.opacity = 0;
        
        [view.layer addSublayer:circleShape];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
        
        CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alphaAnimation.fromValue = @1;
        alphaAnimation.toValue = @0;
        
        CAAnimationGroup *animation = [CAAnimationGroup animation];
        animation.animations = @[scaleAnimation, alphaAnimation];
        animation.duration = duration;
        animation.repeatCount = 0;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [circleShape addAnimation:animation forKey:nil];
    }
}

+ (void) graphicHelper_ApplyHeartBeatAnimationInView:(UIView*)view withScale:(CGFloat)scale
{
    NSMutableArray *animations = [NSMutableArray array];
    // Step 1
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.toValue = @(scale);
        animation.duration = 0.3;
        animation.fillMode = kCAFillModeForwards;
        [animations addObject:animation];
    }
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.toValue = @(1.0);
        animation.duration = 0.3;
        animation.fillMode = kCAFillModeForwards;
        [animations addObject:animation];
    }
    // Step 2
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.toValue = @(1);
        animation.beginTime = 0.3;
        animation.duration = 0.1;
        animation.fillMode = kCAFillModeForwards;
        [animations addObject:animation];
    }
    // Step 3
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.toValue = @(scale);
        animation.beginTime = 0.4;
        animation.duration = 0.3;
        animation.fillMode = kCAFillModeForwards;
        [animations addObject:animation];
    }
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.toValue = @(0);
        animation.beginTime = 0.4;
        animation.duration = 0.3;
        animation.fillMode = kCAFillModeForwards;
        [animations addObject:animation];
    }
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = animations;
    animationGroup.duration = 0.7;
    animationGroup.fillMode = kCAFillModeBoth;
    animationGroup.removedOnCompletion = NO;
    
    [view.layer addAnimation:animationGroup forKey:nil];
}

+ (void) graphicHelper_ApplyScaleBeatAnimationInView:(UIView*)view withScale:(CGFloat)scale repeatCount:(float)repeatCount
{
    //[view.layer removeAllAnimations];
    
    NSMutableArray *animations = [NSMutableArray array];
    //
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.fromValue = @(1.0);
        animation.toValue = @(scale);
        animation.duration = 0.5;
        animation.fillMode = kCAFillModeForwards;
        [animations addObject:animation];
    }
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = @(1.0);
        animation.toValue = @(0.0);
        animation.duration = 0.5;
        animation.fillMode = kCAFillModeForwards;
        [animations addObject:animation];
    }
    //
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = animations;
    animationGroup.duration = 1.0;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    animationGroup.repeatCount = repeatCount;
    
    [view.layer addAnimation:animationGroup forKey:nil];
}

+ (UIImage*) graphicHelper_ApplyBorderToImage:(UIImage*)image withColor:(UIColor*)borderColor andWidth:(float)borderWidth
{
    if (image){
        
        CGSize size = [image size];
        UIGraphicsBeginImageContext(size);
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        [image drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
        CGContextRef context = UIGraphicsGetCurrentContext();
        //
        CGFloat red, green, blue, alpha;
        [borderColor getRed:&red green:&green blue:&blue alpha:&alpha];
        CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
        //
        CGContextSetLineWidth(context, borderWidth);
        //
        CGContextStrokeRect(context, rect);
        UIImage *resultImage =  UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultImage;
        
    }
    
    return nil;
}

+ (UIImage*) graphicHelper_CreateFlatImageWithSize:(CGSize)size byRoundingCorners:(UIRectCorner)corners cornerRadius:(CGSize)radius andColor:(UIColor*)color
{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:corners cornerRadii:radius];
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    [rounded fill]; //or [path stroke]
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void) graphicHelper_ApplyShadowToView:(UIView*)view withColor:(UIColor*)color offSet:(CGSize)offSet radius:(CGFloat)radius opacity:(CGFloat)opacity
{
    view.layer.shadowColor = color.CGColor;
    view.layer.shadowOffset = offSet;
    view.layer.shadowRadius = radius;
    view.layer.shadowOpacity = opacity;
    view.layer.shouldRasterize = YES;
    [[view layer] setRasterizationScale:[[UIScreen mainScreen] scale]];
}

+ (void) graphicHelper_RemoveShadowFromView:(UIView*)view
{
    view.layer.shadowColor = [UIColor clearColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowRadius = 0.0;
    view.layer.shadowOpacity = 0.0;
}

+ (UIImage*) graphicHelper_CircularScaleAndCropImage:(UIImage*)image frame:(CGRect)frame
{
    if (image){
        // This function returns a newImage, based on image, that has been:
        // - scaled to fit in (CGRect) rect
        // - and cropped within a circle of radius: rectWidth/2
        
        //Create the bitmap graphics context
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //Get the width and heights
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        CGFloat rectWidth = frame.size.width;
        CGFloat rectHeight = frame.size.height;
        
        //Calculate the scale factor
        CGFloat scaleFactorX = rectWidth/imageWidth;
        CGFloat scaleFactorY = rectHeight/imageHeight;
        
        //Calculate the centre of the circle
        CGFloat imageCentreX = rectWidth/2;
        CGFloat imageCentreY = rectHeight/2;
        
        // Create and CLIP to a CIRCULAR Path
        // (This could be replaced with any closed path if you want a different shaped clip)
        CGFloat radius = rectWidth/2;
        CGContextBeginPath (context);
        CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
        CGContextClosePath (context);
        CGContextClip (context);
        
        //Set the SCALE factor for the graphics context
        //All future draw calls will be scaled by this factor
        CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
        
        // Draw the IMAGE
        CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
        [image drawInRect:myRect];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    return nil;
}


+ (UIImage*) graphicHelper_CropImage:(UIImage*)image usingFrame:(CGRect)frame
{
    if (image != nil && frame.size.height > 0 && frame.size.width > 0){
        
        CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, frame);
        UIImage* outImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
        CGImageRelease(imageRef);
        //
        return outImage;
    }
    
    return nil;
}

+ (UIImage*) graphicHelper_MaskImage:(UIImage *)image withMask:(UIImage *)mask
{
    if (image != nil && mask != nil){
        
        CGImageRef imageReference = image.CGImage;
        CGImageRef maskReference = mask.CGImage;
        
        CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                                 CGImageGetHeight(maskReference),
                                                 CGImageGetBitsPerComponent(maskReference),
                                                 CGImageGetBitsPerPixel(maskReference),
                                                 CGImageGetBytesPerRow(maskReference),
                                                 CGImageGetDataProvider(maskReference),
                                                 NULL, // Decode is null
                                                 YES // Should interpolate
                                                 );
        
        CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
        CGImageRelease(imageMask);
        
        UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
        CGImageRelease(maskedReference);
        
        return maskedImage;
    }
    
    return nil;
}

+ (UIImage*) graphicHelper_MergeImage:(UIImage*)bottomImage withImage:(UIImage*)topImage position:(CGPoint)position blendMode:(CGBlendMode)blendMode alpha:(float)alpha scale:(float)superImageScale;
{
    if (bottomImage != nil && topImage != nil){
        
        CGFloat widthB = bottomImage.size.width;
        CGFloat heightB = bottomImage.size.height;
        CGSize baseSize = CGSizeMake(widthB, heightB);
        NSLog(@"BASE_IMAGE_SIZE >> width: %.1f | height: %.1f", widthB, heightB);
        //
        CGFloat widthS = topImage.size.width * superImageScale;
        CGFloat heightS = topImage.size.height * superImageScale;
        CGSize superSize = CGSizeMake(widthS, heightS);
        NSLog(@"SUPER_IMAGE_SIZE_ORIGINAL >> width: %.1f | height: %.1f", topImage.size.width, topImage.size.height);
        NSLog(@"SUPER_IMAGE_SIZE_SCALE >> width: %.1f | height: %.1f", widthS, heightS);
        
        UIGraphicsBeginImageContext(baseSize);
        
        //Desenhando a imagem base:
        [bottomImage drawInRect:CGRectMake(0, 0, baseSize.width, baseSize.height)];
        
        //Desenhando a imagem superior:
        [topImage drawInRect:CGRectMake(position.x, position.y, superSize.width, superSize.height) blendMode:blendMode alpha:alpha];
        
        //Obtendo a imagem final:
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    return nil;
}

+ (UIImage*) graphicHelper_ResizeImage:(UIImage*)image toSize:(CGSize)newSize
{
    if (image != nil){
        
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //
        return newImage;
    }
    
    return nil;
}

+ (UIImage*) graphicHelper_ResizeImage:(UIImage*)image usingScale:(CGFloat)scale
{
    if (image != nil && scale > 0.0){
        
        CGSize newSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //
        return newImage;
    }
    
    return nil;
}

+ (UIImage*) graphicHelper_ResizeImage:(UIImage*)image forCGRectSize:(CGSize)rectSize;
{
    if (image != nil){
        
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        CGFloat ratio = width / height;
        //
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGFloat maxWidth = rectSize.width * scale;
        CGFloat maxHeight = rectSize.height * scale;
        //
        if (width > maxWidth){
            width = maxWidth;
            height = width / ratio;
        }else if(height > maxHeight){
            height = maxHeight;
            width = height * ratio;
        }
        //
        CGSize newSize = CGSizeMake(width, height);
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //
        return newImage;
    }
    return nil;
}

+ (UIImage*) graphicHelper_CompressImage:(UIImage*)image usingQuality:(CGFloat)quality
{
    if (image != nil){
        CGFloat q = (quality < 0.0) ? 0.0 : ((quality > 1.0 ? 1.0 : quality));
        NSData *iData = UIImageJPEGRepresentation(image, q);
        UIImage *image = [UIImage imageWithData:iData];
        //
        return image;
    }
    
    return nil;
}

//                        CIFilter *f = [CIFilter filterWithName:@"CIDiscBlur"];
//                        //[f setDefaults];
//                        [f setValue:[CIImage imageWithCGImage:imageView.image.CGImage] forKey:kCIInputImageKey];
//                        [f setValue:@5 forKey:kCIInputRadiusKey];
//                        imageView.image = [UIImage imageWithCIImage:(f.outputImage) scale:1.0 orientation:UIImageOrientationUp];

+ (UIImage *)applyBlurInImage:(UIImage*)image withRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (image.size.width < 1 || image.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", image.size.width, image.size.height, self);
        return nil;
    }
    if (!image.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, image.size };
    UIImage *effectImage = image;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -image.size.height);
        CGContextDrawImage(effectInContext, imageRect, image.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
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
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            uint32_t radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -image.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, image.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

+ (UIImage*) graphicHelper_CopyImage:(UIImage*)image usingQuality:(CGFloat)quality
{
    if(image == nil){
        return nil;
    }else{
        
        if (quality >= 1.0){
            return [UIImage imageWithData:UIImagePNGRepresentation(image)];
        }else{
            return [UIImage imageWithData:UIImageJPEGRepresentation(image, quality < 0.0 ? 0.0 : quality)];
        }
    }
}


+ (UIImage*) graphicHelper_ApplyFilter:(NSString*)filterName inImage:(UIImage*)image usingParameters:(NSDictionary*)parameters andScale:(float)scale
{
    if (image.CGImage == nil){
        return nil;
    }else{
        
        UIImageOrientation orientation = image.imageOrientation;
        CIImage* ciImage = [CIImage imageWithCGImage:image.CGImage];
        CIContext *context = [CIContext contextWithOptions:nil];
        //
        CIFilter *ciFilter = [CIFilter filterWithName:filterName];
        [ciFilter setValue:ciImage forKey:kCIInputImageKey];
        //
        if(parameters){
            [ciFilter setValuesForKeysWithDictionary:parameters];
        }
        //
        CIImage *outputImage = [ciFilter outputImage];
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *newImage = [UIImage imageWithCGImage:cgimg scale:scale orientation:orientation];
        CGImageRelease(cgimg);
        context = nil;
        return newImage;
    }
}

#pragma mark - • CONVERTER HELPER

+ (NSString*)converterHelper_StringJsonFromDictionary:(NSDictionary*)dictionary
{
    if(dictionary == nil)
    {
        return @"";
    }
    
    NSError *error;
    //NSJSONReadingMutableContainers
    //NSJSONReadingMutableLeaves
    //NSJSONReadingAllowFragments
    //NSJSONWritingPrettyPrinted
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    
    if (! jsonData)
    {
        return @"{}";
    }
    else
    {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+ (NSDictionary*)converterHelper_DictionaryFromStringJson:(NSString*)string
{
    if(string == nil || [string isEqualToString:@""])
    {
        return nil;
    }
    
    NSError *jsonError;
    NSData *objectData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
    
    if(jsonError == nil)
    {
        return json;
    }
    
    return nil;
}

+ (NSDictionary*)converterHelper_NewDictionaryRemovingNullValuesFromDictionary:(NSDictionary*)oldDictionary withString:(NSString*)newString
{
    if (oldDictionary != nil){
        NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:oldDictionary];
        
        for (NSString *key in [replaced allKeys]) {
            id object = [replaced objectForKey:key];
            if ([object isKindOfClass:[NSString class]]){
                if ([self isNullString:object]){
                    [replaced setObject:newString forKey:key];
                }
            }else if ([object isKindOfClass:[NSNull class]]){
                [replaced setObject:newString forKey:key];
            }
        }
        return [NSDictionary dictionaryWithDictionary:replaced];
    }else{
        return nil;
    }
}

+ (NSDictionary*)converterHelper_NewDictionaryReplacingPlusSymbolFromDictionary:(NSDictionary*)refDictionary
{
    if (refDictionary != nil){
        NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:refDictionary];
        NSString *dicString = [self converterHelper_StringJsonFromDictionary:replaced];
        dicString = [dicString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //
        NSDictionary *resultDic = [self converterHelper_DictionaryFromStringJson:dicString];
        return resultDic;
        
    }else{
        return nil;
    }
}

+ (NSURL*)converterHelper_NormalizedURLForString:(NSString*)string
{
    NSString *urlString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return [NSURL URLWithString:urlString];
}

+ (NSString*)converterHelper_PlainStringFromHTMLString:(NSString *)htmlString
{
    NSAttributedString *aString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    return aString.string;
}

+ (NSString*) converterHelper_MonetaryStringForValue:(double)value
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    return [formatter stringFromNumber:@(value)];
}

+ (CGFloat)converterHelper_DegreeToRadian:(CGFloat)degree
{
    return degree * M_PI / 180;
}

+ (CGFloat)converterHelper_RadianToDegree:(CGFloat)radius
{
    return radius * 180 / M_PI;
}

+ (CGFloat)converterHelper_CelsiusToFahenheit:(CGFloat)celsius
{
    return (celsius-32)/1.8;
}

+ (CGFloat)converterHelper_FahenheitToCelsius:(CGFloat)fahenheit
{
    return (fahenheit*1.8)+32;
}

+ (double)converterHelper_DecimalValueFromText:(NSString*)text
{
    NSString *tempVE = [NSString stringWithFormat:@"%@",text];
    tempVE = [tempVE stringByReplacingOccurrencesOfString:@"." withString:@""];
    tempVE = [tempVE stringByReplacingOccurrencesOfString:@" " withString:@""];
    tempVE = [tempVE stringByReplacingOccurrencesOfString:@"," withString:@"."];
    tempVE = [tempVE stringByReplacingOccurrencesOfString:TOOLBOX_SYMBOL_DEFAULT_MONETARY withString:@""];
    tempVE = [tempVE stringByReplacingOccurrencesOfString:TOOLBOX_SYMBOL_DEFAULT_VOLUME_LIQUID withString:@""];
    tempVE = [tempVE stringByReplacingOccurrencesOfString:TOOLBOX_SYMBOL_DEFAULT_VOLUME_SOLID withString:@""];
    tempVE = [tempVE stringByReplacingOccurrencesOfString:TOOLBOX_SYMBOL_DEFAULT_DISTANCE withString:@""];
    //
    NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:tempVE];
    return [value doubleValue];
}

+ (NSString*)converterHelper_StringFromValue:(double)value monetaryFormat:(bool)monetary decimalPrecision:(int)precision
{
    NSString *texto;
    NSNumber *v = [[NSNumber alloc] initWithDouble:value];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSLocale *theLocale = [[NSLocale alloc]initWithLocaleIdentifier:@"pt_BR"];
    [formatter setLocale:theLocale];
    //
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfDown];
    [formatter setDecimalSeparator:@","];
    [formatter setGroupingSeparator:@"."];
    [formatter setMaximumFractionDigits:precision];
    [formatter setMinimumFractionDigits:precision];
    [formatter setMinimumIntegerDigits:1];
    texto = [formatter stringFromNumber:v];
    //
    if(monetary)
    {
        return [NSString stringWithFormat:@"%@ %@", TOOLBOX_SYMBOL_DEFAULT_MONETARY, texto];
    }
    else
    {
        return [NSString stringWithFormat:@"%@", texto];
    }
}

#pragma mark - • DATA HELPER

//TODO:
+ (NSData*)dataHelper_GZipData:(NSData*)data withCompressionLevel:(float)level
{
    if (data.length == 0 || [self dataHelper_GZipCheckForData:data])
    {
        return data;
    }
    
    void *libz = libzOpen();
    int (*deflateInit2_)(z_streamp, int, int, int, int, int, const char *, int) =
    (int (*)(z_streamp, int, int, int, int, int, const char *, int))dlsym(libz, "deflateInit2_");
    int (*deflate)(z_streamp, int) = (int (*)(z_streamp, int))dlsym(libz, "deflate");
    int (*deflateEnd)(z_streamp) = (int (*)(z_streamp))dlsym(libz, "deflateEnd");
    
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = (uint)data.length;
    stream.next_in = (Bytef *)(void *)data.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;
    
    static const NSUInteger ChunkSize = 16384;
    
    NSMutableData *output = nil;
    int compression = (level < 0.0f)? Z_DEFAULT_COMPRESSION: (int)(roundf(level * 9));
    if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK)
    {
        output = [NSMutableData dataWithLength:ChunkSize];
        while (stream.avail_out == 0)
        {
            if (stream.total_out >= output.length)
            {
                output.length += ChunkSize;
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            deflate(&stream, Z_FINISH);
        }
        deflateEnd(&stream);
        output.length = stream.total_out;
    }
    
    return output;
}

+ (NSData*)dataHelper_GUnzipDataFromData:(NSData*)data
{
    if (data.length == 0 || ![self dataHelper_GZipCheckForData:data])
    {
        return data;
    }
    
    void *libz = libzOpen();
    int (*inflateInit2_)(z_streamp, int, const char *, int) =
    (int (*)(z_streamp, int, const char *, int))dlsym(libz, "inflateInit2_");
    int (*inflate)(z_streamp, int) = (int (*)(z_streamp, int))dlsym(libz, "inflate");
    int (*inflateEnd)(z_streamp) = (int (*)(z_streamp))dlsym(libz, "inflateEnd");
    
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.avail_in = (uint)data.length;
    stream.next_in = (Bytef *)data.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;
    
    NSMutableData *output = nil;
    if (inflateInit2(&stream, 47) == Z_OK)
    {
        int status = Z_OK;
        output = [NSMutableData dataWithCapacity:data.length * 2];
        while (status == Z_OK)
        {
            if (stream.total_out >= output.length)
            {
                output.length += data.length / 2;
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            status = inflate (&stream, Z_SYNC_FLUSH);
        }
        if (inflateEnd(&stream) == Z_OK)
        {
            if (status == Z_STREAM_END)
            {
                output.length = stream.total_out;
            }
        }
    }
    
    return output;
}

+ (bool)dataHelper_GZipCheckForData:(NSData*)data
{
    const UInt8 *bytes = (const UInt8 *)data.bytes;
    return (data.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b);
}

+ (void)dataHelper_SortArray:(NSArray*)objectsArray usingKey:(NSString*)objectParameterKey ascendingOrder:(BOOL)ascending
{
    if (objectsArray != nil && objectParameterKey != nil){
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:objectParameterKey ascending:ascending];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
        objectsArray = [[NSMutableArray alloc] initWithArray:[objectsArray sortedArrayUsingDescriptors:sortDescriptors]];
    }
}

+ (NSDictionary*)dataHelper_DictionaryFromObject:(id)object
{
    if (object == nil){
        return nil;
    }else{
        
        //Carregando a lista de nomes das propriedades do objeto.
        unsigned count;
        objc_property_t *properties = class_copyPropertyList([object class], &count);
        
        NSMutableArray *runtimeVariables = [NSMutableArray array];
        
        unsigned i;
        for (i = 0; i < count; i++)
        {
            objc_property_t property = properties[i];
            NSString *name = [NSString stringWithUTF8String:property_getName(property)];
            [runtimeVariables addObject:name];
        }
        
        free(properties);
        
        //Através da lista, buscamos os valores das propriedades para o dicionário;
        NSMutableDictionary *resultDic = [NSMutableDictionary new];
        
        @try {
            for (NSString *key in runtimeVariables){
                [resultDic setValue:[object valueForKey:key] forKey:key];
            }
        } @catch (NSException *exception) {
            NSLog(@"Erro ao criar dicionário: %@", exception.reason);
            resultDic = nil;
        } @finally {
            return resultDic;
        }
    }
}

#pragma mark - • AUX METHODS

+ (bool)isNullString:(NSString*)valueString
{
    if (valueString == nil){
        return true;
    }else if ([valueString isEqualToString:@"null"] || [valueString isEqualToString:@"<null>"] || [valueString isEqualToString:@"(null)"]){
        return true;
    }
    return false;
}

static void *libzOpen()
{
    static void *libz;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        libz = dlopen("/usr/lib/libz.dylib", RTLD_LAZY);
    });
    return libz;
}

@end
