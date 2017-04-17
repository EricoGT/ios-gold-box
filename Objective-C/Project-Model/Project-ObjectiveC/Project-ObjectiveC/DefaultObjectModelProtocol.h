//
//  DefaultObjectModelProtocol.h
//  AHK-100anos
//
//  Created by Erico GT on 10/5/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

//DEFINES
//-------------------------------------------------------------------------------------------------------------
#define DOMP_OPD_INT 0
#define DOMP_OPD_FLOAT 0.0
#define DOMP_OPD_DOUBLE 0.0
#define DOMP_OPD_BOOLEAN false
#define DOMP_OPD_STRING @""
#define DOMP_OPD_DATE nil
#define DOMP_OPD_IMAGE nil
#define DOMP_OPD_DICTIONARY nil
#define DOMP_OPD_DATE nil
#define DOMP_OPD_ARRAY nil

@protocol DefaultObjectModelProtocol

@required

/**
 * Método construtor.
 * @return     Retorna uma instância da referida classe.
 */
+(instancetype)newObject;

/**
 * Método que retorna o texto referente ao noma da classe (para compatibilidade com servidor de sincronização).
 * @return     Retorna o nome da classe para uso na sincrinização.
 */
+(NSString*)className;

/**
 * Método construtor, a partir de dados pré existentes.
 * @return     Retorna uma instância da referida classe. Propriedades não preenchidas pelas keys parâmetros devem ter seu valor default.
 */
+(instancetype)createObjectFromDictionary:(NSDictionary*)dicData;

/**
 * Cria uma representação em forma de dicionário das propriedades do objeto, com os valores devidamente atualizados.
 * @return      Retorna um dicionário com as propriedades e seus respectivos valores no formato key/value. O nome das keys está definido conforme convenção do serviço web.
 */
-(NSDictionary*)dictionaryJSON;

////=========================================================================================================

@optional

/**
 * Cria uma @b cópia do objeto.
 * @return     Retorna uma nova instância da classe, tendo suas propriedades idênticas ao objeto original.
 */
-(instancetype)copyObject;

/**
 * Compara dois objetos.
 * @return     Retorna verdadeiro apenas se todas as propriedades de ambos os objetos tiverem os mesmos valores. Campos nulos também são testados.
 */
-(bool)isEqualToObject:(id)object;

/**
 * Restaura as propriedades do objeto para seus valores padrão. Os valores devem ser preferencialmente iguais aos inseridos no método 'newObject'.
 */
-(void)defaultObject;

/**
 * Atualiza os valores das propriedades conforme os dados parâmetros. Os atributos não amparados pelas keys podem ou não ser resetados.
 * @param reset     Quando verdadeiro, todas as propriedades não amparadas pelas respectivas keys devem ser resetadas para seu valor default.
 */
-(void)updateObjectFromJSON:(NSDictionary*)dicData Reseting:(bool)reset;


@end
