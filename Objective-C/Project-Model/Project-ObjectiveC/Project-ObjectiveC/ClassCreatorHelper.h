//
//  ClassCreatorHelper.h
//  AHK-100anos
//
//  Created by Erico GT on 10/31/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface ClassCreatorHelper : NSObject

typedef NS_ENUM(NSInteger, cchTypeValue)
{
    cchTypeValue_Var       = 0, //Utilizado para classes complexas / outros tipos
    cchTypeValue_Boolean   = 1,
    cchTypeValue_Int       = 2,
    cchTypeValue_Long      = 3,
    cchTypeValue_Float     = 4,
    cchTypeValue_Double    = 5,
    cchTypeValue_String    = 6,
    cchTypeValue_Date      = 7,
    cchTypeValue_Array     = 8,
    cchTypeValue_MArray    = 9, //MutableArray
    cchTypeValue_Image     = 10,
    cchTypeValue_Dic       = 11,
    cchTypeValue_MDic      = 12 //MutableDictionary
};

//Regras de comparação
typedef NS_ENUM(NSInteger, cchComparatorRules)
{
    cchComparatorRules_GreaterThan          = 0,
    cchComparatorRules_LessThan             = 1,
    cchComparatorRules_Equal                = 2,
    cchComparatorRules_GreaterOrEqual       = 3,
    cchComparatorRules_LessOrEqual          = 4
};

/**
 * Este método cria virtualmente uma classe, representada pelo texto correspondente do arquivo de interface e implementação. Estes dados podem ser salvos posteriormente gerando assim arquivos de classe correspondentes (.h e .m).
 * @param   className    Representa o nome da classe. Será adicionado automaticamente o termo "Class" ao final do texto. Padronizar o parâmetro para ter a primeira letra maiúscula. Ex.: O parâmetro 'Veiculo' resultará numa classe chamada 'VeiculoClass'.
 * @param   reference   É um termo amigável para as variáveis internas. Ex.: O parâmetro 'Veiculo' resultará em variáveis internas 'newVeiculo', 'copyVeiculo' etc.
 * @param   useNull    Determina se as propriedades usarão valor nulo como padrão (quando tipo não for primitivo) ou se serão instanciadas.
 * @param   controllerDelegate   Caso não seja nulo, um viewController passado como delegate pode oferecer o envio da classe pronta por email, para o dev;
 */
- (void)createClassWithName:(NSString*)className objectReference:(NSString*)reference useNull:(bool)useNull viewControllerDelegate:(UIViewController<MFMailComposeViewControllerDelegate>*)controllerDelegate;

/**
 * Este método adiciona à classe criada o nome do desenvolvedor, da empresa (para direitos autorais) e uma nota de observação. Estes dados serão utilizados como comentário no cabeçalho dos arquivos e não são obrigatórios.
 * @param   author    Nome do autor da classe (desenvolvedor).
 * @param   enterprise   Nome da empresa que detém os direitos do projeto.
 * @param   devEmail   Email do contato do desenvolvedor. Opcional.
 * @param   note    Observações adicionais sobre a classe.
 */
- (void)addAuthor:(NSString*)author enterprise:(NSString*)enterprise devContact:(NSString*)devEmail extraNote:(NSString*)note;

/**
 * Este método adiciona uma propriedade a classe criada anteriormente.
 * @param   propertieName    Nome da propriedade. Deve seguir as regras para criação de nome de propriedade e não pode ser nulo/vazio.
 * @param   dicName    Nome que será utilizado no dicionário de  representação da classe. Quando não fornecido, será igual ao 'propertieName'.
 * @param   propertieType    Tipo da propriedade representado pelo ENUM 'g2eTypeValue'.
 * @return     Caso a propriedade já exista no objeto, esta será desconsiderada.
 */
- (bool)addPropertie:(NSString*)propertieName dictionaryName:(NSString*)dicName type:(cchTypeValue)propertieType;

/**
 * Salva o conteúdo da classe em 2 arquivos distintos (Ex.: class.h e class.m) na pasta 'Documents' do aplicativo.
 * @return     Retorna verdadeiro se ambos os arquivos forem criados com sucesso.
 */
- (bool)saveClassFiles;

@end
