//
//  ToolBox.h
//  AdAliveStore
//
//  Created by Erico GT on 9/22/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "math.h"
#import "zlib.h"
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <Accelerate/Accelerate.h>
//
#import <sys/utsname.h>
#import <float.h>
#import <zlib.h>
#import <dlfcn.h>

#pragma clang diagnostic ignored "-Wcast-qual"

@interface ToolBox : NSObject

#pragma mark - ENUMS
typedef enum {tbComparationRule_Less, tbComparationRule_Equal, tbComparationRule_Greater, tbComparationRule_LessOrEqual, tbComparationRule_GreaterOrEqual} enumComparationRules;
typedef enum {tbValidationResult_Undefined, tbValidationResult_Approved, tbValidationResult_Disapproved} enumValidationResult;

#pragma mark - • TOOL BOX

/** Retorna dados informativos sobre a versão corrente do utilitário 'ToolBox'.*/
+ (NSString*) toolBoxHelper_classVersionInfo;

#pragma mark - • APPLICATION HELPER

/** Versão do aplicativo.*/
+ (NSString*) applicationHelper_VersionBundle;

/** Retorna o caminho de instalação do app (útil para testes com simulador). Preferencialmente utilize no 'didFinishLaunchingWithOptions' do AppDelegate.*/
+ (NSString*) applicationHelper_InstalationDataForSimulator;

/** Informa o tamanho de um dado arquivo (da pasta de documentos do usuário). Utiliza formatos: bytes, KB, MB, GB, TB, conforme necessidade.*/
+ (NSString*) applicationHelper_FileSize:(NSString*)fileName;

/** Verifica se um dado arquivo existe na pasta de documentos do usuário.*/
+ (bool) applicationHelper_VerifyFile:(NSString*)fileName;

/** Salva arquivo (imagem, texto) na pasta de documentos do usuário.*/
+ (bool) applicationHelper_SaveFile:(NSData*)data WithName:(NSString*)fileName;

/** Carrega dados de um arquivo da pasta de documentos do usuário. Utilize extensão do arquivo, se existir.*/
+ (NSData*) applicationHelper_LoadDataFromFile:(NSString*)fileName;

/** Renomeia um arquivo existente na pasta de documentos do usuário.*/
+ (bool) applicationHelper_RenameFile:(NSString*)oldFileName To:(NSString*)newFileName;

/** Deleta um arquivo existente na pasta de documentos do usuário.*/
+ (bool) applicationHelper_DeleteFile:(NSString*)fileName;

/** Copia um dado arquivo com um novo nome.*/
+ (bool) applicationHelper_CopyFile:(NSString*)fileName WithName:(NSString*)copyFileName;

/** Clona um arquivo da aplicação para a pasta de documentos do usuário.*/
+ (bool) applicationHelper_CloneFileFromBundleToUserDirectory:(NSString*)fileName;

#pragma mark - • DEVICE HELPER

/** Retorna o tamanho da tela do dispositivo (em points).*/
+ (CGSize)deviceHelper_ScreenSize;

/** Retorna o modelo do dispositivo.*/
+ (NSString*)deviceHelper_Model;

/** Retorna o nome do dispositivo.*/
+ (NSString*)deviceHelper_Name;

/** Busca o tamanho total de memória interna do dispositivo.*/
+ (NSString*)deviceHelper_StorageCapacity;

/** Busca o tamanho da memória livre disponível no dispositivo.*/
+ (NSString*)deviceHelper_FreeMemorySpace;

/** Retorna a versão do SO.*/
+ (NSString*)deviceHelper_SystemVersion;

/** Retorna a língua atual  do sistema.*/
+ (NSString*)deviceHelper_SystemLanguage;

/** Retorna o calendário atual do sistema.*/
+ (NSString*)deviceHelper_SystemCalendar;

/** Retorna o código UUID.*/
+ (NSString*) deviceHelper_IdentifierForVendor;

#pragma mark - • DATE HELPER

/** Converte texto para data. Utilizar constantes definidas na classe 'ToolBox'.*/
+ (NSDate*)dateHelper_DateFromString:(NSString*)stringDate withFormat:(NSString*)dateFormat;

/** Converte um valor timestamp para data.*/
+ (NSDate*)dateHelper_DateFromTimeStamp:(NSTimeInterval)interval;

/** Converte data para texto. Utilizar constantes definidas na classe 'ToolBox'.*/
+ (NSString*)dateHelper_StringFromDate:(NSDate*)date withFormat:(NSString*)format;

/** Converte data para texto, considerando um TimeZone específico. Utilizar constantes definidas na classe 'ToolBox'.*/
+ (NSString*)dateHelper_StringFromDate:(NSDate*)date withFormat:(NSString*)format TimeZone:(NSTimeZone*)timeZone;

/** Simplifica uma data, removendo hora, minuto e segundos (time resetado para zero).*/
+ (NSDate*)dateHelper_SimplifyDate:(NSDate*)date;

/** Cria um novo objeto, cópia da data.*/
+ (NSDate*)dateHelper_CopyDate:(NSDate*)date;

/** Calcula a idade (texto localizado pt-BR), baseando-se nas datas parâmetro.*/
+ (NSString*)dateHelper_CalculateAgeFromDate:(NSDate*)initialDate toDate:(NSDate*)finalDate;

/** Calcula o tempo transcorrido (texto localizado pt-BR), baseando-se nas datas parâmetro.*/
+ (NSString*)dateHelper_CalculateTimeFromDate:(NSDate*)initialDate toDate:(NSDate*)finalDate;

/** Calcula a quantidade de dias baseando-se nas datas parâmetro.*/
+ (NSInteger)dateHelper_CalculateTotalDaysBetweenInitialDate:(NSDate*)initialDate andFinalDate:(NSDate*)finalDate;

/** Calcula a quantidade de dias baseando-se nas datas parâmetro.*/
+ (NSInteger)dateHelper_CalculateTotalHoursBetweenInitialDate:(NSDate*)initialDate andFinalDate:(NSDate*)finalDate;

/** Retorna uma nova data, utilizando uma data base deslocada de 'n' unidades de calendário (ex.: dias, horas, minutos).*/
+ (NSDate*)dateHelper_NewDateForReferenceDate:(NSDate*)referenceDate offSet:(long)offSet forCalendarUnit:(NSCalendarUnit)unitCalendar;

/** Retorna o primeiro dia do mês para uma determinada data referência.*/
+ (NSDate*)dateHelper_FirtsDayOfMonthForReferenceDate:(NSDate*)referenceDate;

/** Retorna o último dia do mês para uma determinada data referência.*/
+ (NSDate*)dateHelper_LastDayOfMonthForReferenceDate:(NSDate*)referenceDate;

/** Retorna o ano vigente .*/
+ (int)dateHelper_ActualYear;

/** Encontra o valor absoluto de uma unidade de calendário (ano, mês, dia, etc) numa determinada data referência.*/
+ (long)dateHelper_ValueForUnit:(NSCalendarUnit)calendarUnit referenceDate:(NSDate*)date;

/** Retorna o timeStamp da data referência em segundos (apenas a parte inteira no número).*/
+ (long int)dateHelper_TimeStampInSecondsFromDate:(NSDate*)date;

/** Retorna o timeInterval da data referência completa.*/
+ (NSTimeInterval)dateHelper_TimeStampFromDate:(NSDate*)date;

/** Retorna o timeStamp textual completo do sistema iOS, sem pontuação.*/
+ (NSString*)dateHelper_TimeStampCompleteIOSfromDate:(NSDate*)date;

/** Compara duas datas. Utiliza o typedef enum 'enumComparationRules' da classe 'ToolBox'. */
+ (bool)dateHelper_CompareDate:(NSDate*)date1 withDate:(NSDate*)date2 usingRule:(enumComparationRules)rule;

/** Retorna um texto no formato Mês/Ano (localizado pt-BR) para uma data referência. Ex.: JAN/2016. */
+ (NSString*)dateHelper_MonthAndYearForReferenceDate:(NSDate*)referenceDate usingAbbreviation:(bool)abbreviation;

/** Encontra o nome do dia da semana para determinado indice (localizado pt-BR). */
+ (NSString*)dateHelper_DayOfTheWeekNameForIndex:(int)indexDay usingAbbreviation:(bool)abbreviation;

/** Encontra o nome do mês para determinado indice (localizado pt-BR). */
+ (NSString*)dateHelper_MonthNameForIndex:(int)indexMonth usingAbbreviation:(bool)abbreviation;

/** Formata uma dada data para texto com máscara 'EEEE, dd 'de' MMMM 'de' yyyy, HH:mm:ss. */
+ (NSString*)dateHelper_CompleteStringFromDate:(NSDate*)referenceDate;

/** Este método retorna 'Ontem', 'Hoje', 'Amanhã' ou vazio ("") para uma data referência. */
+ (NSString*)dateHelper_IdentifiesYesterdayTodayTomorrowFromDate:(NSDate*)referenceDate;

/** Este método retorna 'Madrugada', 'Manhã', 'Tarde' ou 'Noite' para um horário referência. */
+ (NSString*)dateHelper_IdentifiesDayPeriodFromDate:(NSDate*)referenceDate;

/** Este método retorna o formato de horário de acordo com o utilizado pelo sistema no momento ('HH:mm:ss' para 24 horas ou 'h:mm:ss a' para 12 horas). */
+ (NSString*)dateHelper_SystemTimeUsingMask;

/** Este método retorna uma data que é composta por outras duas datas*/
+ (NSDate *)dateHelper_CompleteDateFromDate:(NSDate *)date andHour:(NSDate *)hour;

/** Retorna um texto amigável para a data referência. Ex.: 'hoje, 08:15', 'ontem, 11:30', '12/09/2016, 17:11'.*/
+ (NSString*)dateHelper_FriendlyStringFromDate:(NSDate*)date;

/** Converte o formato de uma data textual para outro formato.*/
+ (NSString*)dateHelper_NewStringDateForText:(NSString*)dateText originalFormat:(NSString*)originalFormat newFormat:(NSString*)newFormat;

#pragma mark - • MESSURE HELPER

/** Normaliza um valor para uma determinada precisão.*/
+ (double)messureHelper_NormalizeValue:(double)value decimalPrecision:(int)precision;

/** Verifica se dois números são iguais, utilizando uma precisão parâmetro como limitador.*/
+ (bool)messureHelper_CheckEqualityFromValue:(double)value1 andValue:(double)value2 decimalPrecision:(int)precision;

/** Formata um tamanho pata texto adicionando a unidade mais apropriada.*/
+ (NSString*)messureHelper_FormatSizeString:(double)size;

#pragma mark - • VALIDATION HELPER

/** Verifica se um email é compatível segundo o regex utilizado por padrão. Para saber mais: 'http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/'.*/
+ (enumValidationResult)validationHelper_EmailChecker:(NSString*)email;

/** Verifica se todos os caracteres de um texto pertencem ou não a uma dada lista de caracteres.*/
+ (enumValidationResult)validationHelper_TextCheck:(NSString*)text withList:(NSArray*)validationList restricting:(bool)restrictForList;

/**
 * Cria uma lista de caracteres, contendo os elementos selecionados.
 * @param numbers     Acrescenta os numerais a lista [0-9].
 * @param capsLetters     Acrescenta letras maiúsculas a lista [A-Z].
 * @param minusLetters     Acrescenta letras maiúsculas a lista [a-z].
 * @param symbols     Acrescenta símbolos a lista [vários].
 * @param control     Acrescenta caracteres de controle a lista [\a, \b, \t, \n, \v, \f, \r, \e].
 * @return     Retorna uma lista vazia caso todos os paramêtros estejam negados.
 */
+ (NSArray*)validationHelper_NewListOfCharactersWithNumbers:(bool)numbers capsLetters:(bool)capsLetters minusLetters:(bool)minusLetters symbols:(bool)symbols controlCharacters:(bool)control;

/** Verifica o MIMEType para um determinado arquivo com extensão conhecida.*/
+ (NSString*)validationHelper_MIMETypeForWebContent:(NSString*)url;

/** Verifica se o texto equivale a verdadeiro ou falso.*/
+ (bool)validationHelper_ValidateBoleanForText:(NSString*)text comparing:(bool)comparationValue;

/** Verifica se um CPF é válido.*/
+ (enumValidationResult)validationHelper_ValidateCPF:(NSString*)cpfText;

/** Encapsula campos de um dicionário com '<![CDATA[]]>'.*/
+ (NSDictionary*)validationHelper_NormalizeDictionaryForCDATA:(NSDictionary*)dictionary encapsulating:(bool)encapsulating;

/** Valida um CNPJ digitado*/
+(BOOL)validationHelper_validateCNPJ:(NSString *)cnpj;

/** Verifica se um cartão de crédito é válido */
+ (BOOL)validationHelper_ValidateCreditCard:(NSString *)cardNumberString;

#pragma mark - • TEXT HELPER

/** Aplica criptografia MD5 para um texto parâmetro.*/
+ (NSString*)textHelper_HashMD5forText:(NSString*)text;

/** Aplica criptografia SHA512 para um texto parâmetro.*/
+ (NSString*)textHelper_HashSHA512forText:(NSString*)text;

/** Verifica se um dado texto é vazio.*/
+ (bool)textHelper_CheckRelevantContentInString:(NSString*)text;

/** Inverte um texto parâmetro.*/
+ (NSString*)textHelper_Inverter:(NSString*)text;

/** Verifica se um dado text possui o caracter parâmetro.*/
+ (bool)textHelper_CheckOccurrencesOfChar:(char)character inText:(NSString*)text usingOptions:(NSStringCompareOptions)options;

#pragma mark - • GRAPHIC HELPER

/** Cria uma cor RGB através de um texto.*/
+ (UIColor*)graphicHelper_colorWithHexString:(NSString*)string;

/** Reduz o tamanho de uma imagem, aplicando compressão JPEG para otimizar o tamanho da mesma. [Ver também método 'graphicHelper_CompressImage:usingQuality:']*/
+ (UIImage*)graphicHelper_NormalizeImage:(UIImage*)image maximumDimension:(int)maxDimension quality:(float)quality;

/** Converte uma imagem para sua representação base64 string.*/
+ (NSString *) graphicHelper_EncodeToBase64String:(UIImage *)image;

/** Converte um texto base64 para a imagem correspondente.*/
+ (UIImage *) graphicHelper_DecodeBase64ToImage:(NSString *)strEncodeData;

/** Cria uma cópia de uma imagem fazendo sobreposição de cor.*/
+ (UIImage *) graphicHelper_ImageWithTintColor:(UIColor*)color andImageTemplate:(UIImage*)image;

/** Retorna uma imagem representação do Layer parâmetro.*/
+ (UIImage*) graphicHelper_Snapshot_Layer:(CALayer*)layer;

/** Retorna uma imagem representação da View parâmetro.*/
+ (UIImage*) graphicHelper_Snapshot_View:(UIView*)view;

/** Retorna uma imagem representação do ViewController parâmetro.*/
+ (UIImage*) graphicHelper_Snapshot_ViewController:(UIViewController*)viewController;

/** Adiciona o efeito BLUR em uma imagem referência.*/
+ (UIImage*) graphicHelper_ApplyBlurEffectInImage:(UIImage*)image withRadius:(CGFloat)radius;

/** Adiciona o efeito Branco e Preto em uma imagem referência.*/
+ (UIImage*) graphicHelper_ApplyGrayScaleEffectInImage:(UIImage*)image withIntensity:(CGFloat)intensity;

/** Adiciona o efeito DISTORTION (CIGlassDistortion) em uma imagem referência.*/
+ (UIImage*) graphicHelper_ApplyDistortionEffectInImage:(UIImage*)image;

/** Adiciona o efeito ROTATION em uma view.*/
+ (void) graphicHelper_ApplyRotationEffectInView:(UIView*)view withDuration:(CFTimeInterval)time repeatCount:(float)count;

/** Adiciona efeito parallax na View parâmetro.*/
+ (void) graphicHelper_ApplyParallaxEffectInView:(UIView*)view with:(CGFloat)deep;

/** Remove todos efeitos parallax da View parâmetro.*/
+ (void) graphicHelper_RemoveParallaxEffectInView:(UIView*)view;

/** Adiciona uma animação de efeito ripple circular na View parâmetro.*/
+ (void) graphicHelper_ApplyRippleEffectAnimationInView:(UIView*)view withColor:(UIColor*)color andRadius:(CGFloat)radius;

/** Adiciona uma animação de efeito ripple na View parâmetro.*/
+ (void) graphicHelper_ApplyRippleEffectAnimationForBoundsInView:(UIView*)view withColor:(UIColor*)color sizeScale:(CGFloat)scale andDuration:(float)duration;

/** Adiciona uma animação de batida de coração na View parâmetro.*/
+ (void) graphicHelper_ApplyHeartBeatAnimationInView:(UIView*)view withScale:(CGFloat)scale;

/** Adiciona uma animação de incremento/decremento de tamanho na View parâmetro.*/
+ (void) graphicHelper_ApplyScaleBeatAnimationInView:(UIView*)view withScale:(CGFloat)scale repeatCount:(float)repeatCount;

/** Adiciona borda na image parâmetro.*/
+ (UIImage*) graphicHelper_ApplyBorderToImage:(UIImage*)image withColor:(UIColor*)borderColor andWidth:(float)borderWidth;

/** Cria uma imagem flat num tamanho específico.*/
+ (UIImage*) graphicHelper_CreateFlatImageWithSize:(CGSize)size byRoundingCorners:(UIRectCorner)corners cornerRadius:(CGSize)radius andColor:(UIColor*)color;

/** Adiciona sombra a View parâmetro.*/
+ (void) graphicHelper_ApplyShadowToView:(UIView*)view withColor:(UIColor*)color offSet:(CGSize)offSet radius:(CGFloat)radius opacity:(CGFloat)opacity;

/** Remove sombra da View parâmetro.*/
+ (void) graphicHelper_RemoveShadowFromView:(UIView*)view;

/** Corta e redimensiona circularmente uma imagem.*/
+ (UIImage*) graphicHelper_CircularScaleAndCropImage:(UIImage*)image frame:(CGRect)frame;

/** Corta parte da imagem deferência.*/
+ (UIImage*) graphicHelper_CropImage:(UIImage*)image usingFrame:(CGRect)frame;

/** Aplica uma máscara na imagem base, gerando uma nova imagem 'vazada'. A máscara deve ser uma imagem sem alpha, em escala de cinza (o branco define a transparência, preto solidez).*/
+ (UIImage*) graphicHelper_MaskImage:(UIImage*)image withMask:(UIImage*)mask;

/** Mescla duas imagens (a 'top' sobre a 'bottom'). É possível definir posição, mistura, transparência e escala para a imagem superior (top).*/
+ (UIImage*) graphicHelper_MergeImage:(UIImage*)bottomImage withImage:(UIImage*)topImage position:(CGPoint)position blendMode:(CGBlendMode)blendMode alpha:(float)alpha scale:(float)superImageScale;

/** Redimensiona a imagem parâmetro para um tamanho específico.*/
+ (UIImage*) graphicHelper_ResizeImage:(UIImage*)image toSize:(CGSize)newSize;

/** Redimensiona a imagem parâmetro baseando-se numa escala. Escala 0 (zero) ou negativa será ignorada.*/
+ (UIImage*) graphicHelper_ResizeImage:(UIImage*)image usingScale:(CGFloat)scale;

/** Redimensiona a imagem parâmetro para caiba num dado tamanho, mantendo o aspecto original. O tamanho parâmetro 'rectSize' deve ser dado em points, conforme tamanho do componente (ex.: <UIImageView>.frame.size).*/
+ (UIImage*) graphicHelper_ResizeImage:(UIImage*)image forCGRectSize:(CGSize)rectSize;

/** Comprime uma imagem para reduzir sua qualidade. O parâmetro 'image' é transformado no formato JPEG ,na qualidade correspondente.*/
+ (UIImage*) graphicHelper_CompressImage:(UIImage*)image usingQuality:(CGFloat)quality;

/** Copia uma imagem, opcionalmente modificando sua qualidade. Para 'quality' 1, é utilizado PNG, inferior JPG.*/
+ (UIImage*) graphicHelper_CopyImage:(UIImage*)image usingQuality:(CGFloat)quality;

/** Aplica filtro na imagem parâmetro. Certos filtros exigem parâmetros adicionais que devem ser passados pelo dicionário. Visitar o endereço para ver as opções: https://developer.apple.com/library/content/documentation/GraphicsImaging/Reference/CoreImageFilterReference/#//apple_ref/doc/uid/TP30000136-SW29.*/
+ (UIImage*) graphicHelper_ApplyFilter:(NSString*)filterName inImage:(UIImage*)image usingParameters:(NSDictionary*)parameters andScale:(float)scale;

#pragma mark - • CONVERTER HELPER

/** Converte um dicionário JSON em texto.*/
+ (NSString*)converterHelper_StringJsonFromDictionary:(NSDictionary*)dictionary;

/** Converte um texto em dicionário JSON.*/
+ (NSDictionary*)converterHelper_DictionaryFromStringJson:(NSString*)string;

/** Substitui o símbolo '+' do texto de um dicionário referência.*/
+ (NSDictionary*)converterHelper_NewDictionaryReplacingPlusSymbolFromDictionary:(NSDictionary*)refDictionary;

/** Remove valores textuais '<null>', '(null)', 'null' do dicionário parâmetro, substituindo pela por um termo escolhido.*/
+ (NSDictionary*)converterHelper_NewDictionaryRemovingNullValuesFromDictionary:(NSDictionary*)oldDictionary withString:(NSString*)newString;

/** Retorna uma url normalizada baseada em uma string.*/
+ (NSURL*)converterHelper_NormalizedURLForString:(NSString*)string;

/** Retorna o texto 'limpo' de uma html.*/
+ (NSString*)converterHelper_PlainStringFromHTMLString:(NSString *)htmlString;

/** Formata um valor numérico para seu equivalente monetário. Utiliza a localidade padrão do sistema.*/
+ (NSString*) converterHelper_MonetaryStringForValue:(double)value;

/** Converte graus em radianos.*/
+ (CGFloat)converterHelper_DegreeToRadian:(CGFloat)degree;

/** Converte radianos em graus.*/
+ (CGFloat)converterHelper_RadianToDegree:(CGFloat)radius;

/** Converte grau celsius para fahenheit.*/
+ (CGFloat)converterHelper_CelsiusToFahenheit:(CGFloat)celsius;

/** Converte fahenheit para grau celsius.*/
+ (CGFloat)converterHelper_FahenheitToCelsius:(CGFloat)fahenheit;

/** Retorna o equivalente numérico para um dado texto (localizado pt-BR). Ex: "R$ 50,00", "2,3 L", "5 m³" etc.*/
+ (double)converterHelper_DecimalValueFromText:(NSString*)text;

/** Formata um valor para texto, aplicando opcionalmente o símbolo monetário (localizado pt-BR).*/
+ (NSString*)converterHelper_StringFromValue:(double)value monetaryFormat:(bool)monetary decimalPrecision:(int)precision;

#pragma mark - • DATA HELPER

/** Comprime um dado aplicando 'gzip'.*/
+ (NSData*)dataHelper_GZipData:(NSData*)data withCompressionLevel:(float)level;

/** Descomprime um dado que tenha sido modificado por 'gzip'.*/
+ (NSData*)dataHelper_GUnzipDataFromData:(NSData*)data;

/** Verifica se um dado está comprimido com 'gzip'.*/
+ (bool)dataHelper_GZipCheckForData:(NSData*)data;

#pragma mark - • DEFINES

//Date Formats ************************************************************************************
#define TOOLBOX_DATA_BARRA_OBJETIVA_SEMANO @"dd/MMM"
#define TOOLBOX_DATA_BARRA_OBJETIVA_COMANO @"dd/MMM/yyyy"
#define TOOLBOX_DATA_BARRA_CURTA_NORMAL @"dd/MM/yyyy"
#define TOOLBOX_DATA_BARRA_CURTA_INVERTIDA @"yyyy/MM/dd"
#define TOOLBOX_DATA_BARRA_LONGA_NORMAL @"dd/MM/yyyy HH:mm"
#define TOOLBOX_DATA_BARRA_LONGA_INVERTIDA @"yyyy/MM/dd HH:mm"
#define TOOLBOX_DATA_BARRA_COMPLETA_INVERTIDA @"yyyy/MM/dd HH:mm:ss Z"
#define TOOLBOX_DATA_BARRA_COMPLETA_NORMAL @"dd/MM/yyyy HH:mm:ss Z"
#define TOOLBOX_DATA_BARRA_INFORMATIVA @"dd/MM/yyyy 'às' HH:mm"
#define TOOLBOX_DATA_HIFEN_CURTA_NORMAL @"dd-MM-yyyy"
#define TOOLBOX_DATA_HIFEN_CURTA_INVERTIDA @"yyyy-MM-dd"
#define TOOLBOX_DATA_HIFEN_LONGA_NORMAL @"dd-MM-yyyy HH:mm"
#define TOOLBOX_DATA_HIFEN_LONGA_INVERTIDA @"yyyy-MM-dd HH:mm"
#define TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA @"yyyy-MM-dd HH:mm:ss Z"
#define TOOLBOX_DATA_HIFEN_COMPLETA_NORMAL @"dd-MM-yyyy HH:mm:ss Z"
#define TOOLBOX_DATA_HIFEN_INFORMATIVA @"dd-MM-yyyy 'às' HH:mm"
//
#define TOOLBOX_DATA_AHK_yyyyMMdd_HHmmss @"yyyy-MM-dd'T'HH:mm:ss"
#define TOOLBOX_DATA_AHK_dd_MM_yyyy @"dd.MM.yyyy"
#define TOOLBOX_DATA_AHK_yyyyMMddHHmmss @"yyyyMMddHHmmss"
#define TOOLBOX_DATA_GSMD_yyyyMMdd_HHmmssSSS @"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
#define TOOLBOX_DATA_GSMD_ddMMyyyy_HHmmssZ @"dd/MM/yyyy HH:mm:sszzzz"

//Symbols ************************************************************************************
#define TOOLBOX_SYMBOL_DEFAULT_MONETARY @"R$"
#define TOOLBOX_SYMBOL_DEFAULT_VOLUME_LIQUID @"L"
#define TOOLBOX_SYMBOL_DEFAULT_VOLUME_SOLID @"m³"
#define TOOLBOX_SYMBOL_DEFAULT_DISTANCE @"KM"

//CDATA ************************************************************************************
#define CDATA_START @"<![CDATA["
#define CDATA_END @"]]>"

//Macro Util Methods ************************************************************************************
//New Color
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//Converter
#define UIColorFromHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@end
