//
//  OFIconMapper.m
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/11/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "OFIconMapper.h"

@implementation OFIconMapper

+(NSDictionary *)imageForCategoryName:(NSString *)categoryName
{
    LogInfo(@" > > > > > > > > > > > > > > %@", categoryName);
    
    
    
    NSString *accentedString = categoryName;
    NSString *unaccentedString = [accentedString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale localeWithLocaleIdentifier:@"PT-br"]];
    NSString *capitalizedString = [[unaccentedString capitalizedString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    capitalizedString = [capitalizedString stringByReplacingOccurrencesOfString:@"," withString:@""];
    capitalizedString = [capitalizedString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *categoryImageName =   [NSString stringWithFormat:@"UISearchDepartament%@",capitalizedString];
    UIImage *categoryImage =        [UIImage imageNamed:categoryImageName];
    
    NSString *genericImageName = @"UISearchDepartamentGeneric";
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (categoryImage) {
        [dict setObject:categoryImageName forKey:@"normal"];
        //[dict setValue:categoryImageName forKey:@"normal"];
        [dict setObject:[NSString stringWithFormat:@"%@Pressed", categoryImageName] forKey:@"pressed"];
    } else {
        [dict setObject:genericImageName forKey:@"normal"];
        [dict setObject:[NSString stringWithFormat:@"%@Pressed", genericImageName] forKey:@"pressed"];
    }
    
    LogInfo(@" > > > > > > > > > > > > > > %@", categoryImageName);
    
    return dict;
    
    /*
     switch ([categoryName lowercaseString])
     {
     case @"":
     imageName = @"UISearchDepartamentMoveisEColchoes";
     break;
     case @"":
     imageName = @"UISearchDepartamentEletrodomesticos";
     break;
     case 247:
     imageName = @"UISearchDepartamentInformatica";
     break;
     case 345:
     imageName = @"UISearchDepartamentEsporteELazer";
     break;
     case 1165:
     imageName = @"UISearchDepartamentCamaMesaEBanho";
     break;
     case 44:
     imageName = @"UISearchDepartamentTelefonia";
     break;
     case 169:
     imageName = @"UISearchDepartamentEletroportateis";
     break;
     case 3155:
     imageName = @"UISearchDepartamentTablets";
     break;
     case 650:
     imageName = @"UISearchDepartamentUtilidadesDomesticas";
     break;
     case 580:
     imageName = @"UISearchDepartamentBebes";
     break;
     case 1249:
     imageName = @"UISearchDepartamentCasaESeguranca";
     break;
     case 1:
     imageName = @"UISearchDepartamentBelezaESaude";
     break;
     case 317:
     imageName = @"UISearchDepartamentEletronicos";
     break;
     case 889:
     imageName = @"UISearchDepartamentFerramentas";
     break;
     case 77:
     imageName = @"UISearchDepartamentBrinquedos";
     break;
     case 205:
     imageName = @"UISearchDepartamentCamerasEFilmadoras";
     break;
     case 2903:
     imageName = @"UISearchDepartamentAutomotivo";
     break;
     case 401:
     imageName = @"UISearchDepartamentGames";
     break;
     case 2201:
     imageName = @"UISearchDepartamentInstrumentosMusicais";
     break;
     case 60138:
     imageName = @"UISearchDepartamentModa";
     break;
     case 60109:
     imageName = @"UISearchDepartamentModa";
     break;
     case 431:
     imageName = @"UISearchDepartamentRelogios";
     break;
     case 1916:
     imageName = @"UISearchDepartamentProdutosSustentaveis";
     break;
     
     //Petshop = 4423
     //Adega = 4373
     //Livros = 832
     //DVDs e Blu-Ray = 754
     //Móveis e Decoração = Mesmo que móveis
     
     default:
     imageName = @"UISearchDepartamentGeneric";
     break;
     }
     */
}

@end
