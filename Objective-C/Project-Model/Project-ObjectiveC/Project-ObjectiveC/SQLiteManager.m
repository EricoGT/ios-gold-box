//
//  SQLiteManager.m
//  Project-ObjectiveC
//
//  Created by Erico GT on 17/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "SQLiteManager.h"

@implementation SQLiteManager

@synthesize database;

+ (dispatch_queue_t)sqliteConectionQueue
{
    return dispatch_queue_create("br.com.atlantic.Project-ObjectiveC.sqlite", DISPATCH_QUEUE_SERIAL);
}

#pragma mark -
//-------------------------------------------------------------------------------------------------------------
- (BOOL)databaseExists
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dbPath = [self dbPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    return success;
}

//-------------------------------------------------------------------------------------------------------------
- (BOOL)copyDBToUserDocuments
{
    BOOL copiado = FALSE;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self dbPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if (!success)
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[self dbName]];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
        {
            NSLog(@"Erro ao copiar Banco de Dados: %@.", error.localizedDescription);
        }
        else
        {
            NSLog(@"Banco de Dados copiado.");
            copiado = TRUE;
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
    }
    else
    {
        NSLog(@"Banco de dados já existe.");
    }
    
    return copiado;
}

//-------------------------------------------------------------------------------------------------------------
- (BOOL)openDB_Connection
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[self dbName]];
    
    BOOL ok = YES;
    
    @try
    {
        if (sqlite3_open([path UTF8String], &database) != SQLITE_OK)
        {
            ok = NO;
            //
            if (database){
                NSLog(@"Erro ao abrir banco de dados: %@", sqlite3_errmsg(database));
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", [exception reason]);
        ok = NO;
    }
    @finally
    {
        return ok;
    }
}

//-------------------------------------------------------------------------------------------------------------
- (BOOL)closeDB_Connection
{
    BOOL ok = YES;
    
    @try
    {
        if (sqlite3_close(database) != SQLITE_OK)
        {
            ok = NO;
            //
            if (database){
                NSLog(@"Erro ao fechar banco de dados: %@", sqlite3_errmsg(database));
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", [exception reason]);
        ok = NO;
    }
    @finally
    {
        return ok;
    }
}

//-------------------------------------------------------------------------------------------------------------
- (BOOL)deleteDB
{
    BOOL ok = TRUE;
    
    @try
    {
        NSString* aPath = [self dbPath];
        if([[NSFileManager defaultManager]isDeletableFileAtPath:aPath])
        {
            [[NSFileManager defaultManager]removeItemAtPath:aPath error:nil];
        }else{
            ok = FALSE;
        }
    }
    @catch (NSException *exception)
    {
        ok = FALSE;
        NSLog(@"Erro ao excluir Bando de Dados: %@", [exception reason]);
    }
    @finally
    {
        return ok;
    }
}


//-------------------------------------------------------------------------------------------------------------
- (BOOL)compactDB:(long)minimumBytesSize
{
    bool ok = true;
    long tamanhoInicial = 0;
    long tamanhoFinal = 0;
    
    NSError *error = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self dbPath] error:&error];
    
    if (!error)
    {
        NSNumber *size = [attributes objectForKey:NSFileSize];
        
        tamanhoInicial = [size longValue]; //valor em bytes
        
        if((minimumBytesSize > 0) && (tamanhoInicial > minimumBytesSize))
        {
            [self openDB_Connection]; //ABRE CONEXÃO
            
            @try
            {
                const char *ccsql = "VACUUM;";
                sqlite3_stmt *stmt;
                char *errmsg;
                
                //prepare
                if(sqlite3_prepare(database, ccsql, -1, &stmt, NULL) != SQLITE_OK)
                {
                    NSAssert1(0, @"Erro no SQL: '%s'.", sqlite3_errmsg(database));
                }
                
                //execute
                if(sqlite3_exec(database, ccsql, nil, &stmt, &errmsg) != SQLITE_OK)
                {
                    ok = false;
                    NSLog(@"Erro ao executar comando sql: '%s'.", sqlite3_errmsg(database));
                }
                
                sqlite3_finalize(stmt);
            }
            @catch (NSException *exception)
            {
                ok = false;
                NSLog(@"Exception: %@", [exception reason]);
            }
            @finally
            {
                [self closeDB_Connection];
            }
        }
        else
        {
            ok = false;
        }
    }
    else
    {
        ok = false;
    }
    
    if(ok)
    {
        attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self dbPath] error:&error];
        if (!error)
        {
            NSNumber *size = [attributes objectForKey:NSFileSize];
            tamanhoFinal = [size longValue]; //valor em bytes
        }
        
        NSLog(@"Banco de dados compactado: %i (de: %lu para: %lu)", ok, tamanhoInicial, tamanhoFinal);
    }
    
    return ok;
}

//-------------------------------------------------------------------------------------------------------------
- (BOOL)executeScriptFromFile:(NSString*)fileName
{
    BOOL sucesso = NO;
    
    NSError *err;
    NSString *script_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSString *script = [[NSString alloc] initWithContentsOfFile:script_path encoding:NSUTF8StringEncoding error:&err];
    if(script != nil)
    {
        sucesso = [self executeSQL:script];
    }
    else
    {
        NSLog(@"Erro ao abrir arquivo '%@': %@", fileName, [err description]);
    }
    
    NSLog(@"Resultado do executar script de arquivo: %@", (sucesso ? @"Sucesso" : @"Erro"));
    return sucesso;
}

//-------------------------------------------------------------------------------------------------------------
- (BOOL)executeSQL:(NSString*)sql
{
    __block BOOL sucesso = YES;
    
    dispatch_sync([SQLiteManager sqliteConectionQueue], ^{
        
        [self openDB_Connection];
        
        @try
        {
            sqlite3_exec(database, "BEGIN", 0, 0, 0); // BEGIN TRANSACTION
            
            const char *ccsql = [sql cStringUsingEncoding:NSUTF8StringEncoding];
            sqlite3_stmt *stmt;
            char *errmsg;
            
            //prepare
            if(sqlite3_prepare(database, ccsql, -1, &stmt, NULL) != SQLITE_OK)
            {
                NSAssert1(0, @"Erro no SQL: '%s'.", sqlite3_errmsg(database));
            }
            
            //execute
            if(sqlite3_exec(database, ccsql, nil, &stmt, &errmsg) != SQLITE_OK)
            {
                sucesso = NO;
                NSLog(@"Erro ao executar comando sql: '%s'.", sqlite3_errmsg(database));
            }
            
            sqlite3_finalize(stmt);
            
            if(sucesso)
            {
                sqlite3_exec(database, "COMMIT", 0, 0, 0); // COMMIT TRANSACTION
            }
            else
            {
                sqlite3_exec(database, "ROLLBACK", 0, 0, 0); // ROLLBACK TRANSACTION
            }
        }
        @catch (NSException *exception)
        {
            sucesso = NO;
            NSLog(@"Exception: %@", [exception reason]);
        }
        @finally
        {
            NSLog(@"Comando sql executado com sucesso? : %@",(sucesso ? @"Sucesso" : @"Erro"));
            [self closeDB_Connection]; //FECHA CONEXÃO
        }
    });
    
    return sucesso;
}

#pragma mark -

- (NSString *)dbPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:[self dbName]];
}

-(NSString*)dbName
{
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
    NSString *n = [preferencias objectForKey:DATABASE_DEFAULT_NAME];
    if(n == nil)
    {
        return defaultSQLiteDataBaseName;
    }
    else
    {
        return n;
    }
}


//-------------------------------------------------------------------------------------------------------------
#pragma mark -
-(NSString*)executaSelectNaTabela:(NSString*)nomeTabela
{
    [self openDB_Connection]; //ABRE CONEXÃO
    
    NSMutableString *text = [NSMutableString new];
    
    @try
    {
        sqlite3_exec(database, "BEGIN", 0, 0, 0); // BEGIN TRANSACTION
        //******************* ******************* *******************
        
        //PARTE 1:
        NSString *s = [NSString stringWithFormat:@"pragma table_info(%@)",nomeTabela];
        const char *sql = [s cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *sqlStatement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Erro ao executar comando SQL: '%s'.", sqlite3_errmsg(database));
        }
        
        int nl = 0;
        [text appendString:@"[ "];
        while(sqlite3_step(sqlStatement) == SQLITE_ROW)
        {
            const char* t = (const char*)sqlite3_column_text(sqlStatement, 1);
            NSString *fieldName = t ? [NSString stringWithCString:t encoding:NSUTF8StringEncoding] : @"";
            
            [text appendString:fieldName];
            [text appendString:@" , "];
            
            nl += 1;
        }
        sqlite3_finalize(sqlStatement);
        
        [text appendString:@"]\n"];
        text = [[NSMutableString alloc]initWithString:[text stringByReplacingOccurrencesOfString:@" , ]" withString:@" ]"]];
        
        //PARTE 2:
        NSString *s2 = [NSString stringWithFormat:@"SELECT * FROM %@",nomeTabela];
        const char *sql2 = [s2 cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *sqlStatement2;
        
        if (sqlite3_prepare_v2(database, sql2, -1, &sqlStatement2, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Erro ao executar comando SQL: '%s'.", sqlite3_errmsg(database));
        }
        
        while(sqlite3_step(sqlStatement2) == SQLITE_ROW)
        {
            for(int i=0; i<nl; i++)
            {
                const char* t = (const char*)sqlite3_column_text(sqlStatement2, i);
                NSString *fieldName = t ? [NSString stringWithCString:t encoding:NSUTF8StringEncoding] : @"";
                
                if(fieldName == nil) //Proteção contra colunas BLOB (imagens não são convertidas em texto...)
                {
                    fieldName = @"<imagem>";
                }
                
                if(nl < 3) //Tabela com 2 colunas
                {
                    if(i==0)
                    {
                        [text appendString:@"[ "];
                        [text appendString:fieldName];
                        [text appendString:@" , "];
                    }
                    else
                    {
                        [text appendString:fieldName];
                        [text appendString:@" ]\n"];
                    }
                }
                else //Tabela com 3 ou mais colunas
                {
                    if(i==0)
                    {
                        [text appendString:@"[ "];
                        [text appendString:fieldName];
                        [text appendString:@" , "];
                    }
                    else if(i == (nl-1))
                    {
                        [text appendString:fieldName];
                        [text appendString:@" ]\n"];
                    }
                    else
                    {
                        [text appendString:fieldName];
                        [text appendString:@" , "];
                    }
                }
            }
        }
        
        sqlite3_finalize(sqlStatement2);
        
        //******************* ******************* *******************
        sqlite3_exec(database, "COMMIT", 0, 0, 0); // COMMIT TRANSACTION
    }
    @catch (NSException *exception)
    {
        text = [[NSMutableString alloc]initWithString:[text stringByReplacingOccurrencesOfString:@"[ ]\n" withString:@""]];
        [text appendString:[NSString stringWithFormat:@"ERRO!\nException reason: %@\n",[exception reason]]];
        NSLog(@"Exception: %@", [exception reason]);
    }
    @finally
    {
        [self closeDB_Connection]; //FECHA CONEXÃO
    }
    
    return text ;
}

#pragma mark -
-(int)buscaIndiceNaColuna1:(NSString*)coluna1 DaColuna2:(NSString*)coluna2 ParaID:(int)indice NaTabela:(NSString*)tabela
{
    SQLiteManager *csql = [SQLiteManager new];
    [csql openDB_Connection]; //ABRE CONEXÃO
    
    int result = 0;
    
    @try
    {
        NSString *s = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = %i LIMIT 1",coluna1, tabela, coluna2, indice];
        const char *sql = [s cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare_v2(csql.database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Erro ao executar comando SQL: '%s'.", sqlite3_errmsg(csql.database));
        }
        
        if(sqlite3_step(sqlStatement)== SQLITE_ROW)
        {
            result = sqlite3_column_int64(sqlStatement, 0);
        }
        
        sqlite3_finalize(sqlStatement);
    }
    
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", [exception reason]);
    }
    @finally
    {
        NSLog(@"Coluna requerida: %@ / Coluna Procurada: %@ / Tabela Busca: %@ / Valor parâmetro: %i / Valor encontrado: %i", coluna1, coluna2, tabela, indice, result);
        [csql closeDB_Connection]; //FECHA CONEXÃO
    }
    
    return result;
}

-(int)buscaIndiceNaColuna1:(NSString*)coluna1 DaColuna2:(NSString*)coluna2 ParaID:(int)indice NaTabela:(NSString*)tabela ComWhereDaColuna:(NSString*)colunaWhere EValor:(int)idWhere
{
    SQLiteManager *csql = [SQLiteManager new];
    [csql openDB_Connection]; //ABRE CONEXÃO
    
    int result = 0;
    
    @try
    {
        NSString *s = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = %i AND %@ = %i LIMIT 1",coluna1, tabela, coluna2, indice, colunaWhere, idWhere];
        const char *sql = [s cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare_v2(csql.database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Erro ao executar comando SQL: '%s'.", sqlite3_errmsg(csql.database));
        }
        
        if(sqlite3_step(sqlStatement)== SQLITE_ROW)
        {
            result = sqlite3_column_int64(sqlStatement, 0);
        }
        
        sqlite3_finalize(sqlStatement);
    }
    
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", [exception reason]);
    }
    @finally
    {
        NSLog(@"Coluna requerida: %@ / Coluna Procurada: %@ / Tabela Busca: %@ / Valor parâmetro: %i / Where: %@ / idWhere: %i / Valor encontrado: %i", coluna1, coluna2, tabela, indice, colunaWhere, idWhere, result);
        [csql closeDB_Connection]; //FECHA CONEXÃO
    }
    
    return result;
}

#pragma mark -
-(int)buscaCOUNTdaColuna:(NSString*)nomeColuna NaTABLE:(NSString*)nomeTabela WHERE:(NSString*)condicao
{
    int result = 0;
    
    if(nomeColuna == nil || [nomeColuna isEqualToString:@""] || nomeTabela == nil || [nomeTabela isEqualToString:@""])
    {
        return result;
    }
    
    NSString *sqlBusca;
    
    if(condicao == nil || [condicao isEqualToString:@""])
    {
        sqlBusca = [NSString stringWithFormat:@"SELECT COUNT(%@) FROM %@", nomeColuna, nomeTabela];
    }
    else
    {
        sqlBusca = [NSString stringWithFormat:@"SELECT COUNT(%@) FROM %@ WHERE %@", nomeColuna, nomeTabela, condicao];
    }
    
    //pesquisa
    SQLiteManager *csql = [[SQLiteManager alloc]init];
    [csql openDB_Connection]; //ABRE CONEXÃO
    
    @try
    {
        const char *sql = [sqlBusca cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare_v2(csql.database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Erro ao executar comando SQL: '%s'.", sqlite3_errmsg(csql.database));
        }
        
        if(sqlite3_step(sqlStatement)== SQLITE_ROW)
        {
            result = sqlite3_column_int64(sqlStatement, 0);
        }
        
        sqlite3_finalize(sqlStatement);
    }
    
    @catch (NSException *exception)
    {
        NSLog(@"Exception: %@", [exception reason]);
    }
    @finally
    {
        [csql closeDB_Connection]; //FECHA CONEXÃO
    }
    
    return result;
}

#pragma mark -
-(NSString*)buscaTextoNaColuna1:(NSString*)coluna1 DaColuna2:(NSString*)coluna2 ParaID:(int)indice NaTabela:(NSString*)tabela
{
    SQLiteManager *csql = [SQLiteManager new];
    [csql openDB_Connection]; //ABRE CONEXÃO
    
    NSString *result = @"";
    
    @try
    {
        NSString *s = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = %i LIMIT 1",coluna1, tabela, coluna2, indice];
        const char *sql = [s cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare_v2(csql.database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Erro ao executar comando SQL: '%s'.", sqlite3_errmsg(csql.database));
        }
        
        if(sqlite3_step(sqlStatement)== SQLITE_ROW)
        {
            const char* r = (const char*)sqlite3_column_text(sqlStatement, 0);
            result = r ? [NSString stringWithCString:r encoding:NSUTF8StringEncoding] : @"";
        }
        
        sqlite3_finalize(sqlStatement);
    }
    
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", [exception reason]);
    }
    @finally
    {
        NSLog(@"Coluna requerida: %@ / Coluna Procurada: %@ / Tabela Busca: %@ / Valor parâmetro: %i / Valor encontrado: %@", coluna1, coluna2, tabela, indice, result);
        [csql closeDB_Connection]; //FECHA CONEXÃO
    }
    
    return result;
}

@end
