//
//  WMParser.m
//  Ofertas
//
//  Created by Marcelo Santos on 7/11/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "WMParser.h"
#import <zlib.h>
#import "NSString+HTML.h"

#import "WMTokens.h"

#import "OFSetup.h"
#import "WMParser.h"
#import "DepartmentMenuItem.h"
#import "ShoppingMenuItem.h"
#import "CategoryMenuItemCount.h"

#define nbProducts 0 //0:default - get total of products from server

#define keyWarrantyName @"GARANTIA_ESTENDIDA"

@interface WMParser ()

@property (strong, nonatomic) NSDictionary *splashDictionary;

@end

@implementation WMParser

@synthesize  delegate, skinCurrent;

- (void) parseJsonSplash:(NSString *)content {
    
    self.splashDictionary = nil;
    NSError *error = nil;
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    //Products List Parse
//    NSArray *keys = [jsonObjects allKeys];
//    LogInfo(@"Keys Splash: %@", keys);
    
    //Current Splash
    self.splashDictionary = jsonObjects;
    NSDictionary *splashCurrent = [jsonObjects valueForKey:@"currentSplash"];
    NSString *splashId = [splashCurrent objectForKey:@"name"];
    LogInfo(@"Splash current: %@", splashId);
    
    //Current Skin
    self.skinCurrent = [jsonObjects valueForKey:@"currentSkin"];
    LogInfo(@"Current Skin: %@", skinCurrent);
    
    //Database verify
    MDSSqlite *db = [[MDSSqlite alloc] init];
    db.delegate = self;
//    BOOL testDB = [db verifyDBExists];
//    LogInfo(@"Test db: %i", testDB);
    
    BOOL alreadyDB = [db verifySplashId:splashId];
    LogInfo(@"Splash id already in DB?: %i", alreadyDB);

    //Persist or NOT data splash
//    WMPersist *wp = [[WMPersist alloc] init];
//    [wp persistSplashInDB:splashCurrent];
    
    if (alreadyDB) {
        
        LogInfo(@"Get Splash from Cache");
        //If it exists on db, just call from database
        [self finishedOperationDatabaseSplash:splashId];
        
    } else {
        
        LogInfo(@"Get Splash from Web");
        
        //Or download and copy to docs folder
        NSString *splashImgUrl = [splashCurrent objectForKey:@"imageUrl"];
        splashImgUrl = [splashImgUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
        LogURL(@"\n[WMParser - parseJsonSplash:] Splash image url: \n%@\n", splashImgUrl);
        NSString *splashImgRatio = [splashCurrent objectForKey:@"aspectImg"];
        LogInfo(@"Splash image ratio: %@", splashImgRatio);
        NSArray *splashColorBg = [splashCurrent objectForKey:@"bgColor"];
        LogInfo(@"Splash bg color: %@", splashColorBg);
        
        //Persist elements
        //Determine name of image
        NSString *nameFile = skinCurrent;
        
        NSString *nameFileToPersist = [NSString stringWithFormat:@"%@.png", skinCurrent];
        
        //Save file from image (promotion)
        NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *splashDir = [docsDir stringByAppendingPathComponent:@"Splash"];
        //Create folder
        [[NSFileManager defaultManager] createDirectoryAtPath:splashDir withIntermediateDirectories:NO attributes:nil error:&error];
        
        NSString *imagePath = [splashDir stringByAppendingPathComponent:nameFile];
        NSString *imagePathToPersist = [splashDir stringByAppendingPathComponent:nameFileToPersist];
        
        
        if (![nameFile isEqualToString:@"default"]) {
            //**Verificar
//        [self downloadImageSplash:@"https://images.walmart.com.br/mobile-api/blackfriday.png" imgPath:imagePath andNameFile:nameFile];
            [self downloadImageSplash:splashImgUrl imgPath:imagePath andNameFile:nameFile];
        }
        
        //If already in db, update the info - if not, add to db
        if (!alreadyDB) {
            LogInfo(@"Add to DB");
            [db addImageName:imagePathToPersist andSplashId:splashId andRatio:splashImgRatio andBgColor:splashColorBg];
        } else {
            LogInfo(@"Update DB");
            [db updateSplashId:splashId andImgName:imagePathToPersist andRatio:splashImgRatio andBgColor:splashColorBg];
        }
    }
}

- (void) downloadImageSplash:(NSString *) urlSplash imgPath:(NSString *) pathDocs andNameFile:(NSString *) nameFile {
    
    LogURL(@"[WMParser - downloadImageSplash:] Url Splash:%@", urlSplash);
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlSplash]]];
    
	LogInfo(@"%f,%f",image.size.width,image.size.height);
    
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    pathDocs = [docs stringByAppendingPathComponent:@"Splash"];
    
	// If you go to the folder below, you will find those pictures
	LogInfo(@"%@",pathDocs);
    
	LogInfo(@"saving png");
	NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",pathDocs, nameFile];
	NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
	[data1 writeToFile:pngFilePath atomically:YES];
    
	LogInfo(@"saving jpeg");
	NSString *jpegFilePath = [NSString stringWithFormat:@"%@/%@.jpeg",pathDocs, nameFile];
	NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
	[data2 writeToFile:jpegFilePath atomically:YES];
    
	LogInfo(@"saving image done");
}


- (void) finishedOperationDatabaseSplash:(NSString *)splashId {
    
    //Get data from database to send to splash page control
//    MDSSqlite *db = [[MDSSqlite alloc] init];
//    NSArray *splashElements = [db getSplashAllDataFromId:splashId];
//    LogInfo(@"Splash Finished Array: %@", splashElements);
    
//    NSString *splashImgPath = [splashElements objectAtIndex:1];
    NSString *splashImgPath = [[_splashDictionary objectForKey:@"currentSplash"]objectForKey:@"imageUrl"];
    LogURL(@"\n[WMParser - finishedOperationDatabaseSplash:] Splash image url: \n%@\n", splashImgPath);
//    NSString *splashImgRatio = [splashElements objectAtIndex:2];
    NSString *splashImgRatio = [[_splashDictionary objectForKey:@"currentSplash"]objectForKey:@"aspectImg"];
    LogInfo(@"Splash image ratio: %@", splashImgRatio);
    
    NSArray *splashColorBgTp = [[_splashDictionary objectForKey:@"currentSplash"]objectForKey:@"bgColor"];
    
//    NSArray *splashColorBgR = [splashElements objectAtIndex:3];
    NSArray *splashColorBgR = splashColorBgTp[0];
    LogInfo(@"Splash bg color R: %@", splashColorBgR);
//    NSArray *splashColorBgG = [splashElements objectAtIndex:5];
    NSArray *splashColorBgG = splashColorBgTp[1];
    LogInfo(@"Splash bg color G: %@", splashColorBgG);
//    NSArray *splashColorBgB = [splashElements objectAtIndex:4];
    NSArray *splashColorBgB = splashColorBgTp[2];
    LogInfo(@"Splash bg color B: %@", splashColorBgB);
//    NSArray *splashColorBgA = [splashElements objectAtIndex:6];
    NSArray *splashColorBgA = splashColorBgTp[3];
    LogInfo(@"Splash bg color A: %@", splashColorBgA);
    NSArray *splashColorBg = [NSArray arrayWithObjects:splashColorBgR, splashColorBgG, splashColorBgB, splashColorBgA, nil];
    
    LogInfo(@"splash dictionary: %@", _splashDictionary);
    
    if (_splashDictionary == NULL) {
        
        OFMessages *of = [[OFMessages alloc] init];
        
        [[self delegate] errorParseOrDatabase:[of errorParseOrDatabase]];
        
        return;
    }
    
    NSString *strImageUrl = [[_splashDictionary objectForKey:@"currentSplash"]objectForKey:@"imageUrl"];
    //For test
//    strImageUrl = @"https://investments4all.com/wp-content/uploads/2013/07/logo_walmart.jpg";
    
    NSDictionary *dictSplashSet;
    
    if (![strImageUrl isEqualToString:@""]) {
        
        dictSplashSet = @{@"currentSkin"    :   skinCurrent ?: @"",
                          @"splashId"       :   splashId ?: @"",
                          @"imageUrl"       :   strImageUrl ?: @"",
                          @"aspectImg"      :   splashImgRatio ?: @"",
                          @"bgColor"        :   splashColorBg ?: @"",
                          @"initialAlert"   :   [_splashDictionary objectForKey:@"message"] ?: @"",
                          @"loadImageSplash":   @YES
                          };
    }
    else {
        
        dictSplashSet = @{@"currentSkin"    :   skinCurrent ?: @"",
                          @"splashId"       :   splashId ?: @"",
                          @"imageUrl"       :   splashImgPath ?: @"",
                          @"aspectImg"      :   splashImgRatio ?: @"",
                          @"bgColor"        :   splashColorBg ?: @"",
                          @"initialAlert"   :   [_splashDictionary objectForKey:@"message"] ?: @"",
                          @"loadImageSplash":   @NO
                          };
    }
    
    [[self delegate] dictSplashSet:dictSplashSet];
}

- (void) parseJsonSkin:(NSString *) content {
    
}


- (void) finishedOperationDatabaseSkin:(NSString *)skinName {
    //Get data from database to send to splash page control
    MDSSqlite *db = [[MDSSqlite alloc] init];
    NSArray *skinElements = [db getSkinAllDataFromId:skinName];
    LogInfo(@"Skin Finished Array: %@", skinElements);
    
    //    NSString *currentSkin = [skinElements objectAtIndex:0];
    NSString *priceBarColor = [skinElements objectAtIndex:1];
    NSString *descriptionColor = [skinElements objectAtIndex:2];
    NSString *instalmentColor = [skinElements objectAtIndex:3];
    NSString *discountColor = [skinElements objectAtIndex:4];
    NSString *baseImgUrl = [skinElements objectAtIndex:5];
    NSString *imgIds = [skinElements objectAtIndex:6];
    NSString *origPriceColor = [skinElements objectAtIndex:7];
    NSString *bgColor = [skinElements objectAtIndex:8];
    NSString *pageControlColor = [skinElements objectAtIndex:9];
    NSString *homeBgColor = [skinElements objectAtIndex:10];
    NSString *cartBgColor = [skinElements objectAtIndex:11];
    NSString *pressedBgColor = [skinElements objectAtIndex:12];
    NSString *bannerBgColor = [skinElements objectAtIndex:13];
    NSString *cartBgPressedColor = [skinElements objectAtIndex:14];
    NSString *btnBgColor = [skinElements objectAtIndex:15];
    
    NSDictionary *dictSkinSet = [[NSDictionary alloc] initWithObjectsAndKeys:priceBarColor, @"priceBarColor", descriptionColor, @"descriptionColor", instalmentColor, @"instalmentColor", discountColor, @"discountColor", discountColor, @"discountPriceColor", baseImgUrl, @"baseImgUrl", imgIds, @"imgIds", origPriceColor, @"origPriceColor", bgColor, @"bgColor", pageControlColor, @"pageControlColor", skinName, @"currentSkin", homeBgColor, @"homeBgColor", cartBgColor, @"cartBgColor", pressedBgColor, @"pressedBgColor", bannerBgColor, @"bannerBgColor", cartBgPressedColor, @"cartBgPressedColor", btnBgColor, @"btnBgColor", nil];
    
    [[self delegate] dictSkinSet:dictSkinSet];
    
}


- (void) parseJsonProduct:(NSString *) content {
    
    //Fix json content
    content = [content stringByReplacingOccurrencesOfString:@"\"savePercentage:\":" withString:@"\"savePercentage\":"];
    
    NSError *error = nil;
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    //Json Parse
    NSArray *keys = [jsonObjects allKeys];
    LogInfo(@"Keys Product: %@", keys);
    
    //Current Product
    NSDictionary *dictElements = [jsonObjects valueForKey:@"product"];
    LogInfo(@"Subkeys Product: %@", [dictElements allKeys]);
    
    NSString *title = [dictElements valueForKey:@"title"];
    LogInfo(@"Product current: %@", title);
    NSString *urlbase = [dictElements valueForKey:@"baseImageUrl"];
    LogURL(@"Base image url: %@", urlbase);
    NSMutableArray *arrMutImgs = [dictElements valueForKey:@"imageIds"];
    NSArray *arrImgs = [NSArray arrayWithArray:arrMutImgs];
    LogInfo(@"Array Imgs: %@", arrImgs);
    NSString *idProd = [dictElements valueForKey:@"id"];
    LogInfo(@"Id Product: %@", idProd);
    NSString *standardSku = [dictElements valueForKey:@"standardSku"];
    LogInfo(@"Standard Sku: %@", standardSku);
    NSString *rating = [dictElements objectForKey:@"rating"];
    LogInfo(@"Rating: %@", rating);
    BOOL extendedWarranty = ([dictElements objectForKey:@"hasExtendedWarranty"]) ? [[dictElements objectForKey:@"hasExtendedWarranty"] boolValue] : NO;
    LogInfo(@"Has Extended Warranty: %@", (extendedWarranty) ? @"YES" : @"NO");
    
    //Product Variations
    NSArray *prodVariations = [dictElements valueForKey:@"productVariations"];
//    LogInfo(@"Product Variations: %@", prodVariations);
    
    NSMutableArray *arrVariations = [[NSMutableArray alloc] init];
//    NSDictionary *dictionary1 = [[NSDictionary alloc] init];
//    NSDictionary *dictionary2 = [[NSDictionary alloc] init];
    
    for (int i=0;i<[prodVariations count];i++) {
        
         LogInfo(@"*****************************************************************");
        
        NSDictionary *dictProd = [prodVariations objectAtIndex:i];
//        LogInfo(@"Dict [%i]: %@", i+1, dictProd);
        
        NSString *currency = [dictProd objectForKey:@"currency"];
        LogInfo(@"Currency %i: %@", i+1, currency);
        NSString *discountPrice = [dictProd objectForKey:@"discountPrice"];
//        discountPrice = [discountPrice stringByReplacingOccurrencesOfString:@"." withString:@","];
        LogInfo(@"Discount Price %i: %@", i+1, discountPrice);
        NSString *instalment = [dictProd objectForKey:@"instalment"];
        LogInfo(@"Instalment %i: %@", i+1, instalment);
//        NSString *minimumInstalmentValue = [dictProd objectForKey:@"minimumInstalmentValue"];
//        LogInfo(@"Minimum Instalment %i: %@", i+1, minimumInstalmentValue);
        NSString *minimumInstalmentValue = [dictProd objectForKey:@"instalmentValue"];
//        minimumInstalmentValue = [minimumInstalmentValue stringByReplacingOccurrencesOfString:@"." withString:@","];
        LogInfo(@"Minimum Instalment %i: %@", i+1, minimumInstalmentValue);
        NSString *originalPrice = [dictProd objectForKey:@"originalPrice"];
//        originalPrice = [originalPrice stringByReplacingOccurrencesOfString:@"." withString:@","];
        LogInfo(@"Original Price %i: %@", i+1, originalPrice);
        NSString *quantityAvailable = [dictProd objectForKey:@"quantityAvailable"];
        LogInfo(@"Qty Value %i: %@", i+1, quantityAvailable);
        NSString *saveAmount = [dictProd objectForKey:@"saveAmount"];
        LogInfo(@"Save Amount %i: %@", i+1, saveAmount);
        NSString *savePercentage = [dictProd objectForKey:@"savePercentage"];
        LogInfo(@"Save Percentage %i: %@", i+1, savePercentage);
        NSString *sku = [dictProd objectForKey:@"sku"];
        LogInfo(@"Sku %i: %@", i+1, sku);
        NSString *name = [dictProd objectForKey:@"name"];
        LogInfo(@"Voltage %i: %@", i+1, name);
        
        NSDictionary *dictVariations = [[NSDictionary alloc] initWithObjectsAndKeys:title, @"title", urlbase, @"baseImageUrl", arrImgs, @"imageIds", idProd, @"id", standardSku, @"standardSku", currency, @"currency", discountPrice, @"discountPrice", instalment, @"instalment", minimumInstalmentValue, @"minimumInstalmentValue", originalPrice, @"originalPrice", quantityAvailable, @"quantityAvailable", saveAmount, @"saveAmount", savePercentage, @"savePercentage", sku, @"sku", name, @"name", rating, @"rating", [NSNumber numberWithBool:extendedWarranty], @"hasExtendedWarranty", nil];
        
        [arrVariations addObject:dictVariations];
        
    }
    
    LogInfo(@"Variations prod info: %@", arrVariations);
    
    if ([arrVariations count] > 0) {
        
        [[self delegate] dictProductSet:arrVariations];
    } else {
        
        OFMessages *of = [[OFMessages alloc] init];
        NSString *strMsg = [NSString stringWithFormat:@"%@", [of errorParseOrDatabase]];
        [[self delegate] errorParseOrDatabase:strMsg];
    }
}



- (void) parseJsonProductBK:(NSString *) content {
    
    NSError *error = nil;
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    //Json Parse
    NSArray *keys = [jsonObjects allKeys];
    LogInfo(@"Keys Product: %@", keys);
    
    //Current Product
    NSDictionary *dictElements = [jsonObjects valueForKey:@"product"];
    LogInfo(@"Subkeys Product: %@", [dictElements allKeys]);
    
    NSString *title = [dictElements valueForKey:@"title"];
    LogInfo(@"Product current: %@", title);
    NSString *urlbase = [dictElements valueForKey:@"baseImageUrl"];
    LogURL(@"Base image url: %@", urlbase);
    NSMutableArray *arrMutImgs = [dictElements valueForKey:@"imageIds"];
    NSArray *arrImgs = [NSArray arrayWithArray:arrMutImgs];
    LogInfo(@"Array Imgs: %@", arrImgs);
    NSString *idProd = [dictElements valueForKey:@"id"];
    LogInfo(@"Id Product: %@", idProd);
    NSString *standardSku = [dictElements valueForKey:@"standardSku"];
    LogInfo(@"Standard Sku: %@", standardSku);
    NSString *rating = [dictElements objectForKey:@"rating"];
    LogInfo(@"Rating: %@", rating);
    
    //Product Variations
    NSArray *prodVariations = [dictElements valueForKey:@"productVariations"];
    //    LogInfo(@"Product Variations: %@", prodVariations);
    
    NSMutableArray *arrVariations = [[NSMutableArray alloc] init];
    //    NSDictionary *dictionary1 = [[NSDictionary alloc] init];
    //    NSDictionary *dictionary2 = [[NSDictionary alloc] init];
    
    for (int i=0;i<[prodVariations count];i++) {
        
        LogInfo(@"*****************************************************************");
        
        NSDictionary *dictProd = [prodVariations objectAtIndex:i];
        //        LogInfo(@"Dict [%i]: %@", i+1, dictProd);
        
        NSString *currency = [dictProd objectForKey:@"currency"];
        LogInfo(@"Currency %i: %@", i+1, currency);
        NSString *discountPrice = [dictProd objectForKey:@"discountPrice"];
        //        discountPrice = [discountPrice stringByReplacingOccurrencesOfString:@"." withString:@","];
        LogInfo(@"Discount Price %i: %@", i+1, discountPrice);
        NSString *instalment = [dictProd objectForKey:@"instalment"];
        LogInfo(@"Instalment %i: %@", i+1, instalment);
        //        NSString *minimumInstalmentValue = [dictProd objectForKey:@"minimumInstalmentValue"];
        //        LogInfo(@"Minimum Instalment %i: %@", i+1, minimumInstalmentValue);
        NSString *minimumInstalmentValue = [dictProd objectForKey:@"instalmentValue"];
        //        minimumInstalmentValue = [minimumInstalmentValue stringByReplacingOccurrencesOfString:@"." withString:@","];
        LogInfo(@"Minimum Instalment %i: %@", i+1, minimumInstalmentValue);
        NSString *originalPrice = [dictProd objectForKey:@"originalPrice"];
        //        originalPrice = [originalPrice stringByReplacingOccurrencesOfString:@"." withString:@","];
        LogInfo(@"Original Price %i: %@", i+1, originalPrice);
        NSString *quantityAvailable = [dictProd objectForKey:@"quantityAvailable"];
        LogInfo(@"Qty Value %i: %@", i+1, quantityAvailable);
        NSString *saveAmount = [dictProd objectForKey:@"saveAmount"];
        LogInfo(@"Save Amount %i: %@", i+1, saveAmount);
        NSString *savePercentage = [dictProd objectForKey:@"savePercentage"];
        LogInfo(@"Save Percentage %i: %@", i+1, savePercentage);
        NSString *sku = [dictProd objectForKey:@"sku"];
        LogInfo(@"Sku %i: %@", i+1, sku);
        NSString *name = [dictProd objectForKey:@"name"];
        LogInfo(@"Voltage %i: %@", i+1, name);
        
        NSDictionary *dictVariations = [[NSDictionary alloc] initWithObjectsAndKeys:title, @"title", urlbase, @"baseImageUrl", arrImgs, @"imageIds", idProd, @"id", standardSku, @"standardSku", currency, @"currency", discountPrice, @"discountPrice", instalment, @"instalment", minimumInstalmentValue, @"minimumInstalmentValue", originalPrice, @"originalPrice", quantityAvailable, @"quantityAvailable", saveAmount, @"saveAmount", savePercentage, @"savePercentage", sku, @"sku", name, @"name", rating, @"rating", nil];
        
        [arrVariations addObject:dictVariations];
        
    }
    
    LogInfo(@"Variations prod info: %@", arrVariations);
    
    if ([arrVariations count] > 0) {
        
        [[self delegate] dictProductSet:arrVariations];
    } else {
        
        OFMessages *of = [[OFMessages alloc] init];
        NSString *strMsg = [NSString stringWithFormat:@"%@", [of errorParseOrDatabase]];
        [[self delegate] errorParseOrDatabase:strMsg];
    }
    
    //    LogInfo(@"Original Price: %@", oldPrice);
    //    NSString *nowPrice = [dictElements valueForKey:@"discountPrice"];
    //    LogInfo(@"Discount Price: %@", nowPrice);
    //    NSString *quotesQty = [dictElements valueForKey:@"instalment"];
    //    LogInfo(@"Instalment: %@", quotesQty);
    //    NSString *quotesValue = [dictElements valueForKey:@"minimumInstalmentValue"];
    //    LogInfo(@"Minimum Instalment Value: %@", quotesValue);
    //    NSString *economy = [dictElements valueForKey:@"saveAmount"];
    //    LogInfo(@"Save Amount: %@", economy);
    
    
    //Old
    //    NSDictionary *dictElements = [jsonObjects valueForKey:@"oferta"];
    //    LogInfo(@"Subkeys Product: %@", [dictElements allKeys]);
    //    NSString *title = [dictElements valueForKey:@"title"];
    //    LogInfo(@"Product current: %@", title);
    //    NSString *urlbase = [dictElements valueForKey:@"baseImageUrl"];
    //    LogInfo(@"Base image url: %@", urlbase);
    //    NSMutableArray *arrMutImgs = [dictElements valueForKey:@"imageIds"];
    //    NSArray *arrImgs = [NSArray arrayWithArray:arrMutImgs];
    //    LogInfo(@"Array Imgs: %@", arrImgs);
    //    NSString *idProd = [dictElements valueForKey:@"id"];
    //    LogInfo(@"Id Product: %@", idProd);
    //    NSString *oldPrice = [dictElements valueForKey:@"originalPrice"];
    //    LogInfo(@"Original Price: %@", oldPrice);
    //    NSString *nowPrice = [dictElements valueForKey:@"discountPrice"];
    //    LogInfo(@"Discount Price: %@", nowPrice);
    //    NSString *quotesQty = [dictElements valueForKey:@"instalment"];
    //    LogInfo(@"Instalment: %@", quotesQty);
    //    NSString *quotesValue = [dictElements valueForKey:@"minimumInstalmentValue"];
    //    LogInfo(@"Minimum Instalment Value: %@", quotesValue);
    //    NSString *economy = [dictElements valueForKey:@"saveAmount"];
    //    LogInfo(@"Save Amount: %@", economy);
    //    NSString *sku = [dictElements valueForKey:@"sku"];
    //    LogInfo(@"Sku: %@", sku);
    
    //Product Details Delegate
    //    NSDictionary *dictProdSet = [[NSDictionary alloc] initWithObjectsAndKeys:title, @"title", urlbase, @"baseImageUrl", arrImgs, @"imageIds", idProd, @"id", oldPrice, @"originalPrice", nowPrice, @"discountPrice", quotesQty, @"instalment", quotesValue, @"minimumInstalmentValue", economy, @"saveAmount", sku, @"sku", nil];
    //
    //    [[self delegate] dictProductSet:dictProdSet];
    
}

- (void) parseJsonCategory:(NSString *)content {
    
    NSError *error = nil;
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    //Json Parse
    NSArray *keys = [jsonObjects allKeys];
    LogInfo(@"Keys Category: %@", keys);
    
    //Categories
    NSDictionary *dictElements = [jsonObjects valueForKey:@"category"];
    LogInfo(@"Dict Categories: %@", dictElements);
    
//    NSString *categoryName = [jsonObjects objectForKey:@"categoryName"];
//    LogInfo(@"ParseCategory: Category name: %@", categoryName);
//    NSString *collectionId = [jsonObjects objectForKey:@"collectionId"];
//    LogInfo(@"ParseCategory: Collection id: %@", collectionId);
//    NSArray *headerNormalColor = [jsonObjects objectForKey:@"headerNormalColor"];
//    LogInfo(@"ParseCategory: Header normal color: %@", headerNormalColor);
//    NSArray *headerPressedColor = [jsonObjects objectForKey:@"headerPressedColor"];
//    LogInfo(@"ParseCategory: Header pressed color: %@", headerPressedColor);
    
    NSString *categoryName = [dictElements objectForKey:@"categoryName"];
    LogInfo(@"ParseCategory: Category name: %@", categoryName);
    NSString *collectionId = [dictElements objectForKey:@"collectionId"];
    LogInfo(@"ParseCategory: Collection id: %@", collectionId);
    NSArray *headerNormalColor = [dictElements objectForKey:@"headerNormalColor"];
    LogInfo(@"ParseCategory: Header normal color: %@", headerNormalColor);
    NSArray *headerPressedColor = [dictElements objectForKey:@"headerPressedColor"];
    LogInfo(@"ParseCategory: Header pressed color: %@", headerPressedColor);

    //Products
    NSArray *products = [dictElements objectForKey:@"products"];
    
    NSMutableArray *arrProducts = [[NSMutableArray alloc] init];
    
    int ttProdCards = nbProducts;
    
    if (ttProdCards == 0) {
        ttProdCards = (int)[products count];
    }
    
    for (int i=0;i<ttProdCards;i++) {
    
        NSDictionary *dictProd = [products objectAtIndex:i];
        
        NSString *idProd = [dictProd objectForKey:@"id"];
        LogInfo(@"ParseCategory: Prod. Id: %@", idProd);
        NSString *standardSku = [dictProd objectForKey:@"standardSku"];
        LogInfo(@"ParseCategory: Standard Sku: %@", standardSku);
        NSString *title = [dictProd objectForKey:@"title"];
        LogInfo(@"ParseCategory: Title: %@", title);
        NSString *baseImageUrl = [dictProd objectForKey:@"baseImageUrl"];
        LogURL(@"ParseCategory: Base Image Url: %@", baseImageUrl);
        
        //Product Variations
        NSArray *productVariations = [dictProd objectForKey:@"productVariations"];
        LogInfo(@"ParseCategory: Product Variations: %@", productVariations);
        
        //Image Ids
        NSArray *arrImgs = [dictProd objectForKey:@"imageIds"];
        LogInfo(@"arrImages category: %@", arrImgs);
        //NSArray *arrImgs = [NSArray arrayWithObjects:@"0", nil];
//        
//        NSDictionary *dictProduct = [[NSDictionary alloc] initWithObjectsAndKeys:categoryName, @"categoryName", title, @"title", headerNormalColor, @"colorNormal", headerPressedColor, @"colorPressed", title, @"description", baseImageUrl, @"baseImageUrl", productVariations, @"productVariations", arrImgs, @"imageIds", idProd, @"id", @"collectionId", collectionId, nil];
        
//        NSDictionary *dictProduct = [[NSDictionary alloc] initWithObjectsAndKeys:categoryName, @"categoryName", title, @"title", headerNormalColor, @"colorNormal", headerPressedColor, @"colorPressed", title, @"description", baseImageUrl, @"baseImageUrl", productVariations, @"productVariations", arrImgs, @"imageIds", idProd, @"id", @"collectionId", collectionId, nil];
        
        NSDictionary *dictProduct = [[NSDictionary alloc] initWithObjectsAndKeys:@"teste", @"categoryName", title, @"title", @"0,0,0,255", @"colorNormal", @"0,0,0,255", @"colorPressed", title, @"description", baseImageUrl, @"baseImageUrl", productVariations, @"productVariations", arrImgs, @"imageIds", idProd, @"id", @"", @"collectionId", nil];
        
        LogInfo(@"Dict Product Category: %@", dictProduct);
        
        [arrProducts addObject:dictProduct];
        
        dictProduct = nil;
    }
    
    LogInfo(@"Arr products: %@", arrProducts);
    
    [[self delegate] dictCategorySet:arrProducts];
    
    arrProducts = nil;
    
    
//    //New file from server
//    NSString *baseImgUrl = [jsonObjects valueForKey:@"baseImageUrl"];
//    LogInfo(@"Img base url: %@", baseImgUrl);
//    
//    NSArray *categories = [jsonObjects valueForKey:@"categories"];
//    NSString *qtyCategories = [NSString stringWithFormat:@"%i", [categories count]];
//    LogInfo(@"Categories total: %@", qtyCategories);
    
//    NSMutableArray *arrProducts = [[NSMutableArray alloc] init];
//    
//    for (int i=0;i<[categories count];i++) {
//        LogInfo(@"***********************************************************");
//        NSDictionary *cat = [categories objectAtIndex:i];
//        
//        NSString *categoryName = [cat objectForKey:@"categoryName"];
//        LogInfo(@"Parse Category %i: %@", i, categoryName);
//        NSString *collectionId = [cat objectForKey:@"collectionId"];
//        LogInfo(@"Parse Collection id: %@", collectionId);
//        NSArray *headerNormalColor = [cat objectForKey:@"headerNormalColor"];
//        LogInfo(@"Parse Header normal color: %@", headerNormalColor);
//        NSArray *headerPressedColor = [cat objectForKey:@"headerPressedColor"];
//        LogInfo(@"Parse Header pressed color: %@", headerPressedColor);
//
//        //Products
//        NSArray *products = [cat objectForKey:@"products"];
//        NSDictionary *dictProd = [products objectAtIndex:0];
//        
//        NSString *idProd = [dictProd objectForKey:@"id"];
//        LogInfo(@"Parse Prod. Id: %@", idProd);
//        NSString *standardSku = [dictProd objectForKey:@"standardSku"];
//        LogInfo(@"Parse Standard Sku: %@", standardSku);
//        NSString *title = [dictProd objectForKey:@"title"];
//        LogInfo(@"Parse Title: %@", title);
//        NSString *baseImageUrl = [dictProd objectForKey:@"baseImageUrl"];
//        LogInfo(@"Parse Base Image Url: %@", baseImageUrl);
//        
//        //Product Variations
//        NSArray *productVariations = [dictProd objectForKey:@"productVariations"];
//        LogInfo(@"Parse Product Variations: %@", productVariations);
//        
//        //More categories?
//        NSString *collectionCategory = @"YES";
//
//        //Creating a dictionary with elements
//        NSDictionary *dictProduct = [[NSDictionary alloc] initWithObjectsAndKeys:baseImgUrl, @"baseImgUrl", qtyCategories, @"qtyCategories", categoryName, @"categoryName", collectionId, @"collectionId", headerNormalColor, @"headerNormalColor", headerPressedColor, @"headerPressedColor", idProd, @"idProd", standardSku, @"standardSku", title, @"title", baseImageUrl, @"baseImageUrl", productVariations, @"productVariations", collectionCategory, @"collectionCategory", nil];
//        
//        //Adding to array that 'll be sent to the home screen
//        [arrProducts addObject:dictProduct];
//    }
//    
//    [[self delegate] dictHomeSet:arrProducts];
}

#pragma mark - Extended Warranty
- (void) parseExtended:(NSString *) content {
    
    NSError *error = nil;
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (!error) {

        NSDictionary *dictContentExtended = [NSDictionary new];
        NSDictionary *dictElements;
        
        //Verify if exists key "skuItem"
        if ([jsonObjects valueForKey:@"skuItem"]) {
            dictElements = [jsonObjects valueForKey:@"skuItem"];
            NSString *skuId = [dictElements objectForKey:@"skuId"] ?: @"";
            NSString *productId = [dictElements objectForKey:@"productId"] ?: @"";
            BOOL kit = [[dictElements objectForKey:@"kit"] boolValue];
            //Verif if this is a kit
            if (kit) { //Search by kits
                if ((int) [[dictElements objectForKey:@"kitItems"] count] > 0) {
                    NSArray *arrExtendKit = [dictElements objectForKey:@"kitItems"];
                    NSMutableArray *arrMutExtended = [NSMutableArray new];
                    
                    for (int i=0;i<(int)[arrExtendKit count];i++) { //Determine how many kits
                        
                        //Detail each kit
//                        skuId = [[arrExtendKit objectAtIndex:i] objectForKey:@"skuId"] ?: @"";
                        productId = [[arrExtendKit objectAtIndex:i] objectForKey:@"productId"] ?: @"";
                        NSString *title = [[arrExtendKit objectAtIndex:i] objectForKey:@"title"] ?: @"";
                        
                        NSArray *arrExtended = [[arrExtendKit objectAtIndex:i] objectForKey:@"extendedWarranties"];
                        
                        for (int j=0;j<(int)[arrExtended count];j++) {
                            
                            dictContentExtended = @{@"skuId"            :   skuId,
                                                    @"productId"        :   productId,
                                                    @"extendedContent"  :   [self parseDictExtend:arrExtended],
                                                    @"isKit"            :   [NSNumber numberWithBool:YES],
                                                    @"title"            :   title
                                                    };
                        }
                        if ((int)[arrExtended count] > 0) {
                            [arrMutExtended addObject:dictContentExtended];
                        }
                    }
                    
                    NSArray *arrTp = [NSArray arrayWithArray:arrMutExtended];
                    LogInfo(@"Array Extended Warranty Kit: %@", arrTp);
                    
                    [[self delegate] dictExtended:arrTp];
                }
                else {
                    [[self delegate] errorParseExtended];
                }
            }
            else {
                //Verify if there is elements
                LogInfo(@"Dict Simple: %@", dictElements);
                
                if ((int) [[dictElements objectForKey:@"extendedWarranties"] count] > 0) { //Search by non kits
                    
                    NSArray *arrExtended = [dictElements objectForKey:@"extendedWarranties"];
                    dictContentExtended = @{@"skuId"            :   skuId,
                                            @"productId"        :   productId,
                                            @"extendedContent"  :   [self parseDictExtend:arrExtended],
                                            @"isKit"            :   [NSNumber numberWithBool:NO],
                                            @"title"            :   @""
                                            };
                    
                    NSArray *arrTp = @[dictContentExtended];
                    
                    [[self delegate] dictExtended:arrTp];
                }
                else {
                    [[self delegate] errorParseExtended];
                }
            }
        }
        else {
            [[self delegate] errorParseExtended];
        }
    }
    else {
        
        //There is a problem!!!
        [[self delegate] errorParseExtended];
    }
}

- (NSArray *) parseDictExtend:(NSArray *) arrExtended {
    
    NSMutableArray *arrTemp = [NSMutableArray new];
    
    for (int i=0;i<(int)[arrExtended count];i++) {
        NSDictionary *dict = [arrExtended objectAtIndex:i];
        NSString *strId = [dict objectForKey:@"id"];
        NSString *idSku = [dict objectForKey:@"idSku"];
        NSString *type = [dict objectForKey:@"type"];
        NSString *name = [dict objectForKey:@"name"];
        NSString *price = [dict objectForKey:@"price"];
        NSString *isAtive = [dict objectForKey:@"isAtive"];
        NSString *warrantyType = [dict objectForKey:@"warrantyType"];
        NSString *months = [dict objectForKey:@"months"];
        NSString *instalment = [dict objectForKey:@"instalment"];
        NSString *instalmentValue = [dict objectForKey:@"instalmentValue"];
        
        NSDictionary *dictTemp = @{
                                   @"id"                :   strId,
                                   @"idSku"             :   idSku,
                                   @"type"              :   type,
                                   @"name"              :   name,
                                   @"price"             :   price,
                                   @"isAtive"           :   isAtive,
                                   @"warrantyType"      :   warrantyType,
                                   @"months"            :   months,
                                   @"instalment"        :   instalment,
                                   @"instalmentValue"   :   instalmentValue
                                   };
        [arrTemp addObject:dictTemp];
    }
    LogInfo(@"arr Temp: %@", arrTemp);
    
    return arrTemp;
}


#pragma mark - Shipment Address
- (void) parseJsonShipment:(NSString *)content {

    NSError *error = nil;
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    NSMutableArray *adressList = [NSMutableArray new];
    
    //Json Parse
    NSArray *keys = [jsonObjects allKeys];
    LogInfo(@"Keys Auth Token: %@", keys);
    
    //Categories
    NSArray *arrElements = [jsonObjects valueForKey:@"addresses"];
    LogInfo(@"Dict Shipment [%i]: %@",(int) [arrElements count], arrElements);
    
    if ((int) [arrElements count] > 0) {
        
        for (int i=0;i<(int) [arrElements count];i++) {
            
            NSDictionary *dictElements = [arrElements objectAtIndex:i];
            LogInfo(@"Dict Elements [%i]: %@", i, dictElements);
            
            NSString *receiverName = [dictElements objectForKey:@"receiverName"] ?: @"";
            NSString *city = [dictElements objectForKey:@"city"] ?: @"";
            NSString *complement = [dictElements objectForKey:@"complement"] ?: @"";
            NSString *country = [dictElements objectForKey:@"country"] ?: @"";
            NSString *description = [dictElements objectForKey:@"description"] ?: @"";
            NSString *idShipment = [dictElements objectForKey:@"id"] ?: @"";
            NSString *neighborhood = [dictElements objectForKey:@"neighborhood"] ?: @"";
            NSString *number = [dictElements objectForKey:@"number"] ?: @"";
            NSString *postalCode = [dictElements objectForKey:@"postalCode"] ?: @"";
            NSString *referencePoint = [dictElements objectForKey:@"referencePoint"] ?: @"";
            NSString *state = [dictElements objectForKey:@"state"] ?: @"";
            NSString *street = [dictElements objectForKey:@"street"] ?: @"";
            NSString *type = [dictElements objectForKey:@"type"] ?: @"";
            NSString *addressDescription = [dictElements objectForKey:@"description"] ?: @"";
            
            NSDictionary *dictProfile = [dictElements objectForKey:@"profile"] ?: @"";
            
            BOOL validAdd = [[dictElements objectForKey:@"validAddress"]boolValue];
            BOOL defaultAddress = [[dictElements objectForKey:@"default"]boolValue];
            
            LogInfo(@"Shipment Complement   [%i]: %@",i, complement);
            LogInfo(@"Shipment Country      [%i]: %@",i, country);
            LogInfo(@"Shipment ID           [%i]: %@",i, idShipment);
            
            if ((![idShipment isEqualToString:@""]) && (idShipment))
            {
                
                NSDictionary *dictShipment = @{@"status" : @"full",
                                               @"receiverName" : receiverName,
                                               @"city" : city,
                                               @"complement" : complement,
                                               @"country" : country,
                                               @"description" : description,
                                               @"id" : idShipment,
                                               @"neighborhood" : neighborhood,
                                               @"number" : number,
                                               @"postalCode" : postalCode,
                                               @"referencePoint" : referencePoint,
                                               @"state" : state,
                                               @"street" : street,
                                               @"type" : type,
                                               @"qtyAddress" : [NSString stringWithFormat:@"%i", (int)[arrElements count]],
                                               @"iControl" : [NSString stringWithFormat:@"%i", i],
                                               @"profile": dictProfile,
                                               @"description" : addressDescription,
                                               @"default" : [NSNumber numberWithBool: defaultAddress],
                                               @"validAddress": [NSNumber numberWithBool:validAdd]
                                               };
                
                LogInfo(@"Shipment Dict [%i]: %@", i, dictShipment);
                [adressList addObject:dictShipment];
                //[[self delegate] dictShipmentAddress:dictShipment];
                //dictShipment = nil;
            }
        }
    }

    if (([self delegate]) && ([[self delegate] respondsToSelector:@selector(dictShipmentAddressList:)]))
    {
        [[self delegate] dictShipmentAddressList:adressList.copy];
    }

    /*
    NSArray *arrElements = jsonObjects;
    
    LogInfo(@"Shipment Qty: %i", [arrElements count]);
    
    for (int i=0;i<[arrElements count];i++) {
        
        NSDictionary *dictElements = [arrElements objectAtIndex:i];
        NSString *receiverName = [dictElements objectForKey:@"receiverName"];
        NSString *city = [dictElements objectForKey:@"city"];
        NSString *complement = [dictElements objectForKey:@"complement"];
        NSString *country = [dictElements objectForKey:@"country"];
        NSString *description = [dictElements objectForKey:@"description"];
        NSString *idShipment = [dictElements objectForKey:@"id"];
        NSString *neighborhood = [dictElements objectForKey:@"neighborhood"];
        NSString *number = [dictElements objectForKey:@"number"];
        NSString *postalCode = [dictElements objectForKey:@"postalCode"];
        NSString *referencePoint = [dictElements objectForKey:@"referencePoint"];
        NSString *state = [dictElements objectForKey:@"state"];
        NSString *street = [dictElements objectForKey:@"street"];
        NSString *type = [dictElements objectForKey:@"type"];
        
        NSDictionary *dictShipment = [[NSDictionary alloc] initWithObjectsAndKeys:receiverName, @"receiverName", city, @"city", complement, @"complement", country, @"country", description, @"description", idShipment, @"id", neighborhood, @"neighborhood", number, @"number", postalCode, @"postalCode", referencePoint, @"referencePoint", state, @"state", street, @"street", type, @"type", [NSString stringWithFormat:@"%i", [arrElements count]] ,@"qtyAddress", [NSString stringWithFormat:@"%i", i], @"iControl", nil];
        
        [[self delegate] dictShipmentAddress:dictShipment];
    }
     */
}


#pragma mark - Error Message

//delegate from ziparchive
- (void) ErrorMessage:(NSString *)msg {
    LogInfo(@"Error Message from ZipArchive: %@", msg);
    
    OFMessages *of = [[OFMessages alloc] init];
    NSString *strMsg = [NSString stringWithFormat:@"%@\n%@", [of errorZip], msg];
    
    [[self delegate] errorParseOrDatabase:strMsg];
}

- (void) errorDatabase {
    
    LogErro(@"Erro em uma operação na base de dados.");
    OFMessages *of = [[OFMessages alloc] init];
    
    [[self delegate] errorParseOrDatabase:[of errorParseOrDatabase]];
}

- (NSString *) getNameFile:(NSString *) url_ {
    
    LogURL(@"Url_: %@", url_);
//    NSString *url_ = @"foo://name.com:8080/12345;param?foo=1&baa=2#fragment";
    NSURL *url = [NSURL URLWithString:url_];
    
    NSArray *arrPath = [url pathComponents];
    NSString *nameFile = [arrPath objectAtIndex:[arrPath count] -1];
    LogInfo(@"Ele.: %@", nameFile);
    
    return nameFile;
    
//    NSLog(@"scheme: %@", [url scheme]);
//    NSLog(@"host: %@", [url host]);
//    NSLog(@"port: %@", [url port]);
//    NSLog(@"path: %@", [url path]);
//    NSLog(@"path components: %@", [url pathComponents]);
//    NSLog(@"parameterString: %@", [url parameterString]);
//    NSLog(@"query: %@", [url query]);
//    NSLog(@"fragment: %@", [url fragment]);
}

- (NSString *) convertArrayToStringColors:(NSArray *) arrColors {
    
    NSString *colorR = [arrColors objectAtIndex:0];
    NSString *colorG = [arrColors objectAtIndex:1];
    NSString *colorB = [arrColors objectAtIndex:2];
    NSString *colorA = [arrColors objectAtIndex:3];
    
    NSString *colorFinal = [NSString stringWithFormat:@"%@,%@,%@,%@", colorR, colorG, colorB, colorA];
    
    return colorFinal;
}

- (void) parseNewCart:(NSString *) cart withError:(BOOL) withError andSeller:(NSArray *) seller  andTypeError:(NSString *) typeError andErrorCode:(NSString *) errorCode {
    
    if ([OFSetup extendedWarrantyEnableNewCard]) {
        
        LogNewCheck(@"With Error: %i | Seller: %@ | Type error: %@ | Error Code: %@", withError, seller, typeError, errorCode);
        
        //    LogInfo(@"Parse Cart: %@", cart);
        
        NSError *error = nil;
        NSData *jsonData = [cart dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        //Json Parse
        //    NSArray *keys = [jsonObjects allKeys];
        //    LogInfo(@"Keys New Cart: %@", keys);
        
        //Categories
        NSArray *arrElements = [jsonObjects valueForKey:@"items"];
        //    LogInfo(@"Dict Cart [%i]: %@", (int)[arrElements count], arrElements);
        
        //Verify by extended warranty - Separating array
        NSMutableArray *arrExtend = [NSMutableArray array];
        //Separating product elements
        NSMutableArray *arrProd = [NSMutableArray array];
        NSDictionary *dictProd;
        
        for (int k=0;k<(int)[arrElements count];k++) {
            
            if ([[[arrElements objectAtIndex:k] objectForKey:@"type"] isEqualToString:keyWarrantyName]) {
                
                NSString *keyProduct = [[arrElements objectAtIndex:k] objectForKey:@"key"];
                NSString *sellerIdProduct = [[arrElements objectAtIndex:k] objectForKey:@"sellerId"];
                NSString *skuProduct = [[arrElements objectAtIndex:k] objectForKey:@"sku"];
                NSString *descriptionProduct = [[arrElements objectAtIndex:k] objectForKey:@"description"];
                NSString *priceProduct = priceProduct = [[arrElements objectAtIndex:k] objectForKey:@"price"];
                NSString *quantityProduct = [[arrElements objectAtIndex:k] objectForKey:@"quantity"];
                NSString *serviceIdProduct = [[arrElements objectAtIndex:k] objectForKey:@"serviceId"];
                
                BOOL unavailable = [[[arrElements objectAtIndex:k] objectForKey:@"itemUnavailable"] boolValue];
                
                NSDictionary *dictExt = @{@"key"                 : keyProduct,
                                          @"sellerId"            : sellerIdProduct,
                                          @"sku"                 : skuProduct,
                                          @"description"         : descriptionProduct,
                                          @"quantity"            : quantityProduct,
                                          @"price"               : priceProduct,
                                          @"unavailableProduct"  : [NSString stringWithFormat:@"%i", unavailable],
                                          @"serviceId"           : serviceIdProduct};
                [arrExtend addObject:dictExt];
            }
        }
        
        //Comparing products in cart with extended
//    LogInfo(@"ArrExtend: %@", arrExtend);
        
        NSString *pathImgProduct = @"";
        NSString *listPriceProduct = @"";
        NSString *idProduct = @"";
        BOOL unavailable = NO;
        BOOL markedToRemove = NO;
        NSString *sellerNameProduct = @"";
        NSMutableDictionary *dictExtend = [NSMutableDictionary dictionary];
        
        BOOL priceDivergent = NO;
        BOOL priceDivergentToLow = NO;
        
        for (int m=0;m<(int)[arrElements count];m++) {
            
            NSString *sellerIdProduct = [[arrElements objectAtIndex:m] objectForKey:@"sellerId"];
            NSString *skuProduct = [[arrElements objectAtIndex:m] objectForKey:@"sku"];
            NSString *descriptionProduct = [[arrElements objectAtIndex:m] objectForKey:@"description"];
            NSString *priceProduct = priceProduct = [[arrElements objectAtIndex:m] objectForKey:@"price"];
            NSString *quantityProduct = [[arrElements objectAtIndex:m] objectForKey:@"quantity"];
            NSString *idCell = [NSString stringWithFormat:@"%i", m];
            
            //Verify if exist key stockbalance
            NSString *currentMaxQuantityBySellerAndSku = @"10";
            
            if ([[arrElements objectAtIndex:m] objectForKey:@"stockBalance"]) {
                
                currentMaxQuantityBySellerAndSku = [[arrElements objectAtIndex:m] objectForKey:@"stockBalance"];
            }
            
            LogNewCheck(@"current Max QuantityBySellerAndSku: %@", currentMaxQuantityBySellerAndSku);
            
            //Ignore extended warranty products
            if (![[[arrElements objectAtIndex:m] objectForKey:@"type"] isEqualToString:keyWarrantyName]) {
                
                pathImgProduct = [[arrElements objectAtIndex:m] objectForKey:@"imageUrl"];
                LogNewCheck(@"Path Img: %@", pathImgProduct);
                
                //Fix listPrice
                listPriceProduct = [[arrElements objectAtIndex:m] objectForKey:@"listPrice"] ?: @"";

//                listPriceProduct = [[arrElements objectAtIndex:m] objectForKey:@"listPrice"];
                LogNewCheck(@"List Price: %@", listPriceProduct);
                
                idProduct = [[arrElements objectAtIndex:m] objectForKey:@"productId"];
                unavailable = [[[arrElements objectAtIndex:m] objectForKey:@"unavailableProduct"] boolValue];
                markedToRemove = [[[arrElements objectAtIndex:m] objectForKey:@"markedToRemove"] boolValue];
                sellerNameProduct = [[arrElements objectAtIndex:m] objectForKey:@"sellerName"];
                priceDivergent = [[[arrElements objectAtIndex:m] objectForKey:@"priceDivergent"] boolValue];
                priceDivergentToLow = [[[arrElements objectAtIndex:m] objectForKey:@"priceDivergentToLow"] boolValue];
                NSNumber *departmentId = [[arrElements objectAtIndex:m] objectForKey:@"departmentId"] ?: @"";
                NSNumber *categoryId = [[arrElements objectAtIndex:m] objectForKey:@"categoryId"] ?: @"";
                NSNumber *subCategoryId = [[arrElements objectAtIndex:m] objectForKey:@"subCategoryId"] ?: @"";
                
                BOOL isExtended = NO;
                
                NSDictionary *dictTemp = @{@"": @""};
                
                dictExtend = [NSMutableDictionary dictionaryWithDictionary:dictTemp];
                
                NSString *keyProduct = [[arrElements objectAtIndex:m] objectForKey:@"key"];
                
                //            LogInfo(@"Array extended: %@", arrExtend);
                
                for (int y=0;y<(int)[arrExtend count];y++) {
                    
                    NSString *keyExtend = [[arrExtend objectAtIndex:y] objectForKey:@"key"];
                    //                LogInfo(@"Key Extend: %@", keyExtend);
                    
                    if ([keyProduct isEqualToString:keyExtend]) {
                        LogInfo(@"Key found: %@", keyProduct);
                        //                    isExtended = YES;
                        
                        dictExtend = [NSMutableDictionary dictionaryWithDictionary:[arrExtend objectAtIndex:y]];
                    }
                }
                
                //////////////////////////////////////////////////////////////////////////
                BOOL performTest = NO;
                
                if (performTest) {
                    
                    //                if ([priceProduct intValue] == 8890) {
                    //                    markedToRemove = YES;
                    //                }
                    
                    if ([idCell intValue] == 0) {
                        //                    isExtended = YES;
                        priceDivergent = YES;
                        //                    priceDivergentToLow = YES;
                        if ([priceProduct intValue] == 62500) {
                            unavailable = YES;
                        }
                        currentMaxQuantityBySellerAndSku = @"9";
                    }
                    
                    if ([idCell intValue] == 1) {
                        //                    isExtended = YES;
                        //                    priceDivergent = NO;
                        priceDivergentToLow = YES;
                        //                    unavailable = YES;
                        currentMaxQuantityBySellerAndSku = @"9";
                    }
                    
                }
                
                BOOL quantityAvailable = YES;
                if ([quantityProduct intValue] > [currentMaxQuantityBySellerAndSku intValue]) {
                    
                    quantityAvailable = NO;
                }
                
                if (!pathImgProduct) {
                    pathImgProduct = @"0";
                }
                
                BOOL errorRoute = NO;
                BOOL errorGeneralBySeller = NO;
                BOOL errorGeneralCartLevel = NO;
                BOOL couponNotAllowed = NO;
                
                if (withError && [sellerIdProduct isEqualToString:[seller objectAtIndex:0]]) {
                    if ([errorCode isEqualToString:@"COUPON_NOT_ALLOWED"]) {
                        couponNotAllowed = YES;
                    }
                    else if ([errorCode isEqualToString:@"PRODUCT_UNAVAILABLE"]) {
                        unavailable = YES;
                    }
                    else if ([errorCode isEqualToString:@"DELIVERY_NOT_POSSIBLE"]) {
                        errorRoute = YES;
                    }
                    else if ([typeError isEqualToString:@"CART_LEVEL"]) {
                        errorGeneralBySeller = YES;
                    }
                    else if ([typeError isEqualToString:@"ITEM_LEVEL"]) {
                        errorGeneralCartLevel = YES;
                    }
                    else {
                        errorGeneralCartLevel = YES;
                    }
                }
                
                //////////////////////////////////////////////////////////////////////////
                
                dictProd = @{@"currentMaxQuantityBySellerAndSku"    : currentMaxQuantityBySellerAndSku,
                             @"description"                         : descriptionProduct,
                             @"errorGeneralBySeller"                : [NSString stringWithFormat:@"%i", errorGeneralBySeller],
                             @"errorRoute"                          : [NSString stringWithFormat:@"%i", errorRoute],
                             @"errorCartLevel"                      : [NSString stringWithFormat:@"%i", errorGeneralCartLevel],
                             @"extendWarranty"                      : dictExtend,
                             @"idCell"                              : idCell,
                             @"imageUrl"                            : pathImgProduct,
                             @"isExtend"                            : [NSString stringWithFormat:@"%i", isExtended],
                             @"key"                                 : keyProduct,
                             @"listPrice"                           : listPriceProduct,
                             @"markedToRemove"                      : [NSString stringWithFormat:@"%i", markedToRemove],
                             @"price"                               : priceProduct,
                             @"priceDivergent"                      : [NSString stringWithFormat:@"%i", priceDivergent],
                             @"priceDivergentToLow"                 : [NSString stringWithFormat:@"%i", priceDivergentToLow],
                             @"productId"                           : idProduct,
                             @"quantity"                            : quantityProduct,
                             @"quantityAvailable"                   : [NSString stringWithFormat:@"%i", quantityAvailable],
                             @"sellerId"                            : sellerIdProduct,
                             @"sellerName"                          : sellerNameProduct,
                             @"sku"                                 : skuProduct,
                             @"unavailableProduct"                  : [NSString stringWithFormat:@"%i", unavailable],
                             @"departmentId"                        : departmentId,
                             @"categoryId"                          : categoryId,
                             @"subCategoryId"                       : subCategoryId,
                             @"couponNotAllowed"                    : @(couponNotAllowed)};
                
                [arrProd addObject:dictProd];
                
                LogInfo(@"Arr Prod (simple): %@", arrProd);
            }
            else {
                
                LogInfo(@"Is Extend!");
                LogInfo(@"Arr Elements: %@", arrElements);
                
                NSDictionary *warrantyDict = [arrElements objectAtIndex:m];
                
                NSString *keyProduct = [warrantyDict objectForKey:@"key"];
                NSString *priceProduct  = [warrantyDict objectForKey:@"price"];
//                NSString *warrantyDescription = [warrantyDict objectForKey:@"itemDescription"];
                NSString *warrantyDescription = [warrantyDict objectForKey:@"productName"] ?: @"";
                NSNumber *departmentId = [warrantyDict objectForKey:@"departmentId"] ?: @"";
                NSNumber *categoryId = [warrantyDict objectForKey:@"categoryId"] ?: @"";
                NSNumber *subCategoryId = [warrantyDict objectForKey:@"subCategoryId"] ?: @"";
                
                NSString *warrantyType = @"";
                if ([[arrElements objectAtIndex:m] objectForKey:@"warrantyType"]) {
                    warrantyType = [[arrElements objectAtIndex:m] objectForKey:@"warrantyType"];
                }
                
                BOOL isExtend = YES;
                BOOL quantityAvailable = YES;
                BOOL errorRoute = NO;
                BOOL errorGeneralBySeller = NO;
                
                dictProd = @{@"key"                 :   keyProduct,
                             @"sellerId"            :   sellerIdProduct,
                             @"warrantyType"        :   warrantyType,
                             @"sku"                 :   skuProduct,
                             @"description"         :   descriptionProduct,
                             @"warrantyDescription" :   warrantyDescription,
                             @"quantity"            :   quantityProduct,
                             @"price"               :   priceProduct,
                             @"listPrice"           :   listPriceProduct,
                             @"imageUrl"            :   pathImgProduct,
                             @"unavailableProduct"  :   [NSString stringWithFormat:@"%i", unavailable],
                             @"markedToRemove"      :   [NSString stringWithFormat:@"%i", markedToRemove],
                             @"sellerName"          :   sellerNameProduct,
                             @"productId"           :   idProduct,
                             @"isExtend"            :   [NSString stringWithFormat:@"%i", isExtend],
                             @"extendWarranty"      :   dictExtend,
                             @"priceDivergent"      :   warrantyDict[@"priceDivergent"] ?: @0,
                             @"priceDivergentToLow" :   warrantyDict[@"priceDivergentToLow"] ?: @0,
                             @"priceDivergentToHigh":   warrantyDict[@"priceDivergentToHigh"] ?: @0,
                             @"idCell"              :   idCell,
                             @"currentMaxQuantityBySellerAndSku"    :   currentMaxQuantityBySellerAndSku,
                             @"quantityAvailable"   :   [NSString stringWithFormat:@"%i", quantityAvailable],
                             @"errorRoute"          :   [NSString stringWithFormat:@"%i", errorRoute],
                             @"errorGeneralBySeller"          :   [NSString stringWithFormat:@"%i", errorGeneralBySeller],
                             @"departmentId"                        :   departmentId,
                             @"categoryId"                          :   categoryId,
                             @"subCategoryId"                       :   subCategoryId
                             };
                
                [arrProd addObject:dictProd];
                
                LogInfo(@"Arr Prod (extend): %@", arrProd);
            }
        }
        
        NSString *idCart = [jsonObjects valueForKey:@"id"];
        NSString *discountsAmount = [jsonObjects valueForKey:@"discountsAmount"];
        NSString *subTotalPrice = [jsonObjects valueForKey:@"subtotal"];
        NSString *totalPriceCart = [jsonObjects valueForKey:@"totalPrice"];
        //    NSString *totalPriceCartBestShipping = [jsonObjects valueForKey:@"totalPriceWithEstimatedBestShipping"];
        
        NSDictionary *dictAmounts = [jsonObjects valueForKey:@"amounts"];
        NSString *discountAll = [dictAmounts objectForKey:@"totalNominalDiscount"];
        
        NSString *freightAmount = [dictAmounts objectForKey:@"deliveriesAmount"];
        NSString *estimatedBestShippingAmount = [dictAmounts objectForKey:@"estimatedBestShippingAmount"];
        
        NSString *totalAmountWithEstimatedBestShippingPlusGiftCardDiscountAmount = [dictAmounts valueForKey:@"totalAmountWithEstimatedBestShippingPlusGiftCardDiscountAmount"];
        
        NSString *productsAmount = [dictAmounts objectForKey:@"productsAmount"];
        NSString *servicesAmount = [dictAmounts objectForKey:@"servicesAmount"];
        
        NSString *postalCode = @"";
        //Verify if postalCode is present
        if ([[jsonObjects allKeys] containsObject:@"postalCode"]) {
            postalCode = [jsonObjects valueForKey:@"postalCode"];
        }
        
        NSString *loggerKey = @"";
        if ([[jsonObjects allKeys] containsObject:@"loggerKey"]) {
            loggerKey = [jsonObjects valueForKey:@"loggerKey"];
        }
        
        NSDictionary *installment = [jsonObjects objectForKey:@"bestInstallment"];
        NSNumber *valuePerInstallment = [NSNumber numberWithFloat:[[installment objectForKey:@"valuePerInstallment"] floatValue]];
        NSNumber *installmentAmount = [NSNumber numberWithFloat:[[installment objectForKey:@"installmentAmount"] floatValue]];
        
        NSMutableDictionary *dictCart = @{@"idCart"                        : idCart,
                                          @"postalCode"                    : postalCode,
                                          @"products"                      : arrProd,
                                          @"discountsAmount"               : discountsAmount,
                                          @"subtotal"                      : subTotalPrice,
                                          @"totalPrice"                    : totalPriceCart,
                                          @"totalAmountWithEstimatedBestShippingPlusGiftCardDiscountAmount"  :   totalAmountWithEstimatedBestShippingPlusGiftCardDiscountAmount,
                                          @"totalAmountPlusGiftCardDiscountAmount" :   [dictAmounts objectForKey:@"totalAmountPlusGiftCardDiscountAmount"],
                                          @"totalNominalDiscount"  :   discountAll,
                                          @"deliveriesAmount"              : freightAmount,
                                          @"estimatedBestShippingAmount"   : estimatedBestShippingAmount,
                                          @"valuePerInstallment"           : valuePerInstallment,
                                          @"installmentAmount"             : installmentAmount,
                                          @"productsAmount"                : productsAmount,
                                          @"loggerKey"                     : loggerKey,
                                          @"servicesAmount"                : servicesAmount}.mutableCopy;
        
        for (NSString *key in jsonObjects.allKeys) {
            if (dictCart[key] == nil) {
                dictCart[key] = jsonObjects[key];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self delegate] parsedNewCart:dictCart.copy];
        });
    }
    else {
        
        //Old method
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self OLDparseNewCart:cart withError:withError andSeller:seller andTypeError:typeError andErrorCode:errorCode];
        });
    }
    
}



- (void) OLDparseNewCart:(NSString *) cart withError:(BOOL) withError andSeller:(NSArray *) seller  andTypeError:(NSString *) typeError andErrorCode:(NSString *) errorCode {
    
    LogNewCheck(@"With Error: %i | Seller: %@ | Type error: %@ | Error Code: %@", withError, seller, typeError, errorCode);
    
    //    LogInfo(@"Parse Cart: %@", cart);
    
    NSError *error = nil;
    NSData *jsonData = [cart dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    //Json Parse
    //    NSArray *keys = [jsonObjects allKeys];
    //    LogInfo(@"Keys New Cart: %@", keys);
    
    //Categories
    NSArray *arrElements = [jsonObjects valueForKey:@"items"];
    //    LogInfo(@"Dict Cart [%i]: %@", (int)[arrElements count], arrElements);
    
    //Verify by extended warranty - Separating array
    NSMutableArray *arrExtend = [NSMutableArray array];
    //Separating product elements
    NSMutableArray *arrProd = [NSMutableArray array];
    NSDictionary *dictProd;
    
    for (int k=0;k<(int)[arrElements count];k++) {
        
        if ([[[arrElements objectAtIndex:k] objectForKey:@"type"] isEqualToString:keyWarrantyName]) {
            
            NSString *keyProduct = [[arrElements objectAtIndex:k] objectForKey:@"key"];
            NSString *sellerIdProduct = [[arrElements objectAtIndex:k] objectForKey:@"sellerId"];
            NSString *skuProduct = [[arrElements objectAtIndex:k] objectForKey:@"sku"];
            NSString *descriptionProduct = [[arrElements objectAtIndex:k] objectForKey:@"description"];
            NSString *priceProduct = priceProduct = [[arrElements objectAtIndex:k] objectForKey:@"price"];
            NSString *quantityProduct = [[arrElements objectAtIndex:k] objectForKey:@"quantity"];
            NSString *serviceIdProduct = [[arrElements objectAtIndex:k] objectForKey:@"serviceId"];
            BOOL unavailable = [[[arrElements objectAtIndex:k] objectForKey:@"itemUnavailable"] boolValue];
            
            NSDictionary *dictExt = @{@"key"                :   keyProduct,
                                      @"sellerId"           :   sellerIdProduct,
                                      @"sku"                :   skuProduct,
                                      @"description"        :   descriptionProduct,
                                      @"quantity"           :   quantityProduct,
                                      @"price"              :   priceProduct,
                                      @"unavailableProduct" :   [NSString stringWithFormat:@"%i", unavailable],
                                      @"serviceId"          :   serviceIdProduct,
                                      };
            [arrExtend addObject:dictExt];
        }
    }
    
    //Comparing products in cart with extended
    //    LogInfo(@"ArrExtend: %@", arrExtend);
    
    NSString *pathImgProduct = @"";
    NSString *listPriceProduct = @"";
    NSString *idProduct = @"";
    BOOL unavailable = NO;
    BOOL markedToRemove = NO;
    NSString *sellerNameProduct = @"";
    NSMutableDictionary *dictExtend;
    
    BOOL priceDivergent = NO;
    BOOL priceDivergentToLow = NO;
    
    for (int m=0;m<(int)[arrElements count];m++) {
        
        NSString *sellerIdProduct = [[arrElements objectAtIndex:m] objectForKey:@"sellerId"];
        NSString *skuProduct = [[arrElements objectAtIndex:m] objectForKey:@"sku"];
        NSString *descriptionProduct = [[arrElements objectAtIndex:m] objectForKey:@"description"];
        NSString *priceProduct = priceProduct = [[arrElements objectAtIndex:m] objectForKey:@"price"];
        NSString *quantityProduct = [[arrElements objectAtIndex:m] objectForKey:@"quantity"];
        NSString *idCell = [NSString stringWithFormat:@"%i", m];
        
        //Verify if exist key stockbalance
        NSString *currentMaxQuantityBySellerAndSku = @"10";
        
        if ([[arrElements objectAtIndex:m] objectForKey:@"stockBalance"]) {
            
            currentMaxQuantityBySellerAndSku = [[arrElements objectAtIndex:m] objectForKey:@"stockBalance"];
        }
        
        LogNewCheck(@"current Max QuantityBySellerAndSku: %@", currentMaxQuantityBySellerAndSku);
        
        //Ignore extended warranty products
        if (![[[arrElements objectAtIndex:m] objectForKey:@"type"] isEqualToString:keyWarrantyName]) {
            
            pathImgProduct = [[arrElements objectAtIndex:m] objectForKey:@"imageUrl"];
            LogNewCheck(@"Path Img: %@", pathImgProduct);
            
            listPriceProduct = [[arrElements objectAtIndex:m] objectForKey:@"listPrice"];
            LogNewCheck(@"List Price: %@", listPriceProduct);
            
            idProduct = [[arrElements objectAtIndex:m] objectForKey:@"productId"];
            unavailable = [[[arrElements objectAtIndex:m] objectForKey:@"unavailableProduct"] boolValue];
            markedToRemove = [[[arrElements objectAtIndex:m] objectForKey:@"markedToRemove"] boolValue];
            sellerNameProduct = [[arrElements objectAtIndex:m] objectForKey:@"sellerName"];
            priceDivergent = [[[arrElements objectAtIndex:m] objectForKey:@"priceDivergent"] boolValue];
            priceDivergentToLow = [[[arrElements objectAtIndex:m] objectForKey:@"priceDivergentToLow"] boolValue];
            
            BOOL isExtended = NO;
            
            NSDictionary *dictTemp = @{@"": @""};
            
            dictExtend = [NSMutableDictionary dictionaryWithDictionary:dictTemp];
            
            NSString *keyProduct = [[arrElements objectAtIndex:m] objectForKey:@"key"];
            
            //            LogInfo(@"Array extended: %@", arrExtend);
            
            for (int y=0;y<(int)[arrExtend count];y++) {
                
                NSString *keyExtend = [[arrExtend objectAtIndex:y] objectForKey:@"key"];
                //                LogInfo(@"Key Extend: %@", keyExtend);
                
                if ([keyProduct isEqualToString:keyExtend]) {
                    LogInfo(@"Key found: %@", keyProduct);
                    isExtended = YES;
                    
                    dictExtend = [NSMutableDictionary dictionaryWithDictionary:[arrExtend objectAtIndex:y]];
                }
            }
            
            //////////////////////////////////////////////////////////////////////////
            BOOL performTest = NO;
            
            if (performTest) {
                
                //                if ([priceProduct intValue] == 8890) {
                //                    markedToRemove = YES;
                //                }
                
                if ([idCell intValue] == 0) {
                    //                    isExtended = YES;
                    priceDivergent = YES;
                    //                    priceDivergentToLow = YES;
                    if ([priceProduct intValue] == 62500) {
                        unavailable = YES;
                    }
                    currentMaxQuantityBySellerAndSku = @"9";
                }
                
                if ([idCell intValue] == 1) {
                    //                    isExtended = YES;
                    //                    priceDivergent = NO;
                    priceDivergentToLow = YES;
                    //                    unavailable = YES;
                    currentMaxQuantityBySellerAndSku = @"9";
                }
                
            }
            
            BOOL quantityAvailable = YES;
            if ([quantityProduct intValue] > [currentMaxQuantityBySellerAndSku intValue]) {
                
                quantityAvailable = NO;
            }
            
            if (!pathImgProduct) {
                pathImgProduct = @"0";
            }
            
//            BOOL errorRoute = NO;
//            BOOL errorGeneralBySeller = NO;
//            
//            if (withError && [sellerIdProduct isEqualToString:[seller objectAtIndex:0]]) {
//                
//                if ([errorCode isEqualToString:@"PRODUCT_UNAVAILABLE"]) {
//                    unavailable = YES;
//                }
//                else if ([typeError isEqualToString:@"CART_LEVEL"]) {
//                    
//                    errorGeneralBySeller = YES;
//                }
//                else {
//                    
//                    errorRoute = YES;
//                }
            
            BOOL errorRoute = NO;
            BOOL errorGeneralBySeller = NO;
            BOOL errorGeneralCartLevel = NO;
            
            if (withError && [sellerIdProduct isEqualToString:[seller objectAtIndex:0]]) {
                
                if ([errorCode isEqualToString:@"PRODUCT_UNAVAILABLE"]) {
                    unavailable = YES;
                }
                else if ([errorCode isEqualToString:@"DELIVERY_NOT_POSSIBLE"]) {
                    errorRoute = YES;
                }
                else if ([typeError isEqualToString:@"CART_LEVEL"]) {
                    
                    errorGeneralBySeller = YES;
                }
                else if ([typeError isEqualToString:@"ITEM_LEVEL"]) {
                    errorGeneralCartLevel = YES;
                }
                else {
                    errorGeneralCartLevel = YES;
                }
            }
            
            //////////////////////////////////////////////////////////////////////////
            
            dictProd = @{@"key"                 :   keyProduct,
                         @"sellerId"            :   sellerIdProduct,
                         @"sku"                 :   skuProduct,
                         @"description"         :   descriptionProduct,
                         @"quantity"            :   quantityProduct,
                         @"price"               :   priceProduct,
                         @"listPrice"           :   listPriceProduct,
                         @"imageUrl"            :   pathImgProduct,
                         @"unavailableProduct"  :   [NSString stringWithFormat:@"%i", unavailable],
                         @"markedToRemove"      :   [NSString stringWithFormat:@"%i", markedToRemove],
                         @"sellerName"          :   sellerNameProduct,
                         @"productId"           :   idProduct,
                         @"isExtend"            :   [NSString stringWithFormat:@"%i", isExtended],
                         @"extendWarranty"      :   dictExtend ?: @{},
                         @"priceDivergent"      :   [NSString stringWithFormat:@"%i", priceDivergent],
                         @"priceDivergentToLow" :   [NSString stringWithFormat:@"%i", priceDivergentToLow],
                         @"idCell"              :   idCell,
                         @"currentMaxQuantityBySellerAndSku"    :   currentMaxQuantityBySellerAndSku,
                         @"quantityAvailable"   :   [NSString stringWithFormat:@"%i", quantityAvailable],
                         @"errorRoute"          :   [NSString stringWithFormat:@"%i", errorRoute],
                         @"errorGeneralBySeller"          :   [NSString stringWithFormat:@"%i", errorGeneralBySeller],
                         @"errorCartLevel"                      :   [NSString stringWithFormat:@"%i", errorGeneralCartLevel],
                         };
            
            [arrProd addObject:dictProd];
            
            LogInfo(@"Arr Prod: %@", arrProd);
        }
    }
    
    //This entry is used to help populate "shipping value" and "Choose more products" in Cart
    NSDictionary *dictOthers = @{@"":@""};
    [arrProd addObject:dictOthers];
    ////////////////////////////////////////
    
    NSString *idCart = [jsonObjects valueForKey:@"id"];
    NSString *discountsAmount = [jsonObjects valueForKey:@"discountsAmount"];
    NSString *subTotalPrice = [jsonObjects valueForKey:@"subtotal"];
    NSString *totalPriceCart = [jsonObjects valueForKey:@"totalPrice"];
    //    NSString *totalPriceCartBestShipping = [jsonObjects valueForKey:@"totalPriceWithEstimatedBestShipping"];
    
    NSDictionary *dictAmounts = [jsonObjects valueForKey:@"amounts"];
    NSString *discountAll = [dictAmounts objectForKey:@"totalNominalDiscount"];
    
    NSString *freightAmount = [dictAmounts objectForKey:@"deliveriesAmount"];
    NSString *estimatedBestShippingAmount = [dictAmounts objectForKey:@"estimatedBestShippingAmount"];
    
    NSString *totalAmountWithEstimatedBestShippingPlusGiftCardDiscountAmount = [dictAmounts valueForKey:@"totalAmountWithEstimatedBestShippingPlusGiftCardDiscountAmount"];
    
    NSString *postalCode = @"";
    //Verify if postalCode is present
    if ([[jsonObjects allKeys] containsObject:@"postalCode"]) {
        postalCode = [jsonObjects valueForKey:@"postalCode"];
    }
    
    NSDictionary *dictCart = @{@"idCart"                        : idCart,
                               @"postalCode"                    : postalCode,
                               @"products"                      : arrProd,
                               @"discountsAmount"               : discountsAmount,
                               @"subtotal"                      : subTotalPrice,
                               @"totalPrice"                    : totalPriceCart,
                               @"totalAmountWithEstimatedBestShippingPlusGiftCardDiscountAmount"  :   totalAmountWithEstimatedBestShippingPlusGiftCardDiscountAmount,
                               @"totalAmountPlusGiftCardDiscountAmount" :   [dictAmounts objectForKey:@"totalAmountPlusGiftCardDiscountAmount"],
                               @"totalNominalDiscount"  :   discountAll,
                               @"deliveriesAmount"              : freightAmount,
                               @"estimatedBestShippingAmount"   : estimatedBestShippingAmount
                               };
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self delegate] parsedNewCart:dictCart];
    });
}

#pragma mark - Errors
+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message
{
    return [NSError errorWithDomain:@"Walmart.Menu" code:code userInfo:@{NSLocalizedDescriptionKey : message}];
}

+ (NSDictionary *)dictionaryFromJSONFileWithName:(NSString *)fileName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSString *fileStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData *fileData = [fileStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingAllowFragments error:&error];
    return dictionary;
}

+ (NSArray *)arrayFromJSONFileWithName:(NSString *)fileName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSString *fileStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData *fileData = [fileStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingAllowFragments error:&error];
    return array;
}

@end
