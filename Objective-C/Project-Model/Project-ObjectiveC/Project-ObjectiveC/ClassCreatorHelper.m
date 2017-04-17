//
//  ClassCreatorHelper.m
//  AHK-100anos
//
//  Created by Erico GT on 10/31/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "ClassCreatorHelper.h"

@interface ClassCreatorHelper()

@property(nonatomic, strong) NSString *_className;
@property(nonatomic, strong) NSString *_reference;
@property(nonatomic, assign) bool _useNil;
@property(nonatomic, strong) NSMutableDictionary *_propertiesDictionary;
@property(nonatomic, strong) NSMutableDictionary *_dicNamesDictionary;
@property(nonatomic, strong) NSString *_author;
@property(nonatomic, strong) NSString *_enterprise;
@property(nonatomic, strong) NSString *_devemail;
@property(nonatomic, strong) NSString *_note;
@property(nonatomic, assign) bool _initialized;
@property(nonatomic, strong) UIViewController<MFMailComposeViewControllerDelegate> *_controllerDelegate;

@end

@implementation ClassCreatorHelper

@synthesize _className, _reference, _useNil, _propertiesDictionary, _dicNamesDictionary, _author, _enterprise, _devemail, _note, _initialized, _controllerDelegate;

#pragma mark - init
- (id)init
{
    self = [super init];
    if (self)
    {
        [self resetVars];
    }
    
    return self;
}

#pragma mark - Instance Methods
- (void)createClassWithName:(NSString*)className objectReference:(NSString*)reference useNull:(bool)useNull viewControllerDelegate:(UIViewController*)controllerDelegate;
{
    if(!_initialized)
    {
        if([className isEqualToString:@""] || className == nil)
        {
            NSAssert(false, @"O nome da classe não pode ser nulo/vazio.");
        }
        
        _className = [NSString stringWithString:className];
        
        if([reference isEqualToString:@""] || reference == nil)
        {
            _reference = [reference uppercaseString];
        }
        else
        {
            _reference = [NSString stringWithString:reference];
        }
        
        _useNil = useNull;
        
        _initialized = true;
        
        _controllerDelegate = controllerDelegate;
        
        _propertiesDictionary = [NSMutableDictionary new];
        _dicNamesDictionary = [NSMutableDictionary new];
    }
}

- (void)addAuthor:(NSString*)author enterprise:(NSString*)enterprise devContact:(NSString*)devEmail extraNote:(NSString*)note;
{
    if([author isEqualToString:@""] || author == nil)
    {
        _author = @"";
    }
    else
    {
        _author = [NSString stringWithFormat:@"%@", author];
    }
    
    if([enterprise isEqualToString:@""] || enterprise == nil)
    {
        _enterprise = @"";
    }
    else
    {
        _enterprise = [NSString stringWithFormat:@"%@", enterprise];
    }
    
    if([note isEqualToString:@""] || note == nil)
    {
        _note = @"";
    }
    else
    {
        _note = [NSString stringWithFormat:@"%@", note];
    }
    
    if([devEmail isEqualToString:@""] || devEmail == nil)
    {
        _devemail = @"";
    }
    else
    {
        _devemail = [NSString stringWithFormat:@"%@", devEmail];
    }
}

- (bool)addPropertie:(NSString*)propertieName dictionaryName:(NSString*)dicName type:(cchTypeValue)propertieType;
{
    if([propertieName isEqualToString:@""] || propertieName == nil)
    {
        NSAssert(false, @"A propriedade não pode ter nome nulo/vazio.");
    }
    
    if([_propertiesDictionary.allKeys containsObject:propertieName])
    {
        return false;
    }
    else
    {
        [_propertiesDictionary setValue:@(propertieType) forKey:propertieName];
        
        if([dicName isEqualToString:@""] || dicName == nil)
        {
            [_dicNamesDictionary setValue:propertieName forKey:propertieName];
        }
        else
        {
            [_dicNamesDictionary setValue:dicName forKey:propertieName];
        }
    }
    
    return true;
}

-(bool)saveClassFiles
{
    //Validações
    if(!_initialized)
    {
        NSAssert(false, @"Nenhuma classe criada. Utilize o método 'createClassWithName:ObjectReference:UseNull' antes de salvar os arquivos.");
    }
    
    if(_propertiesDictionary.allKeys.count == 0)
    {
        NSAssert(false, @"Adicione pelo menos uma propriedade a classe criada.");
    }
    
    //Dados
    NSString* interfaceFile = [self createInterfaceData];
    NSString* implementationFile = [self createImplementationData];
    
    NSData *data1 = [interfaceFile dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data2 = [implementationFile dataUsingEncoding:NSUTF8StringEncoding];
    
    //Diretório
    NSURL *nsurl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSString *path1 = [nsurl.path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h", _className]];
    NSString *path2 = [nsurl.path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m", _className]];
    
    //Salvando
    bool  ok1 = [data1 writeToFile:path1 atomically:YES];
    bool  ok2 = [data2 writeToFile:path2 atomically:YES];
    
    if ([MFMailComposeViewController canSendMail] && _controllerDelegate)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Envio Email" message:@"Deseja enviar a classe criada por email?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Enviar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            MFMailComposeViewController *composeView = [[MFMailComposeViewController alloc] init];
            composeView.mailComposeDelegate = _controllerDelegate;
            [composeView setSubject:[NSString stringWithFormat:@"ClassCreatorHelper <%@> Objective-C",_className]];
            [composeView setMessageBody:[NSString stringWithFormat:@"Classe '%@' criada as %@, por '%@'.", _className, [self converteDataParaString:[NSDate date] ComFormato:@"yyyy/MM/dd HH:mm:ss Z"], _author] isHTML:NO];
            [composeView addAttachmentData:data1 mimeType:@"text/plain" fileName:[NSString stringWithFormat:@"%@.h", _className]];
            [composeView addAttachmentData:data2 mimeType:@"text/plain" fileName:[NSString stringWithFormat:@"%@.m", _className]];
            if (_devemail){
                [composeView setToRecipients:@[_devemail]];
            }
            //
            [_controllerDelegate.navigationController presentViewController:composeView animated:YES completion: NULL];
        }];
        [alert addAction:okAction];
        //
        UIAlertAction *okCancel = [UIAlertAction actionWithTitle:@"Fechar" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"Cancelou o envio do email.");
        }];
        [alert addAction:okCancel];
        //
        [_controllerDelegate.navigationController presentViewController:alert animated:YES completion:nil];
    }
    
    return (ok1 || ok2);
}

#pragma mark - INTERFACE

-(NSString*)createInterfaceData
{
    NSMutableString *tClass = [NSMutableString new];
    
    [tClass appendString:[self createHeaderForFile:@"h"]];
    [tClass appendString:@"#import <Foundation/Foundation.h>\n"];
    [tClass appendString:@"#import <UIKit/UIKit.h>\n"];
    [tClass appendString:@"#import \"DefaultObjectModelProtocol.h\"\n\n"];
    [tClass appendFormat:@"@interface %@ : NSObject<DefaultObjectModelProtocol>\n\n", _className];
    //
    [tClass appendString:@"//Properties\n"];
    for(int i=0; i<_propertiesDictionary.allKeys.count; i++)
    {
        NSString* s1 = (NSString*)_propertiesDictionary.allKeys[i];
        NSString* s2 = [self strongOrAssignForType:[[_propertiesDictionary valueForKey:s1] integerValue]];
        NSString* s3 = [self cocoaClassForType:[[_propertiesDictionary valueForKey:s1] integerValue]];
        [tClass appendFormat:@"@property(nonatomic, %@) %@ %@;\n", s2, s3, s1];
    }
    //
    [tClass appendString:@"\n//Protocol Methods\n"];
    //
    [tClass appendString:@"//@required\n"];
    [tClass appendFormat:@"+(%@*)newObject;\n", _className];
    [tClass appendString:@"+(NSString*)className;\n"];
    [tClass appendFormat:@"+(%@*)createObjectFromDictionary:(NSDictionary*)dicData;\n", _className];
    [tClass appendString:@"-(NSDictionary*)dictionaryJSON;\n\n"];
    //
    [tClass appendString:@"//@optional\n"];
    [tClass appendFormat:@"-(%@*)copyObject;\n", _className];
    [tClass appendString:@"-(bool)isEqualToObject:(id)object;\n"];
    [tClass appendString:@"-(void)defaultObject;\n"];
    [tClass appendString:@"-(void)updateObjectFromJSON:(NSDictionary*)dictionaryData reseting:(bool)reset;\n"];
    //
    [tClass appendString:@"@end"];
    
    return tClass;
}

#pragma mark - IMPLEMENTATION

-(NSString*)createImplementationData
{
    NSMutableString *tClass = [NSMutableString new];
    
    [tClass appendString:[self createHeaderForFile:@"h"]];
    [tClass appendFormat:@"#import \"%@.h\"\n\n", _className];
    
    NSArray *propertyNameList = [[NSArray alloc]initWithArray:[_propertiesDictionary allKeys]];
    NSArray *dicNameList = [[NSArray alloc]initWithArray:[_dicNamesDictionary allValues]];
    
#pragma mark @implementation
    
    [tClass appendFormat:@"@implementation %@\n\n",_className];
    
#pragma mark @synthesize
    
    [tClass appendString:@"@synthesize "];
    
    NSMutableString *sTemp = [NSMutableString new];
    for(int i=0; i<propertyNameList.count; i++)
    {
        if(i == propertyNameList.count - 1)
        {
            //last propertie
            [sTemp appendFormat:@"%@;\n\n", (NSString*)propertyNameList[i]];
        }
        else
        {
            [sTemp appendFormat:@"%@, ", (NSString*)propertyNameList[i]];
        }
    }
    
    [tClass appendFormat:@"%@", sTemp];
    
#pragma mark -init
    
    [tClass appendString:@"#pragma mark - Init\n\n"];
    [tClass appendString:@"- (id)init\n"];
    [tClass appendString:@"{\n"];
    [tClass appendString:@"\tself = [super init];\n"];
    [tClass appendString:@"\tif (self)\n"];
    [tClass appendString:@"\t{\n"];
    [tClass appendString:@"\t\t[self defaultObject];\n"];
    [tClass appendString:@"\t}\n"];
    [tClass appendString:@"\treturn self;\n"];
    [tClass appendString:@"}\n\n"];
    
    [tClass appendString:@"#pragma mark - Protocol Methods\n\n"];
    
#pragma mark +(instancetype)newObject;
    
    [tClass appendFormat:@"+ (%@*)newObject\n", _className];
    [tClass appendString:@"{\n"];
    [tClass appendFormat:@"\treturn [%@ new];\n", _className];
    [tClass appendString:@"}\n\n"];
    
#pragma mark +(NSString*)className;
    
    [tClass appendString:@"+ (NSString*)className\n"];
    [tClass appendString:@"{\n"];
    [tClass appendFormat:@"\treturn @\"%@\";\n", _className];
    [tClass appendString:@"}\n\n"];
    
#pragma mark +(instancetype)createObjectFromData:(NSDictionary*)dictionaryData
    
    [tClass appendFormat:@"+ (%@*)createObjectFromDictionary:(NSDictionary*)dicData\n", _className];
    [tClass appendString:@"{\n"];
    [tClass appendFormat:@"\t%@* new%@;\n\n", _className, _reference];
    [tClass appendString:@"\tNSArray* keysList = [dicData allKeys];\n\n"];
    [tClass appendString:@"\tif (keysList.count > 0)\n"];
    [tClass appendString:@"\t{\n"];
    [tClass appendFormat:@"\t\tnew%@ = [%@ new];\n", _reference, _className];
    //
    for(int i=0; i<propertyNameList.count; i++)
    {
        NSString* s1 = (NSString*)propertyNameList[i];
        NSString* s2 = (NSString*)dicNameList[i];
        NSString* s3 = [self defaultDictionaryValueForType:[[_propertiesDictionary valueForKey:(NSString*)propertyNameList[i]] integerValue] ForPropertie:s2];
        NSString* s4 = [self defaultValueForType:[[_propertiesDictionary valueForKey:(NSString*)propertyNameList[i]] integerValue] UseNil:_useNil];
        [tClass appendFormat:@"\t\t//\n\t\tnew%@.%@ = [keysList containsObject:@\"%@\"] ? %@ : %@;\n", _reference, s1, s2, s3, s4];
    }
    //
    [tClass appendString:@"\t}\n\n"];
    [tClass appendFormat:@"\treturn new%@;\n", _reference];
    [tClass appendString:@"}\n\n"];
    
#pragma mark -(NSDictionary*)dictionaryJSON
    
    [tClass appendString:@"- (NSDictionary*)dictionaryJSON\n"];
    [tClass appendString:@"{\n"];
    [tClass appendString:@"\tNSMutableDictionary *dic = [NSMutableDictionary new];\n"];
    //
    for(int i=0; i<propertyNameList.count; i++)
    {
        NSString* s1 = [self defaultValueDictionaryForType:[[_propertiesDictionary valueForKey:(NSString*)propertyNameList[i]] integerValue]  ForPropertie:(NSString*)propertyNameList[i]];
        NSString* s2 = (NSString*)dicNameList[i];
        [tClass appendFormat:@"\t//\n\t[dic setValue:%@ forKey:@\"%@\"];\n", s1, s2];
    }
    //
    [tClass appendString:@"\t//\n\treturn dic;\n"];
    [tClass appendString:@"}\n\n"];
    
#pragma mark -(instancetype)copyObject
    
    [tClass appendFormat:@"- (%@*)copyObject\n", _className];
    [tClass appendString:@"{\n"];
    [tClass appendFormat:@"\t%@* copy%@ = [%@ new];\n", _className, _reference, _className];
    //
    for(int i=0; i<propertyNameList.count; i++)
    {
        NSString* s1 = (NSString*)propertyNameList[i];
        NSString* s2 = [self stringCopyForPropertie:s1 Type:[[_propertiesDictionary valueForKey:(NSString*)propertyNameList[i]] integerValue]];
        [tClass appendFormat:@"\t//\n\tcopy%@.%@ = %@;\n", _reference, s1, s2];
    }
    //
    [tClass appendFormat:@"\t//\n\treturn copy%@;\n", _reference];
    [tClass appendString:@"}\n\n"];
    
#pragma mark -(bool)isEqualToObject:(instancetype)object
    
    [tClass appendFormat:@"- (bool)isEqualToObject:(%@*)object\n", _className];
    [tClass appendString:@"{\n"];
    //
    for(int i=0; i<propertyNameList.count; i++)
    {
        NSString* s1 = (NSString*)propertyNameList[i];
        NSString* s2 = [self stringComparatorForType:[[_propertiesDictionary valueForKey:(NSString*)propertyNameList[i]] integerValue] Property:s1];
        [tClass appendFormat:@"\t%@\n\t//\n", s2];
    }
    //
    [tClass appendString:@"\treturn true;\n"];
    [tClass appendString:@"}\n\n"];
    
#pragma mark -(void)defaultObject
    
    [tClass appendString:@"- (void)defaultObject\n"];
    [tClass appendString:@"{\n"];
    //
    for(int i=0; i<propertyNameList.count; i++)
    {
        [tClass appendFormat:@"\t%@ = %@;\n", (NSString*)propertyNameList[i], [self defaultValueForType:[[_propertiesDictionary valueForKey:(NSString*)propertyNameList[i]] integerValue] UseNil:_useNil]];
    }
    //
    [tClass appendString:@"}\n\n"];
    
#pragma mark -(void)updateObjectFromData:(NSDictionary*)dicData Reseting:(bool)reset

    [tClass appendString:@"- (void)updateObjectFromJSON:(NSDictionary*)dicData reseting:(bool)reset\n"];
    [tClass appendString:@"{\n"];
    [tClass appendString:@"\tNSArray* keysList = [dicData allKeys];\n\n"];
    [tClass appendString:@"\tif (keysList.count > 0)\n"];
    [tClass appendString:@"\t{\n"];
    //
    for(int i=0; i<propertyNameList.count; i++)
    {
        NSString* s1 = (NSString*)propertyNameList[i];
        NSString* s2 = (NSString*)dicNameList[i];
        NSString* s3 = [self defaultDictionaryValueForType:[[_propertiesDictionary valueForKey:(NSString*)propertyNameList[i]] integerValue] ForPropertie:s2];
        NSString* s4 = [self defaultValueForType:[[_propertiesDictionary valueForKey:(NSString*)propertyNameList[i]] integerValue] UseNil:_useNil];
        [tClass appendFormat:@"\t\t//\n\t\tself.%@ = [keysList containsObject:@\"%@\"] ? %@ : (reset ? %@ : self.%@);\n", s1, s2, s3, s4, s1];
    }
    //
    [tClass appendString:@"\t}\n"];
    [tClass appendString:@"}\n\n"];
    [tClass appendString:@"@end"];
    
    //FIM
    return tClass;
}


#pragma mark - Internal Methods

- (void)resetVars
{
    _className = nil;
    _reference = nil;
    _useNil = nil;
    _propertiesDictionary = nil;
    _dicNamesDictionary = nil;
    _author = nil;
    _enterprise = nil;
    _devemail = nil;
    _note = nil;
    _initialized = false;
    _controllerDelegate = nil;
}

-(NSString*)createHeaderForFile:(NSString*)hORm
{
    //NSLog(@"Target name: %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]);
    
    NSMutableString *tClass = [NSMutableString new];
    
    [tClass appendString:@"//\n"];
    [tClass appendFormat:@"// %@.%@\n", _className, hORm];
    [tClass appendFormat:@"// %@\n", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]];
    [tClass appendString:@"//\n"];
    //
    if(_author != nil && ![_author isEqualToString:@""])
    {
        [tClass appendFormat:@"// Created by %@ on %@.\n", _author, [self converteDataParaString:[NSDate date] ComFormato:@"yyyy/MM/dd HH:mm:ss Z"]];
    }
    else
    {
        [tClass appendFormat:@"// Created by <# Author #> on %@ (%@).\n", [self converteDataParaString:[NSDate date] ComFormato:@"yyyy/MM/dd HH:mm:ss Z"], _devemail];
    }
    //
    if(_enterprise != nil && ![_enterprise isEqualToString:@""])
    {
        [tClass appendFormat:@"// Copyright (c) %@. All rights reserved.\n", _enterprise];
    }
    else
    {
        [tClass appendString:@"// Copyright (c)  <#Enterprise#>. All rights reserved.\n"];
    }
    //
    [tClass appendString:@"//\n"];
    //
    if(_note != nil && ![_note isEqualToString:@""])
    {
        [tClass appendFormat:@"// Note: %@\n", _note];
    }
    else
    {
        [tClass appendString:@"// Note: <# Note #>\n"];
    }
    //
    [tClass appendString:@"//\n\n"];
    
    return tClass;
}

- (NSString*)converteDataParaString:(NSDate*)data ComFormato:(NSString *)formato
{
    if(data==nil)
    {
        return @"";
    }
    else
    {
        NSDateFormatter* formatarParaExibir = [[NSDateFormatter alloc]init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [formatarParaExibir setTimeZone:[NSTimeZone defaultTimeZone]];
        [formatarParaExibir setCalendar:calendar];
        [formatarParaExibir setDateFormat:formato];
        NSString* dataConvertida = [formatarParaExibir stringFromDate:data];
        
        return dataConvertida;
    }
}

- (BOOL)comparaData:(NSDate*)data1 ComData:(NSDate*)data2 Regra:(cchComparatorRules)regra
{
    if(data1 == nil)
    {
        if(data2 == nil)
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
        if(data2 == nil)
        {
            return false;
        }
        else
        {
            NSCalendar* calendar = [NSCalendar currentCalendar];
            unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
            NSDateComponents* comp1 = [calendar components:unitFlags fromDate:data1];
            NSDateComponents* comp2 = [calendar components:unitFlags fromDate:data2];
            
            for(int i=1; i< 8; i++)
            {
                switch (i)
                {
                    case 1: //Ano Maior
                    {
                        if([comp1 year] > [comp2 year])
                        {
                            if(regra==cchComparatorRules_GreaterThan || regra==cchComparatorRules_GreaterOrEqual)
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
                            if(regra==cchComparatorRules_LessThan || regra==cchComparatorRules_LessOrEqual)
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
                            if(regra==cchComparatorRules_GreaterThan || regra==cchComparatorRules_GreaterOrEqual)
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
                            if(regra==cchComparatorRules_LessThan || regra==cchComparatorRules_LessOrEqual)
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
                            if(regra==cchComparatorRules_GreaterThan || regra==cchComparatorRules_GreaterOrEqual)
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
                            if(regra==cchComparatorRules_LessThan || regra==cchComparatorRules_LessOrEqual)
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
                            if(regra==cchComparatorRules_Equal || regra==cchComparatorRules_GreaterOrEqual || regra==cchComparatorRules_LessOrEqual)
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


#pragma mark • Type Variable

- (NSString*)stringComparatorForType:(cchTypeValue)type Property:(NSString*)propertyName
{
    switch (type)
    {
        case cchTypeValue_Var:
        {
            return [NSString stringWithFormat:@"if(![self.%@ isEqualToObject:object.%@]){return false;}", propertyName, propertyName];
        }break;
            //
        case cchTypeValue_Boolean:
        {
            return [NSString stringWithFormat:@"if(self.%@ != object.%@){return false;}", propertyName, propertyName];
        }break;
            //
        case cchTypeValue_Int:
        {
            return [NSString stringWithFormat:@"if(self.%@ != object.%@){return false;}", propertyName, propertyName];
        }break;
            //
        case cchTypeValue_Long:
        {
            return [NSString stringWithFormat:@"if(self.%@ != object.%@){return false;}", propertyName, propertyName];
        }break;
            //
        case cchTypeValue_Float:
        {
            return [NSString stringWithFormat:@"if(self.%@ != object.%@){return false;}", propertyName, propertyName];
        }break;
            //
        case cchTypeValue_Double:
        {
            return [NSString stringWithFormat:@"if(self.%@ != object.%@){return false;}", propertyName, propertyName];
        }break;
            //
        case cchTypeValue_String:
        {
            return [NSString stringWithFormat:@"if(![self.%@ isEqualToString:object.%@]){return false;}", propertyName, propertyName];
        }break;
            //
        case cchTypeValue_Date:
        {
            NSMutableString *sTemp = [NSMutableString new];
            [sTemp appendFormat:@"NSString* s1 = [NSString stringWithFormat:@\"%%@\", self.%@];\n", propertyName];
            [sTemp appendFormat:@"\tNSString* s2 = [NSString stringWithFormat:@\"%%@\", object.%@];\n", propertyName];
            [sTemp appendString:@"\tif(![s1 isEqualToString:s2]){return false;}"];
            return sTemp;
        }break;
            //
        case cchTypeValue_Array:
        {
            NSMutableString *sTemp = [NSMutableString new];
            [sTemp appendFormat:@"if(self.%@.count != object.%@.count){return false;}\n", propertyName, propertyName];
            [sTemp appendString:@"\telse\n\t{\n"];
            [sTemp appendFormat:@"\t\tfor(int i=0; i<self.%@.count; i++)\n", propertyName];
            [sTemp appendString:@"\t\t{\n"];
            [sTemp appendFormat:@"\t\t\tif(![self.%@ isEqualToString:object.%@]){return false;}\n", propertyName, propertyName];
            [sTemp appendString:@"\t\t}\n"];
            [sTemp appendString:@"\t}"];
            return sTemp;
        }break;
            //
        case cchTypeValue_MArray:
        {
            NSMutableString *sTemp = [NSMutableString new];
            [sTemp appendFormat:@"if(self.%@.count != object.%@.count){return false;}\n", propertyName, propertyName];
            [sTemp appendString:@"\telse\n\t{\n"];
            [sTemp appendFormat:@"\t\tfor(int i=0; i<self.%@.count; i++)\n", propertyName];
            [sTemp appendString:@"\t\t{\n"];
            [sTemp appendFormat:@"\t\t\tif(![self.%@[i] isEqualToString:object.%@[i]]){return false;}\n", propertyName, propertyName];
            [sTemp appendString:@"\t\t}\n"];
            [sTemp appendString:@"\t}"];
            return sTemp;
        }break;
            //
        case cchTypeValue_Image:
        {
            return [NSString stringWithFormat:@"if(self.%@ != object.%@){return false;}//TODO: [?Image Comparator?]", propertyName, propertyName];
        }break;
            //
        case cchTypeValue_Dic:
        {
            NSMutableString *sTemp = [NSMutableString new];
            [sTemp appendFormat:@"NSString* s1 = [NSString stringWithFormat:@\"%%@\", self.%@];\n", propertyName];
            [sTemp appendFormat:@"\tNSString* s2 = [NSString stringWithFormat:@\"%%@\", object.%@];\n", propertyName];
            [sTemp appendString:@"\tif(![s1 isEqualToString:s2]){return false;}"];
            return sTemp;
        }break;
            //
        case cchTypeValue_MDic:
        {
            NSMutableString *sTemp = [NSMutableString new];
            [sTemp appendFormat:@"NSString* s1 = [NSString stringWithFormat:@\"%%@\", self.%@];\n", propertyName];
            [sTemp appendFormat:@"\tNSString* s2 = [NSString stringWithFormat:@\"%%@\", object.%@];\n", propertyName];
            [sTemp appendString:@"\tif(![s1 isEqualToString:s2]){return false;}"];
            return sTemp;
        }break;
            //
        default:
        {
            return @"?Type?";
        }break;
    }
}


- (NSString*)strongOrAssignForType:(cchTypeValue)type
{
    switch (type)
    {
        case cchTypeValue_Var:
        {
            return @"strong";
        }break;
            //
        case cchTypeValue_Boolean:
        {
            return @"assign";
        }break;
            //
        case cchTypeValue_Int:
        {
            return @"assign";
        }break;
            //
        case cchTypeValue_Long:
        {
            return @"assign";
        }break;
            //
        case cchTypeValue_Float:
        {
            return @"assign";
        }break;
            //
        case cchTypeValue_Double:
        {
            return @"assign";
        }break;
            //
        case cchTypeValue_String:
        {
            return @"strong";
        }break;
            //
        case cchTypeValue_Date:
        {
            return @"strong";
        }break;
            //
        case cchTypeValue_Array:
        {
            return @"strong";
        }break;
            //
        case cchTypeValue_MArray:
        {
            return @"strong";
        }break;
            //
        case cchTypeValue_Image:
        {
            return @"strong";
        }break;
            //
        case cchTypeValue_Dic:
        {
            return @"strong";
        }break;
            //
        case cchTypeValue_MDic:
        {
            return @"strong";
        }break;
            //
        default:
        {
            return @"???";
        }break;
    }
}

- (NSString*)cocoaClassForType:(cchTypeValue)type
{
    switch (type)
    {
        case cchTypeValue_Var:
        {
            return @"?Type?";
        }break;
            //
        case cchTypeValue_Boolean:
        {
            return @"boolean";
        }break;
            //
        case cchTypeValue_Int:
        {
            return @"int";
        }break;
            //
        case cchTypeValue_Long:
        {
            return @"long";
        }break;
            //
        case cchTypeValue_Float:
        {
            return @"float";
        }break;
            //
        case cchTypeValue_Double:
        {
            return @"double";
        }break;
            //
        case cchTypeValue_String:
        {
            return @"NSString*";
        }break;
            //
        case cchTypeValue_Date:
        {
            return @"NSDate*";
        }break;
            //
        case cchTypeValue_Array:
        {
            return @"NSArray*";
        }break;
            //
        case cchTypeValue_MArray:
        {
            return @"NSMutableArray*";
        }break;
            //
        case cchTypeValue_Image:
        {
            return @"UIImage*";
        }break;
            //
        case cchTypeValue_Dic:
        {
            return @"NSDictionary";
        }break;
            //
        case cchTypeValue_MDic:
        {
            return @"NSMutableDictionary";
        }break;
            //
        default:
        {
            return @"?Type?";
        }break;
    }
}

- (NSString*)stringCopyForPropertie:(NSString*)propertieName Type:(cchTypeValue)type
{
    switch (type)
    {
        case cchTypeValue_Var:
        {
            return [NSString stringWithFormat:@"[self.%@ copyObject]", propertieName];
        }break;
            //
        case cchTypeValue_Boolean:
        {
            return [NSString stringWithFormat:@"self.%@", propertieName];
        }break;
            //
        case cchTypeValue_Int:
        {
            return [NSString stringWithFormat:@"self.%@", propertieName];
        }break;
            //
        case cchTypeValue_Long:
        {
            return [NSString stringWithFormat:@"self.%@", propertieName];
        }break;
            //
        case cchTypeValue_Float:
        {
            return [NSString stringWithFormat:@"self.%@", propertieName];
        }break;
            //
        case cchTypeValue_Double:
        {
            return [NSString stringWithFormat:@"self.%@", propertieName];
        }break;
            //
        case cchTypeValue_String:
        {
            return [NSString stringWithFormat:@"[NSString stringWithFormat:@\"%%@\", self.%@]", propertieName];
        }break;
            //
        case cchTypeValue_Date:
        {
            return [NSString stringWithFormat:@"[[NSDate alloc] initWithTimeInterval:0 sinceDate:self.%@]", propertieName];
        }break;
            //
        case cchTypeValue_Array:
        {
            return [NSString stringWithFormat:@"[[NSArray alloc] initWithArray:self.%@]", propertieName];
        }break;
            //
        case cchTypeValue_MArray:
        {
            return [NSString stringWithFormat:@"[[NSMutableArray alloc] initWithArray:self.%@]", propertieName];
        }break;
            //
        case cchTypeValue_Image:
        {
            return [NSString stringWithFormat:@"[UIImage imageWithCGImage:self.%@.CGImage]", propertieName];
        }break;
            //
        case cchTypeValue_Dic:
        {
            return [NSString stringWithFormat:@"[NSDictionary dictionaryWithDictionary:self.%@]", propertieName];
        }break;
            //
        case cchTypeValue_MDic:
        {
            return [NSString stringWithFormat:@"[NSMutableDictionary dictionaryWithDictionary:self.%@]", propertieName];
        }break;
            //
        default:
        {
            return @"?Type?";
        }break;
    }
}

-(NSString*)defaultValueForType:(cchTypeValue)type UseNil:(bool)useNil
{
    //    g2e_TypeValue_Var       = 0, //Utilizado para classes complexas
    //    g2e_TypeValue_Boolean   = 1,
    //    g2e_TypeValue_Int       = 2,
    //    g2e_TypeValue_Long      = 3,
    //    g2e_TypeValue_Float     = 4,
    //    g2e_TypeValue_Double    = 5,
    //    g2e_TypeValue_String    = 6,
    //    g2e_TypeValue_Date      = 7,
    //    g2e_TypeValue_Array     = 8,
    //    g2e_TypeValue_MArray    = 9, //MutableArray
    //    g2e_TypeValue_Image     = 10,
    //    g2e_TypeValue_Dic       = 11,
    //    g2e_TypeValue_MDic      = 12 //MutableDictionary
    
    switch (type)
    {
        case cchTypeValue_Var:
        {
            return useNil ? @"nil" : @"?Type?";
        }break;
            //
        case cchTypeValue_Boolean:
        {
            return @"false";
        }break;
            //
        case cchTypeValue_Int:
        {
            return @"0";
        }break;
            //
        case cchTypeValue_Long:
        {
            return @"0";
        }break;
            //
        case cchTypeValue_Float:
        {
            return @"0.0";
        }break;
            //
        case cchTypeValue_Double:
        {
            return @"0.0";
        }break;
            //
        case cchTypeValue_String:
        {
            return @"@\"\"";
        }break;
            //
        case cchTypeValue_Date:
        {
            return useNil ? @"nil" : @"[NSDate date]";
        }break;
            //
        case cchTypeValue_Array:
        {
            return useNil ? @"nil" : @"[NSArray new]";
        }break;
            //
        case cchTypeValue_MArray:
        {
            return useNil ? @"nil" : @"[NSMutableArray new]";
        }break;
            //
        case cchTypeValue_Image:
        {
            return useNil ? @"nil" : @"[UIImage imageNamed:???]";
        }break;
            //
        case cchTypeValue_Dic:
        {
            return useNil ? @"nil" : @"[NSDictionary new]";
        }break;
            //
        case cchTypeValue_MDic:
        {
            return useNil ? @"nil" : @"[NSMutableDictionary new]";
        }break;
            //
        default:
        {
            return @"?Type?";
        }break;
    }
}


- (NSString*)defaultDictionaryValueForType:(cchTypeValue)type ForPropertie:(NSString*)propertieName
{
    switch (type)
    {
        case cchTypeValue_Var:
        {
            return [NSString stringWithFormat:@"[[dicData valueForKey:@\"%@\"] ?complexValue]", propertieName];
        }break;
            //
        case cchTypeValue_Boolean:
        {
            return [NSString stringWithFormat:@"[[dicData valueForKey:@\"%@\"] boolValue]", propertieName];
        }break;
            //
        case cchTypeValue_Int:
        {
            return [NSString stringWithFormat:@"[[dicData valueForKey:@\"%@\"] intValue]", propertieName];
        }break;
            //
        case cchTypeValue_Long:
        {
            return [NSString stringWithFormat:@"[[dicData valueForKey:@\"%@\"] longValue]", propertieName];
        }break;
            //
        case cchTypeValue_Float:
        {
            return [NSString stringWithFormat:@"[[dicData valueForKey:@\"%@\"] floatValue]", propertieName];
        }break;
            //
        case cchTypeValue_Double:
        {
            return [NSString stringWithFormat:@"[[dicData valueForKey:@\"%@\"] doubleValue]", propertieName];
        }break;
            //
        case cchTypeValue_String:
        {
            return [NSString stringWithFormat:@"[NSString stringWithFormat:@\"%%@\", [dicData valueForKey:@\"%@\"]]", propertieName];
        }break;
            //
        case cchTypeValue_Date:
        {
            return [NSString stringWithFormat:@"[NSString stringWithFormat:@\"%%@\", [dicData valueForKey:@\"%@\"]]", propertieName];
        }break;
            //
        case cchTypeValue_Array:
        {
            return [NSString stringWithFormat:@"[NSString stringWithFormat:@\"%%@\", [dicData valueForKey:@\"%@\"]]", propertieName];
        }break;
            //
        case cchTypeValue_MArray:
        {
            return [NSString stringWithFormat:@"[NSString stringWithFormat:@\"%%@\", [dicData valueForKey:@\"%@\"]]", propertieName];
        }break;
            //
        case cchTypeValue_Image:
        {
            return @"<?TODO?>";
        }break;
            //
        case cchTypeValue_Dic:
        {
            return [NSString stringWithFormat:@"[NSString stringWithFormat:@\"%%@\", [dicData valueForKey:@\"%@\"]]", propertieName];;
        }break;
            //
        case cchTypeValue_MDic:
        {
            return [NSString stringWithFormat:@"[NSString stringWithFormat:@\"%%@\", [dicData valueForKey:@\"%@\"]]", propertieName];
        }break;
            //
        default:
        {
            return [NSString stringWithFormat:@"[[dicData valueForKey:@\"%@\"] ?complexValue]", propertieName];
        }break;
    }
}

- (NSString*)defaultValueDictionaryForType:(cchTypeValue)type ForPropertie:(NSString*)propertieName
{
    switch (type)
    {
        case cchTypeValue_Var:
        {
            return [NSString stringWithFormat:@"self.%@ ?complexValue", propertieName];
        }break;
            //
        case cchTypeValue_Boolean:
        {
            return [NSString stringWithFormat:@"@(self.%@)", propertieName];
        }break;
            //
        case cchTypeValue_Int:
        {
            return [NSString stringWithFormat:@"@(self.%@)", propertieName];
        }break;
            //
        case cchTypeValue_Long:
        {
            return [NSString stringWithFormat:@"@(self.%@)", propertieName];
        }break;
            //
        case cchTypeValue_Float:
        {
            return [NSString stringWithFormat:@"@(self.%@)", propertieName];
        }break;
            //
        case cchTypeValue_Double:
        {
            return [NSString stringWithFormat:@"@(self.%@)", propertieName];
        }break;
            //
        case cchTypeValue_String:
        {
            return [NSString stringWithFormat:@"self.%@", propertieName];
        }break;
            //
        case cchTypeValue_Date:
        {
            return [NSString stringWithFormat:@"self.%@ ?CorrectType", propertieName];
        }break;
            //
        case cchTypeValue_Array:
        {
            return [NSString stringWithFormat:@"self.%@", propertieName];
        }break;
            //
        case cchTypeValue_MArray:
        {
            return [NSString stringWithFormat:@"self.%@", propertieName];
        }break;
            //
        case cchTypeValue_Image:
        {
            return [NSString stringWithFormat:@"self.%@ ?CorrectType", propertieName];
        }break;
            //
        case cchTypeValue_Dic:
        {
            return [NSString stringWithFormat:@"self.%@", propertieName];
        }break;
            //
        case cchTypeValue_MDic:
        {
            return [NSString stringWithFormat:@"self.%@", propertieName];
        }break;
            //
        default:
        {
            return [NSString stringWithFormat:@"self.%@ ?complexValue", propertieName];
        }break;
    }
}

@end
