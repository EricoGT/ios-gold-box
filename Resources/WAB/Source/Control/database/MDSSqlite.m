//
//  MDSSqlite.m
//  VcTube
//
//  Created by Marcelo Santos on 20/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved. 
//

#import "MDSSqlite.h"

@interface MDSSqlite ()

@property (strong, nonatomic) NSString *dbModelname; // name of model database
@property (assign, nonatomic) sqlite3 *database; // database object

@property (assign, nonatomic)  BOOL isFirstTime;

@end

@implementation MDSSqlite

@synthesize dbpath, delegate;

- (void) assignDBPath {
    
    // set up for app
    self.dbModelname = @"wmofertas.sqlite";
    
    // get full path of database in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
}


- (BOOL) verifyDBExists {
    
    // set up for app
    self.dbModelname = @"wmofertas.sqlite";
    
    // get full path of database in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.dbpath];
    LogMob(@"Exists DB? (%@)", [NSString stringWithFormat:@"%i", fileExists]);
    
    // location in resource bundle
    NSString *appPath = [[[NSBundle mainBundle] resourcePath] 
                         stringByAppendingPathComponent:_dbModelname];
    
    if (!fileExists) {
        LogMob(@"Copiando arquivo de db pela primeira vez");
        
        self.isFirstTime = YES;
        
        // copy from resource to where it should be
        NSError *error;
        NSFileManager *fm = [NSFileManager defaultManager]; // file manager
        [fm copyItemAtPath:appPath toPath:self.dbpath error:&error];
        
        [self verifyTables];
        
        return NO;
    }
    else {
        
        [self verifyTables];
        
        return YES;
    }
}

- (void) verifyTables {
    
    BOOL tableTokAuth= [self verifyByTable:@"tkOAuth"];
    LogInfo(@"Tables tkOAuth ok: %i", tableTokAuth);
    
    if (!tableTokAuth) {
        
        [self addTable:@"tkOAuth"];
    }
    
    BOOL tableTokCheck= [self verifyByTable:@"tkCheck"];
    LogInfo(@"Tables tkCheck ok: %i", tableTokCheck);
    
    if (!tableTokCheck) {
        
        [self addTable:@"tkCheck"];
    }
    
    BOOL tableCartId= [self verifyByTable:@"cartId"];
    LogInfo(@"Tables cartId ok: %i", tableCartId);
    
    if (!tableCartId) {
        
        [self addTable:@"cartId"];
    }
    
    BOOL tableLogs= [self verifyByTable:@"logs"];
    LogInfo(@"Tables Logs ok: %i", tableLogs);
    
    if (!tableLogs) {
        [self addTableLogsWithColumns];
    }
    else {
        
        //Verify by column payload. If exist, then update DB, because payload is not valid
        LogInfo(@"Old DB: %i", [self checkColumn:@"payload"]);
        if ([self checkColumn:@"payload"]) {
            
            [self deleteTable:@"logs"];
            [self addTableLogsWithColumns];
        }
    }
}

- (BOOL) deleteTable:(NSString *) table {
    
        sqlite3 *dbase;
        
        BOOL isOk = NO;
        
        [self assignDBPath];
        
        NSString *sqlString = [NSString stringWithFormat:@"DROP TABLE %@", table];
        
        const char *sqlStr = [sqlString UTF8String];
        
        // Open the database from the users filessytem
        if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
            
            // Setup the SQL Statement and compile it for faster access
            const char *sqlStatement = sqlStr;
            sqlite3_stmt *compiledStatement;
            if(sqlite3_prepare_v2(dbase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
                // Loop through the results and add them to the feeds array
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    
                    isOk = YES;
                }
            } else {
                
                isOk = NO;
            }
            // Release the compiled statement from memory
            sqlite3_finalize(compiledStatement);
            
        }
        sqlite3_close(dbase);
        
        return isOk;
}


- (BOOL) checkColumn:(NSString *) columnSearch {
    
    sqlite3 *dbase;
    
    BOOL isOk = NO;
    
    [self assignDBPath];
    
    NSString *sqlString = [NSString stringWithFormat:@"select %@ from logs", columnSearch];
    
    const char *sqlStr = [sqlString UTF8String];
    
    // Open the database from the users filessytem
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        // Setup the SQL Statement and compile it for faster access
        const char *sqlStatement = sqlStr;
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(dbase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                isOk = YES;
            }
        } else {
            
            isOk = NO;
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(dbase);
    
    return isOk;
}


- (void) addTableLogsWithColumns
{
    sqlite3 *dbase;
    
    int ret = 0;
    
    NSString *charString2 = @"CREATE  TABLE 'main'.'logs' ('deviceId' TEXT, 'date' TEXT, 'errorEvent' TEXT, 'requestUrl' TEXT, 'requestData' TEXT, 'responseCode' TEXT, 'responseData' TEXT, 'userMessage' TEXT, 'system' TEXT, 'version' TEXT, 'email' TEXT, 'screen' TEXT, 'fragment' TEXT)";
    
    const char *sql2 = [charString2 UTF8String];
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql2, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
        }
        
        sqlite3_finalize(preparedStatement);
    }
    
    sqlite3_close(dbase);
}


- (void) addTable:(NSString *) tab {
    
    sqlite3 *dbase;
    
    int ret = 0;
    
    NSString *charString2 = [NSString stringWithFormat:@"CREATE  TABLE 'main'.'%@' ('tok' TEXT)", tab];
    
    const char *sql2 = [charString2 UTF8String];
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql2, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
        }
        
        sqlite3_finalize(preparedStatement);
    }
    
    sqlite3_close(dbase);
}



- (void) addColumn1 {
    
    sqlite3 *dbase;
    
    int ret = 0;
    
    NSString *charString2 = [NSString stringWithFormat:@"ALTER TABLE 'main'.'skin' ADD COLUMN 'cartBgPressedColor' TEXT"];
    
    const char *sql2 = [charString2 UTF8String];
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql2, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
        }
        
        sqlite3_finalize(preparedStatement);
    }
    
    sqlite3_close(dbase);
}

- (void) addColumn2 {
    
    sqlite3 *dbase;
    
    int ret = 0;
    
    NSString *charString3 = [NSString stringWithFormat:@"ALTER TABLE 'main'.'skin' ADD COLUMN 'btnBgColor' TEXT"];
    
    const char *sql3 = [charString3 UTF8String];
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql3, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
        }
        
        sqlite3_finalize(preparedStatement);
    }
    
    sqlite3_close(dbase);
}

- (void) addColumn3 {
    
    sqlite3 *dbase;
    
    int ret = 0;
    
    NSString *charString4 = [NSString stringWithFormat:@"ALTER TABLE 'main'.'skin' ADD COLUMN 'btnBgPressedColor' TEXT"];
    
    const char *sql4 = [charString4 UTF8String];
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql4, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
        }
        
        sqlite3_finalize(preparedStatement);
    }
    
    sqlite3_close(dbase);
}

- (void) testInjectProducts {
    
    LogInfo(@"Injecting Products in DB");
    
    NSDictionary *dictProduct1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"100213956", @"idProduct", @"375874", @"standardSku", @"375874", @"sku", @"https://www.walmart.com.br/arquivos/ids/4586655", @"imgProduct", @"Smartphone Samsung Galaxy S4 4G I9505 Branco, Processador Quad Core 1.9 Ghz, Android 4.2, Wi -Fi, GPS, Câmera 13.0 MP, Mp3, Memória 16 GB", @"descProduct", @"1", @"qtyProduct", @"YES", @"extendProduct", @"211,90", @"extendedValue", @"2299,00", @"valueProduct", @"8", @"savePercentage", @"12", @"extendTime", nil];
    
    NSDictionary *dictProduct2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"100210403", @"idProduct", @"371149", @"standardSku", @"371149", @"sku", @"https://www.walmart.com.br/arquivos/ids/4263021", @"imgProduct", @"Gradiente iPhone Neo One GC 500SF Branco, Dual Chip, Android 2.3, 3G, GPS, Wi-Fi, Câmera 5.0MP, MP3 Player, Fone de Ouvido, Cartão de 2GB", @"descProduct", @"1", @"qtyProduct", @"NO", @"extendProduct", @"0,00", @"extendedValue", @"599,00", @"valueProduct", @"0", @"savePercentage", @"0", @"extendTime", nil];
    
    NSArray *arrProducts = [NSArray arrayWithObjects:dictProduct1, dictProduct2, nil];
    
    for (int i=0;i<[arrProducts count];i++) {
        
        [self addProductInCart:[arrProducts objectAtIndex:i]];
    }
    
    [self getCart];
}


- (void) updateSplashId:(NSString *) splashId andImgName:(NSString *) imgName andRatio:(NSString *) ratio andBgColor:(NSArray *) bgcolor {
    
    [self assignDBPath];
    
    // set up for app
    self.dbModelname = @"wmofertas.sqlite";
    
    // get full path of database in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
    
    sqlite3 *dbase;
    
    int ret = 0;
    
    //Separating colors
    NSString *rcolor = [bgcolor objectAtIndex:0];
    NSString *bcolor = [bgcolor objectAtIndex:1];
    NSString *gcolor = [bgcolor objectAtIndex:2];
    NSString *acolor = [bgcolor objectAtIndex:3];
    
    NSString *charString = [NSString stringWithFormat:@"UPDATE splash SET image='%@', ratio='%@', rcolor='%@', bcolor='%@', gcolor='%@', acolor='%@' WHERE splashid = '%@'", imgName, ratio, rcolor, gcolor, bcolor, acolor, splashId];
    
    const char *sql = [charString UTF8String];
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
            [[self delegate] errorDatabase];
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
            [[self delegate] errorDatabase];
        }
        
        sqlite3_finalize(preparedStatement);
    }
    LogMob(@"Added Splash ok!");
    
    [[self delegate] finishedOperationDatabaseSplash:splashId];
    
    sqlite3_close(dbase);
}

- (NSArray *) getSplashAllDataFromId:(NSString *) splashId {
    
    NSArray *content = [self getContentDBSplash:[NSString stringWithFormat:@"select * from splash where splashid='%@'", splashId]];
    LogMob(@"Splash get [%@]: %@", splashId, content);
    
    return content;
}

- (NSArray *) getSkinAllDataFromId:(NSString *) skinName {
    
    NSArray *content = [self getContentDBSkin:[NSString stringWithFormat:@"select * from skin where name='%@'", skinName]];
    LogMob(@"Skin get [%@]: %@", skinName, content);
    
    return content;
}

- (NSArray *) getCart {
    
    sqlite3 *dbase;
    
    [self assignDBPath];
    
    NSString *sqlString = @"select * from cart";
    
    const char *sqlStr = [sqlString UTF8String];
    
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
    
    // Open the database from the users filessytem
	if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        //		const char *sqlStatement = "select * from canais";
        const char *sqlStatement = sqlStr;
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(dbase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                // Read the data from the result row
                char *column1 = (char *)sqlite3_column_text(compiledStatement, 1);
                
                if (column1 != NULL) {
                    
                    NSString *sku = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]; //Coluna 0
                    NSString *standardSku = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]; //Coluna 1
                    NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)]; //Coluna 2
                    NSString *quantity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]; //Coluna 3
                    NSString *value_product = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)]; //Coluna 4
                    NSString *save_percentage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)]; //Coluna 5
                    NSString *thumb = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)]; //Coluna 6
                    NSString *extended = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)]; //Coluna 7
                    NSString *extended_value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)]; //Coluna 8
                    NSString *id_product = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)]; //Coluna 9
                    NSString *extend_time = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)]; //Coluna 10
                    NSString *extend_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)]; //Coluna 11
                
                    NSDictionary *dictTemp = [[NSDictionary alloc] initWithObjectsAndKeys:id_product, @"idProduct", standardSku, @"standardSku", sku, @"sku", thumb, @"imgProduct", description, @"descProduct", quantity, @"qtyProduct", extended, @"extendProduct", extended_value, @"extendedValue", value_product, @"valueProduct", save_percentage, @"savePercentage", extend_time, @"extendTime", extend_id, @"extendId", nil];
                    
                    [arrTemp addObject:dictTemp];
                    
                } else {
                    LogErro(@"Cart: no values");
                    [arrTemp addObject:@""];
                }
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(dbase);
    
    LogInfo(@"SQLite Cart: %@", arrTemp);
    
    return arrTemp;

}


- (void) addImageName:(NSString *) imgName andSplashId:(NSString *) splashId andRatio:(NSString *) ratio andBgColor:(NSArray *) bgcolor {
    
    [self assignDBPath];
    
    // set up for app
    self.dbModelname = @"wmofertas.sqlite";
    
    // get full path of database in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
    
    sqlite3 *dbase;
    
    int ret = 0;
    
    //Separating colors
    NSString *rcolor = [bgcolor objectAtIndex:0];
    NSString *bcolor = [bgcolor objectAtIndex:1];
    NSString *gcolor = [bgcolor objectAtIndex:2];
    NSString *acolor = [bgcolor objectAtIndex:3];
    
    NSString *charString = [NSString stringWithFormat:@"INSERT INTO splash (splashid,image, ratio, rcolor, bcolor, gcolor, acolor) VALUES ('%@','%@','%@','%@','%@','%@','%@')", splashId, imgName, ratio, rcolor, bcolor, gcolor, acolor];
    
    const char *sql = [charString UTF8String];
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
            [[self delegate] errorDatabase];
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
            [[self delegate] errorDatabase];
        }
        
        sqlite3_finalize(preparedStatement);
    }
    LogMob(@"Added Splash ok!");
    
    [[self delegate] finishedOperationDatabaseSplash:splashId];
    
    sqlite3_close(dbase);
}

- (void) addSkinName:(NSString *) skinName andPriceBarColor:(NSString *) barColor andDescriptionColor:(NSString *) descColor andInstalmentColor:(NSString *) instColor andDiscountColor:(NSString *) discountColor andBaseImageUrl:(NSString *) baseImgUrl andImgIds:(NSString *) imgIds andOrigPriceColor:(NSString *) origPriceColor andBgColor:(NSString *) bgColor andPageControlColor:(NSString *) pageControlColor andHomeBgColor:(NSString *) homeBgColor andCartBgColor:(NSString *) cartBgColor  andPressedBgColor:(NSString *) pressedBgColor andBannerBgColor:(NSString *) bannerBgColor andCartBgPressedColor:(NSString *) cartBgPressedColor andBtnBgColor:(NSString *) btnBgColor {
    
    [self assignDBPath];
    
    // set up for app
    self.dbModelname = @"wmofertas.sqlite";
    
    // get full path of database in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
    
    LogInfo(@"Page Control Color: %@", pageControlColor);
    
    NSString *charString = [NSString stringWithFormat:@"INSERT INTO skin (name, priceBarColor, descriptionColor, instalmentColor, discountColor, baseImgUrl, imgIds, origPriceColor, bgColor, pageControlColor, homeBgColor, cartBgColor, pressedBgColor, bannerBgColor, cartBgPressedColor, btnBgColor) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", skinName, barColor, descColor, instColor, discountColor, baseImgUrl, imgIds, origPriceColor, bgColor, pageControlColor, homeBgColor, cartBgColor, pressedBgColor, bannerBgColor, cartBgPressedColor, btnBgColor];

    
    sqlite3 *dbase;
    
    int ret = 0;
    
    const char *sql = [charString UTF8String];
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
            [[self delegate] errorDatabase];
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
            [[self delegate] errorDatabase];
        }
        
        sqlite3_finalize(preparedStatement);
    }
    LogMob(@"Added Skin ok!");
    
    [[self delegate] finishedOperationDatabaseSkin:skinName];
    
    sqlite3_close(dbase);
}

- (void) updateSkinName:(NSString *) skinName andPriceBarColor:(NSString *) barColor andDescriptionColor:(NSString *) descColor andInstalmentColor:(NSString *) instColor andDiscountColor:(NSString *) discountColor andBaseImageUrl:(NSString *) baseImgUrl andImgIds:(NSString *) imgIds andOrigPriceColor:(NSString *) origPriceColor andBgColor:(NSString *) bgColor andPageControlColor:(NSString *) pageControlColor andHomeBgColor:(NSString *) homeBgColor andCartBgColor:(NSString *) cartBgColor andPressedBgColor:(NSString *) pressedBgColor andBannerBgColor:(NSString *) bannerBgColor andCartBgPressedColor:(NSString *) cartBgPressedColor andBtnBgColor:(NSString *) btnBgColor {
    
    [self assignDBPath];
    
    // set up for app
    self.dbModelname = @"wmofertas.sqlite";
    
    // get full path of database in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
    
    LogInfo(@"Page Control Color: %@", pageControlColor);
    
    NSString *charString = [NSString stringWithFormat:@"UPDATE skin SET name='%@',priceBarColor='%@',descriptionColor='%@',instalmentColor='%@',discountColor='%@',baseImgUrl='%@',imgIds='%@',origPriceColor='%@',bgColor='%@',pageControlColor='%@',homeBgColor='%@',cartBgColor='%@',pressedBgColor='%@',bannerBgColor='%@',cartBgPressedColor='%@',btnBgColor='%@'", skinName, barColor, descColor, instColor, discountColor, baseImgUrl, imgIds, origPriceColor, bgColor, pageControlColor, homeBgColor, cartBgColor, pressedBgColor, bannerBgColor, cartBgPressedColor, btnBgColor];
    
    sqlite3 *dbase;
    
    int ret = 0;
    
    const char *sql = [charString UTF8String];
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
            [[self delegate] errorDatabase];
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
            [[self delegate] errorDatabase];
        }
        
        sqlite3_finalize(preparedStatement);
    }
    LogMob(@"Update Skin ok!");
    
    [[self delegate] finishedOperationDatabaseSkin:skinName];
    
    sqlite3_close(dbase);
}



- (void) addSplashDefaultImageName:(NSString *) imgName andSplashId:(NSString *) splashId andRatio:(NSString *) ratio andBgColor:(NSArray *) bgcolor {
    
    LogInfo(@"Splash default add");
    
    [self assignDBPath];
    
    // set up for app
    self.dbModelname = @"wmofertas.sqlite";
    
    // get full path of database in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
    
    sqlite3 *dbase;
    
    int ret = 0;
    
    //Separating colors
    NSString *rcolor = [bgcolor objectAtIndex:0];
    NSString *bcolor = [bgcolor objectAtIndex:1];
    NSString *gcolor = [bgcolor objectAtIndex:2];
    NSString *acolor = [bgcolor objectAtIndex:3];
    
    NSArray *splashDefault = [self getContentDBSplashDefault:@"SELECT * from splashdefault"];
    LogInfo(@"Splash Default: %@", splashDefault);
    
    NSString *charString = @"";
    
    //Set splashdefault table (allow fast splash in the next call
    if ([splashDefault count] > 0) {
        
        charString = [NSString stringWithFormat:@"UPDATE splashdefault SET image='%@', ratio='%@', rcolor='%@', bcolor='%@', gcolor='%@', acolor='%@' WHERE splashid = '%@'", imgName, ratio, rcolor, gcolor, bcolor, acolor, splashId];
        
    } else {
       charString = [NSString stringWithFormat:@"INSERT INTO splashdefault (splashid,image, ratio, rcolor, bcolor, gcolor, acolor) VALUES ('%@','%@','%@','%@','%@','%@','%@')", splashId, imgName, ratio, rcolor, bcolor, gcolor, acolor]; 
    }

    const char *sql = [charString UTF8String];
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
            [[self delegate] errorDatabase];
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
            [[self delegate] errorDatabase];
        }
        
        sqlite3_finalize(preparedStatement);
    }
    LogInfo(@"Added Splash Default ok!");
    
    sqlite3_close(dbase);
}


- (BOOL) verifySplashId:(NSString *) splashId {
    
    NSArray *content = [self getContentDBSplash:[NSString stringWithFormat:@"select * from splash where splashid='%@'", splashId]];
    LogInfo(@"Content Splash [%@]: %@", splashId, content);
    
    if ([content count] > 0) {
        
        return YES;
    }
    else {
        
        return NO;
    }

}

- (BOOL) verifySkinId:(NSString *) skinId {
    
    NSArray *content = [self getContentDBSkin:[NSString stringWithFormat:@"select * from skin where name='%@'", skinId]];
    LogInfo(@"Verify Skin Id: %@", content);
    
    if ([content count] > 0) {
        
        return YES;
    }
    else {
        LogInfo(@"return NO");
        return NO;
    }
}

- (NSArray *) getContentDBSkin: (NSString *) sqlString {
    
    sqlite3 *dbase;
    
    [self assignDBPath];
    
    const char *sqlStr = [sqlString UTF8String];
    
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
    
    // Open the database from the users filessytem
	if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        //		const char *sqlStatement = "select * from canais";
        const char *sqlStatement = sqlStr;
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(dbase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                // Read the data from the result row
                char *column1 = (char *)sqlite3_column_text(compiledStatement, 1);
                
                if (column1 != NULL) {
                    
                    NSString *nome = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]; //Coluna 0
                    NSString *priceBarColor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]; //Coluna 1
                    NSString *descriptionColor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)]; //Coluna 2
                    NSString *instalmentColor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]; //Coluna 3
                    NSString *discountColor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)]; //Coluna 4
                    NSString *baseImgUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)]; //Coluna 5
                    NSString *imgIds = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)]; //Coluna 6
                    NSString *origPriceColor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)]; //Coluna 7
                    NSString *bgColor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)]; //Coluna 8
                    LogInfo(@"sqlite bgColor: %@", bgColor);
                    NSString *pageControlColor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)]; //Coluna 9
                    NSString *homeBgColor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)]; //Coluna 10
                    NSString *cartBgColor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)]; //Coluna 11
                    NSString *pressedBgColor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)]; //Coluna 12
                    NSString *bannerBgColor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)]; //Coluna 13
                    NSString *cartBgPressedColor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)]; //Coluna 14
                    NSString *btnBgColor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)]; //Coluna 15
                    
                    LogInfo(@"Nome SQLite: %@", nome);
                    
                    [arrTemp addObject:nome];
                    [arrTemp addObject:priceBarColor];
                    [arrTemp addObject:descriptionColor];
                    [arrTemp addObject:instalmentColor];
                    [arrTemp addObject:discountColor];
                    [arrTemp addObject:baseImgUrl];
                    [arrTemp addObject:imgIds];
                    [arrTemp addObject:origPriceColor];
                    [arrTemp addObject:bgColor];
                    [arrTemp addObject:pageControlColor];
                    [arrTemp addObject:homeBgColor];
                    [arrTemp addObject:cartBgColor];
                    [arrTemp addObject:pressedBgColor];
                    [arrTemp addObject:bannerBgColor];
                    [arrTemp addObject:cartBgPressedColor];
                    [arrTemp addObject:btnBgColor];
                    
                } else {
                    LogErro(@"Skin table: no values");
                }
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(dbase);
    
    LogInfo(@"ArrTemp Skin: %@", arrTemp);
    
    return arrTemp;
    
}


- (NSArray *) getContentDBSplash: (NSString *) sqlString {
    
    sqlite3 *dbase;
    
    [self assignDBPath];
    
    const char *sqlStr = [sqlString UTF8String];
    
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
    
    // Open the database from the users filessytem
	if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        //		const char *sqlStatement = "select * from canais";
        const char *sqlStatement = sqlStr;
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(dbase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                // Read the data from the result row
                char *column1 = (char *)sqlite3_column_text(compiledStatement, 1);
                
                if (column1 != NULL) {
                    
                    NSString *splashId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]; //Coluna 0
                    NSString *image = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]; //Coluna 1
                    NSString *ratio = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)]; //Coluna 2
                    NSString *rcolor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]; //Coluna 3
                    NSString *gcolor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)]; //Coluna 4
                    NSString *bcolor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)]; //Coluna 5
                    NSString *acolor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)]; //Coluna 6
                    
                    [arrTemp addObject:splashId];
                    [arrTemp addObject:image];
                    [arrTemp addObject:ratio];
                    [arrTemp addObject:rcolor];
                    [arrTemp addObject:gcolor];
                    [arrTemp addObject:bcolor];
                    [arrTemp addObject:acolor];
                    
                } else {
                    
                   LogErro(@"Splash table: no values"); 
                }
                
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(dbase);
    
    LogInfo(@"ArrTemp Splash: %@", arrTemp);
    
    return arrTemp;
    
}


- (NSArray *) getContentDBSplashDefault: (NSString *) sqlString {
    
    sqlite3 *dbase;
    
    [self assignDBPath];
    
    const char *sqlStr = [sqlString UTF8String];
    
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
    
    // Open the database from the users filessytem
	if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        //		const char *sqlStatement = "select * from canais";
        const char *sqlStatement = sqlStr;
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(dbase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                // Read the data from the result row
                
                NSString *splashId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]; //Coluna 0
				NSString *image = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]; //Coluna 1
                NSString *ratio = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)]; //Coluna 2
                NSString *rcolor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]; //Coluna 3
                NSString *gcolor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)]; //Coluna 4
                NSString *bcolor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)]; //Coluna 5
                NSString *acolor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)]; //Coluna 6
                
                [arrTemp addObject:splashId];
                [arrTemp addObject:image];
                [arrTemp addObject:ratio];
                [arrTemp addObject:rcolor];
                [arrTemp addObject:gcolor];
                [arrTemp addObject:bcolor];
                [arrTemp addObject:acolor];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(dbase);
    
    LogInfo(@"ArrTemp Splash: %@", arrTemp);
    
    return arrTemp;
    
}

#pragma mark LOGS

- (BOOL) addLogsToService:(NSDictionary *) dictLogs {
    
    LogInfo(@"Adding Logs to DB: %@", dictLogs);
    
    self.dbModelname = @"wmofertas.sqlite";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
    LogInfo(@"Path to DB: %@", self.dbpath);
    
    sqlite3 *dbase;
    
    int ret = 0;
    
    NSString *deviceId = [dictLogs objectForKey:@"deviceId"];
    NSString *date = [dictLogs objectForKey:@"date"];
    NSString *errorEvent = [dictLogs objectForKey:@"errorEvent"];
    NSString *requestUrl = [dictLogs objectForKey:@"requestUrl"];
    NSString *requestData = [dictLogs objectForKey:@"requestData"];
    NSString *responseCode = [dictLogs objectForKey:@"responseCode"];
    NSString *responseData = [dictLogs objectForKey:@"responseData"];
    NSString *userMessage = [dictLogs objectForKey:@"userMessage"];
    NSString *system = [dictLogs objectForKey:@"system"];
    NSString *version = [dictLogs objectForKey:@"version"];
    NSString *email = [dictLogs objectForKey:@"email"];
    NSString *screen = [dictLogs objectForKey:@"screen"];
    NSString *fragment = [dictLogs objectForKey:@"fragment"];
    
    NSString *charString = [NSString stringWithFormat:@"INSERT INTO logs (deviceId, date, errorEvent, requestUrl, requestData, responseCode, responseData, userMessage, system, version, email, screen, fragment) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", deviceId, date, errorEvent, requestUrl, requestData, responseCode, responseData, userMessage, system, version, email, screen, fragment];
    
    const char *sql = [charString UTF8String];
    
    BOOL successLogDB = YES;
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
            successLogDB = NO;
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
            successLogDB = NO;
        }
        
        sqlite3_finalize(preparedStatement);
    }
    
    sqlite3_close(dbase);
    
    return successLogDB;
}

- (NSArray *) getAllLogsFromDB {
    
    sqlite3 *dbase;
    
    [self assignDBPath];
    
    NSString *sqlString = @"select * from logs order by rowid desc limit 100";
    const char *sqlStr = [sqlString UTF8String];
    
    NSMutableArray *arrTemp = [NSMutableArray new];
    
    // Open the database from the users filessytem
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        // Setup the SQL Statement and compile it for faster access
        //		const char *sqlStatement = "select * from canais";
        const char *sqlStatement = sqlStr;
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(dbase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                // Read the data from the result row
                char *column1 = (char *)sqlite3_column_text(compiledStatement, 1);
                
                if (column1 != NULL) {
                    
                    NSString *deviceId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] ?: @""; //Coluna 1
                    NSString *date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] ?: @""; //Coluna 2
                    NSString *errorEvent = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] ?: @""; //Coluna 3
                    NSString *requestUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] ?: @""; //Coluna 4
                    NSString *requestData = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)] ?: @""; //Coluna 5
                    NSString *responseCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)] ?: @""; //Coluna 6
                    NSString *responseData = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)] ?: @""; //Coluna 7
                    NSString *userMessage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)] ?: @""; //Coluna 8
                    NSString *system = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)] ?: @""; //Coluna 9
                    NSString *version = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)] ?: @""; //Coluna 10
                    NSString *email = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)] ?: @""; //Coluna 11
                    NSString *screen = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)] ?: @""; //Coluna 12
                    NSString *fragment = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)] ?: @""; //Coluna 13
                    
                    NSDictionary *dictLog = @{@"deviceId"       :   deviceId,
                                              @"date"           :   date,
                                              @"errorEvent"     :   errorEvent,
                                              @"requestUrl"     :   requestUrl,
                                              @"requestData"    :   requestData,
                                              @"responseCode"   :   responseCode,
                                              @"responseData"   :   responseData,
                                              @"userMessage"    :   userMessage,
                                              @"system"         :   system,
                                              @"version"        :   version,
                                              @"email"          :   email,
                                              @"screen"         :   screen,
                                              @"fragment"       :   fragment
                                              };

                    [arrTemp addObject:dictLog];
                    
                } else {
                    
                    LogErro(@"Logs table: no values");
                }
            }
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(dbase);
    
    LogInfo(@"ArrTemp Logs: %@", arrTemp);
    
    return arrTemp;
}

- (void) deleteAllErrorsFromDB {
    [self deleAllContentFromTable:@"logs"];
}

#pragma mark

- (void) addProductInCart:(NSDictionary *) dictProduct {
    
//    [self assignDBPath];
    
    LogInfo(@"Product add: %@", dictProduct);
    
    // set up for app
    self.dbModelname = @"wmofertas.sqlite";
    
    // get full path of database in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
    
    sqlite3 *dbase;
    
    int ret = 0;
    
    NSString *sku = [dictProduct objectForKey:@"sku"];
    NSString *standardSku = [dictProduct objectForKey:@"standardSku"];
    NSString *description = [dictProduct objectForKey:@"descProduct"];
    NSString *qty = [dictProduct objectForKey:@"qtyProduct"];
    NSString *valueProduct = [dictProduct objectForKey:@"valueProduct"];
    NSString *savePercentage = [dictProduct objectForKey:@"savePercentage"];
    NSString *thumb = [dictProduct objectForKey:@"imgProduct"];
    NSString *extended = [dictProduct objectForKey:@"extendProduct"];
    NSString *extendedValue = [dictProduct objectForKey:@"extendedValue"];
    NSString *extendTime = [dictProduct objectForKey:@"extendTime"];
    NSString *extendId = [dictProduct objectForKey:@"extendId"];
    NSString *idProduct = [dictProduct objectForKey:@"idProduct"];
    
    NSString *charString = [NSString stringWithFormat:@"INSERT INTO cart (sku,standard_sku, description, quantity, value_product, save_percentage, thumb, extended, extended_value, extended_time, id_product, extended_id) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", sku, standardSku, description, qty, valueProduct, savePercentage, thumb, extended, extendedValue, extendTime, idProduct, extendId];
    
    const char *sql = [charString UTF8String];
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
            [[self delegate] errorDatabase];
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
            [[self delegate] errorDatabase];
        }
        
        sqlite3_finalize(preparedStatement);
    }
    LogMob(@"Added Cart ok!");
    
    sqlite3_close(dbase);

}

- (void) updateProductInCart:(NSDictionary *) dictProduct andExtend:(NSString *) extValue {
    
    //    [self assignDBPath];
    
    LogInfo(@"Product update: %@", dictProduct);
    
    // set up for app
    self.dbModelname = @"wmofertas.sqlite";
    
    // get full path of database in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
    
    sqlite3 *dbase;
    
    int ret = 0;
    
    NSString *sku = [dictProduct objectForKey:@"sku"];
    NSString *standardSku = [dictProduct objectForKey:@"standardSku"];
    NSString *description = [dictProduct objectForKey:@"descProduct"];
    NSString *valueProduct = [dictProduct objectForKey:@"valueProduct"];
    NSString *savePercentage = [dictProduct objectForKey:@"savePercentage"];
    NSString *thumb = [dictProduct objectForKey:@"imgProduct"];
    NSString *extended = [dictProduct objectForKey:@"extendProduct"];
    NSString *extendedValue = [dictProduct objectForKey:@"extendedValue"];
    NSString *extendTime = [dictProduct objectForKey:@"extendTime"];
    NSString *extendId = [dictProduct objectForKey:@"extendId"];
    NSString *idProduct = [dictProduct objectForKey:@"idProduct"];
    int qtyInCart = 0;
    
    NSArray*arrQty = [self getProductInCart:[NSString stringWithFormat:@"select * from cart where sku='%@' AND extended_value='%@'", sku, extValue]];
    LogInfo(@"ArrQty SKU: %@", arrQty);
    NSString *qtyPd = [[arrQty objectAtIndex:0] objectForKey:@"qtyProduct"];
    LogInfo(@"QtyPd: %@", qtyPd);
    
    if (![qtyPd isEqualToString:@""]) {
        qtyInCart = [qtyPd intValue];
        LogInfo(@"Qty cart: %i", qtyInCart);
        if (qtyInCart < 10) {
        qtyInCart = qtyInCart + 1;
        }
    }
    
    NSString *qty = [NSString stringWithFormat:@"%i", qtyInCart];
    
    NSString *charString = [NSString stringWithFormat:@"UPDATE cart SET standard_sku='%@',description='%@',quantity='%@',value_product='%@',save_percentage='%@',thumb='%@',extended='%@',extended_value='%@',extended_time='%@',id_product='%@', extended_id='%@' WHERE sku = '%@' AND extended_value='%@'", standardSku, description, qty, valueProduct, savePercentage, thumb, extended, extendedValue, extendTime, idProduct, extendId, sku, extValue];
    
    const char *sql = [charString UTF8String];
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
            [[self delegate] errorDatabase];
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
            [[self delegate] errorDatabase];
        }
        
        sqlite3_finalize(preparedStatement);
    }
    LogMob(@"Updated Cart ok!");
    
    sqlite3_close(dbase);
    
}


- (void) updateQtyProductInCart:(NSDictionary *) dictProduct {
    
    //    [self assignDBPath];
    
    LogInfo(@"Product update qty: %@", dictProduct);
    
    // set up for app
    self.dbModelname = @"wmofertas.sqlite";
    
    // get full path of database in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
    
    sqlite3 *dbase;
    
    int ret = 0;
    
    NSString *sku = [dictProduct objectForKey:@"sku"];
    NSString *standardSku = [dictProduct objectForKey:@"standardSku"];
    NSString *description = [dictProduct objectForKey:@"descProduct"];
    NSString *qty = [dictProduct objectForKey:@"qtyProduct"];
    NSString *valueProduct = [dictProduct objectForKey:@"valueProduct"];
    NSString *savePercentage = [dictProduct objectForKey:@"savePercentage"];
    NSString *thumb = [dictProduct objectForKey:@"imgProduct"];
    NSString *extended = [dictProduct objectForKey:@"extendProduct"];
    NSString *extendedValue = [dictProduct objectForKey:@"extendedValue"];
    NSString *extendTime = [dictProduct objectForKey:@"extendTime"];
    NSString *extendId = [dictProduct objectForKey:@"extendId"];
    NSString *idProduct = [dictProduct objectForKey:@"idProduct"];
    
    NSString *charString = [NSString stringWithFormat:@"UPDATE cart SET standard_sku='%@',description='%@',quantity='%@',value_product='%@',save_percentage='%@',thumb='%@',extended='%@',extended_value='%@',extended_time='%@',id_product='%@', extended_id='%@' WHERE sku = '%@' AND extended_value = '%@'", standardSku, description, qty, valueProduct, savePercentage, thumb, extended, extendedValue, extendTime, idProduct, extendId, sku, extendedValue];
    
    LogInfo(@"CharString: %@", charString);
    
    const char *sql = [charString UTF8String];
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
            [[self delegate] errorDatabase];
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
            [[self delegate] errorDatabase];
        }
        
        sqlite3_finalize(preparedStatement);
    }
    LogMob(@"Updated Cart qty ok!");
    
    sqlite3_close(dbase);
    
}


- (void) deleteProduct:(NSString *)sku andExtendValue:(NSString *) extValue {
    
    // set up for app
    self.dbModelname = @"wmofertas.sqlite";
    
    // get full path of database in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
    
    sqlite3 *dbase;  //Atencao: separando ele é mais seguro. Propagar para os outros metodos e nao usar a constante (database)
    
    int ret = 0;
    
    if(sqlite3_open([dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        NSString *charString = [NSString stringWithFormat:@"DELETE FROM cart WHERE sku='%@' AND extended_value='%@'", sku, extValue];
		const char *sql = [charString UTF8String];
		
		sqlite3_stmt *preparedStatement = nil;
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogErro(@"Error building statement to delete item [%s]", sqlite3_errmsg(dbase));
        }
        
		// Execute sql statement
		if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
			LogErro(@"Error deleting item [%s]", sqlite3_errmsg(dbase));
		}
        
		sqlite3_finalize(preparedStatement);
    }
    
    sqlite3_close(dbase);
}

- (BOOL) productInCart:(NSString *) skuProduct andExtended:(NSString *) valueExtended {
    
    NSArray *content = [self getProductInCart:[NSString stringWithFormat:@"select * from cart where sku='%@' and extended_value='%@'", skuProduct, valueExtended]];
    
    if ([content count] > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (NSArray *) getProductInCart:(NSString *) sqlString {
    
    sqlite3 *dbase;
    
    [self assignDBPath];
    
    const char *sqlStr = [sqlString UTF8String];
    
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
    
    // Open the database from the users filessytem
	if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        //		const char *sqlStatement = "select * from canais";
        const char *sqlStatement = sqlStr;
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(dbase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                // Read the data from the result row
                char *column1 = (char *)sqlite3_column_text(compiledStatement, 1);
                
                if (column1 != NULL) {
                    
                    NSString *sku = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]; //Coluna 0
                    NSString *standardSku = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]; //Coluna 1
                    NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)]; //Coluna 2
                    NSString *quantity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]; //Coluna 3
                    NSString *value_product = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)]; //Coluna 4
                    NSString *save_percentage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)]; //Coluna 5
                    NSString *thumb = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)]; //Coluna 6
                    NSString *extended = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)]; //Coluna 7
                    NSString *extended_value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)]; //Coluna 8
                    NSString *id_product = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)]; //Coluna 9
                    NSString *extend_time = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)]; //Coluna 10
                    NSString *extend_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)]; //Coluna 11
                    
                    NSDictionary *dictTemp = [[NSDictionary alloc] initWithObjectsAndKeys:id_product, @"idProduct", standardSku, @"standardSku", sku, @"sku", thumb, @"imgProduct", description, @"descProduct", quantity, @"qtyProduct", extended, @"extendProduct", extended_value, @"extendedValue", value_product, @"valueProduct", save_percentage, @"savePercentage", extend_time, @"extendTime", extend_id, @"extendId", nil];
                    
                    [arrTemp addObject:dictTemp];
                    
                } else {
                    LogErro(@"Cart: no values");
                    [arrTemp addObject:@""];
                }
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(dbase);
    LogInfo(@"SQLite Cart get Product: %@", arrTemp);
    
    return arrTemp;
    
}

- (void)cleanCart
{
    LogInfo(@"Deleting cart...");
    
    // set up for app
    self.dbModelname = @"wmofertas.sqlite";
    
    // get full path of database in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
    
    sqlite3 *dbase;
    //Atencao: separando ele é mais seguro. Propagar para os outros metodos e nao usar a constante (database)
    
    int ret = 0;
    if(sqlite3_open([dbpath UTF8String], &dbase) == SQLITE_OK)
    {
        NSString *charString = @"DELETE FROM cart";
		const char *sql = [charString UTF8String];

		sqlite3_stmt *preparedStatement = nil;
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql, -1, &preparedStatement, NULL)!=SQLITE_OK)
        {
            LogErro(@"Error building statement to delete item [%s]", sqlite3_errmsg(dbase));
        }

		// Execute sql statement
		if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE)
        {
			LogErro(@"Error deleting item [%s]", sqlite3_errmsg(dbase));
		}
		sqlite3_finalize(preparedStatement);
    }
    
    sqlite3_close(dbase);
}

- (BOOL) verifyByTable:(NSString *) table {
    
    sqlite3 *dbase;
    
    BOOL isOk = NO;
    
    [self assignDBPath];
    
    NSString *sqlString = [NSString stringWithFormat:@"select name from sqlite_master WHERE type='table' AND name='%@'", table];
    
    const char *sqlStr = [sqlString UTF8String];
    
    // Open the database from the users filessytem
	if (sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK)
    {
		// Setup the SQL Statement and compile it for faster access
        //		const char *sqlStatement = "select * from canais";
        const char *sqlStatement = sqlStr;
		sqlite3_stmt *compiledStatement;
		if (sqlite3_prepare_v2(dbase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                isOk = YES;
			}
		}
        else
        {
            isOk = NO;
        }
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(dbase);
    
    return isOk;
    
}

- (NSString *) getTokenAuth {
    
    sqlite3 *dbase;
    
    [self assignDBPath];

    NSString *sqlString = @"select * from tkOAuth";
    
    const char *sqlStr = [sqlString UTF8String];
    
    NSString *strToken = @"";
    
    // Open the database from the users filessytem
	if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        //		const char *sqlStatement = "select * from canais";
        const char *sqlStatement = sqlStr;
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(dbase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                // Read the data from the result row
                char *column1 = (char *)sqlite3_column_text(compiledStatement, 0);
                
                if (column1 != NULL) {
                    
                    NSString *tkAuth = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]; //Coluna 0
                    
                    LogInfo(@"Tok Auth  : %@", tkAuth);
                    
                    strToken = tkAuth;
                }
			}
		}
        
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(dbase);
    
    return strToken;
}


- (NSString *) getTokenCheck {
    
    sqlite3 *dbase;
    
    [self assignDBPath];
    
    NSString *sqlString = @"select * from tkCheck";
    
    const char *sqlStr = [sqlString UTF8String];
    
    NSString *strToken = @"";
    
    // Open the database from the users filessytem
	if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        //		const char *sqlStatement = "select * from canais";
        const char *sqlStatement = sqlStr;
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(dbase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                // Read the data from the result row
                char *column1 = (char *)sqlite3_column_text(compiledStatement, 0);
                
                if (column1 != NULL) {
                    
                    NSString *tkCheck = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]; //Coluna 0
                    
                    LogInfo(@"Tok Check  : %@", tkCheck);
                    
                    strToken = tkCheck;
                    
                }
			}
		}
        
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(dbase);
    
    return strToken;
}

- (NSString *) getCartId {
    
    sqlite3 *dbase;
    
    [self assignDBPath];
    
    NSString *sqlString = @"select * from cartId";
    
    const char *sqlStr = [sqlString UTF8String];
    
    NSString *strToken = @"";
    
    // Open the database from the users filessytem
	if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        //		const char *sqlStatement = "select * from canais";
        const char *sqlStatement = sqlStr;
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(dbase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                // Read the data from the result row
                char *column1 = (char *)sqlite3_column_text(compiledStatement, 0);
                
                if (column1 != NULL) {
                    
                    NSString *tkCheck = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]; //Coluna 0
                    
                    LogInfo(@"Cart Id  : %@", tkCheck);
                    
                    strToken = tkCheck;
                    
                }
			}
		}
        
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(dbase);
    
    return strToken;
}



- (BOOL) addTokenAuth:(NSString *) token {
    
    // set up for app
    self.dbModelname = @"wmofertas.sqlite";
    
    // get full path of database in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
    
    sqlite3 *dbase;
    
    int ret = 0;
    
    BOOL success = YES;
    
    NSString *charString = [NSString stringWithFormat:@"INSERT INTO tkOAuth (tok) VALUES ('%@')", token];
    
    const char *sql = [charString UTF8String];
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
            
            success = NO;
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
            
            success = NO;
        }
        
        sqlite3_finalize(preparedStatement);
    }
    
    sqlite3_close(dbase);
    
    return success;
}

- (BOOL) addTokenCheck:(NSString *) token {
    
    // set up for app
    self.dbModelname = @"wmofertas.sqlite";
    
    // get full path of database in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
    
    sqlite3 *dbase;
    
    int ret = 0;
    
    BOOL success = YES;
    
    NSString *charString = [NSString stringWithFormat:@"INSERT INTO tkCheck (tok) VALUES ('%@')", token];
    
    const char *sql = [charString UTF8String];
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
            
            success = NO;
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
            
            success = NO;
        }
        
        sqlite3_finalize(preparedStatement);
    }
    
    sqlite3_close(dbase);
    
    return success;
}


- (BOOL) addCartId:(NSString *)cart {
    
    LogInfo(@"SQLITE addCartId: %@", cart);
    
    // set up for app
    self.dbModelname = @"wmofertas.sqlite";
    
    // get full path of database in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
    
    sqlite3 *dbase;
    
    int ret = 0;
    
    BOOL success = YES;
    
    NSString *charString = [NSString stringWithFormat:@"INSERT INTO cartId (tok) VALUES ('%@')", cart];
    
    const char *sql = [charString UTF8String];
    
    if(sqlite3_open([self.dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        sqlite3_stmt *preparedStatement = NULL;
        
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogMob(@"Error building statement to insert item [%s]", sqlite3_errmsg(dbase));
            
            success = NO;
        }
        
        // Execute sql statement
        if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
            LogMob(@"Error inserting item [%s]", sqlite3_errmsg(dbase));
            
            success = NO;
        }
        
        sqlite3_finalize(preparedStatement);
    }
    
    sqlite3_close(dbase);
    
    return success;
}

- (BOOL) deleteAllTokenAuth {
    
    return [self deleAllContentFromTable:@"tkOAuth"];
}

- (BOOL) deleteAllTokenCheckout {
    
    return [self deleAllContentFromTable:@"tkCheck"];
}

- (BOOL) deleteAllCartId {
    
    return [self deleAllContentFromTable:@"cartId"];
}

- (BOOL) deleAllContentFromTable:(NSString *) table {
    
    // set up for app
    self.dbModelname = @"wmofertas.sqlite";
    
    // get full path of database in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.dbpath = [path stringByAppendingPathComponent:_dbModelname];
    
    sqlite3 *dbase;  //Atencao: separando ele é mais seguro. Propagar para os outros metodos e nao usar a constante (database)
    
    BOOL success = YES;
    
    int ret = 0;
    
    if(sqlite3_open([dbpath UTF8String], &dbase) == SQLITE_OK) {
        
        NSString *charString = [NSString stringWithFormat:@"DELETE FROM %@", table];
		const char *sql = [charString UTF8String];
		
		sqlite3_stmt *preparedStatement = nil;
        // first insert - build statement
        if (sqlite3_prepare_v2(dbase, sql, -1, &preparedStatement, NULL)!=SQLITE_OK){
            LogErro(@"Error building statement to delete item [%s]", sqlite3_errmsg(dbase));
            
            success = NO;
        }
        
		// Execute sql statement
		if ((ret=sqlite3_step(preparedStatement)) != SQLITE_DONE){
			LogErro(@"Error deleting item [%s]", sqlite3_errmsg(dbase));
            
            success = NO;
		}
        
		sqlite3_finalize(preparedStatement);
    }
    
    sqlite3_close(dbase);
    
    return success;
}

+ (BOOL)hasOldToken
{
    MDSSqlite *instance = [MDSSqlite new];
    id token = [instance getTokenAuth];
    if ([token isKindOfClass:NSString.class])
    {
        NSString *tokenValue = token;
        if (tokenValue.length > 0)
        {
            return YES;
        }
    }

    return NO;
}

+ (void)clearOldToken
{
    MDSSqlite *instance = [MDSSqlite new];
    [instance deleteAllTokenAuth];
}


@end
