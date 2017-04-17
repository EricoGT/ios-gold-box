//
//  DatabaseConnection.m
//  Project-ObjectiveC
//
//  Created by Erico GT on 17/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "DatabaseConnection.h"

@implementation DatabaseConnection

- (bool)saveData:(NSDictionary*)data
{
    __block bool success = true;
    
    dispatch_sync([SQLiteManager sqliteConectionQueue], ^{
        
        SQLiteManager *sqliteM = [SQLiteManager new];
        
        //Open Connection:
        if ([sqliteM openDB_Connection])
        {
            @try
            {
                sqlite3_exec(sqliteM.database, "BEGIN", 0, 0, 0); // BEGIN TRANSACTION
                bool abort = false;
                
                //First block to insert
                {
                    const char *sql = "INSERT INTO tb_exemplo (id_exemplo, nm_exemplo, value_exemplo) VALUES (?,?,?)";
                    sqlite3_stmt *sqlStatement;
                    
                    if(sqlite3_prepare(sqliteM.database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
                    {
                        NSAssert1(0, @"Erro no SQL: '%s'.", sqlite3_errmsg(sqliteM.database));
                    }
                    
                    //Binds:
                    
                    //id_exemplo
                    sqlite3_bind_int(sqlStatement, 1, [[data valueForKey:@"id_exemplo"]intValue]);
                    //nm_exemplo
                    sqlite3_bind_text(sqlStatement, 2, [[data valueForKey:@"nm_exemplo"] UTF8String], -1, SQLITE_TRANSIENT);
                    //value_exemplo
                    sqlite3_bind_double(sqlStatement, 3, [[data valueForKey:@"value_exemplo"]floatValue]);
                    
                    //blob
                    //NSData* imagem = UIImagePNGRepresentation(UIImage);
                    //sqlite3_bind_blob(sqlStatement, 4, [imagem bytes], (int)[imagem length], SQLITE_TRANSIENT);
                    
                    //Executando
                    if (sqlite3_step(sqlStatement) != SQLITE_DONE)
                    {
                        abort = true;
                        success = false;
                        NSLog(@"Insert Fail: %@", [NSString stringWithCString:sqlite3_errmsg(sqliteM.database) encoding:NSUTF8StringEncoding]);
                        //
                        //NSAssert1(0, @"Erro ao inserir dados: '%s'.", sqlite3_errmsg(sqliteM.database));
                    }
                    
                    sqlite3_finalize(sqlStatement);
                }
                
                //Second block to insert
                //{
                //Não esquecer do 'sqlite3_finalize'
                //}
                
                if(abort)
                {
                    sqlite3_exec(sqliteM.database, "ROLLBACK", 0, 0, 0); // ROLLBACK TRANSACTION
                }
                else
                {
                    sqlite3_exec(sqliteM.database, "COMMIT", 0, 0, 0); // COMMIT TRANSACTION
                }
            }
            @catch (NSException *exception)
            {
                success = false;
                NSLog(@"Exception: %@", [exception reason]);
            }
            @finally
            {
                NSLog(@"Insert Success: %i", success);
                [sqliteM closeDB_Connection]; //FECHA CONEXÃO
            }
        }else{
            success = false;
        }
    });
    
    return success;
}

- (bool)updateData
{
    __block bool success = true;
    
    dispatch_sync([SQLiteManager sqliteConectionQueue], ^{
        
        SQLiteManager *sqliteM = [SQLiteManager new];
        
        //Open Connection:
        if ([sqliteM openDB_Connection])
        {
            @try
            {
                sqlite3_exec(sqliteM.database, "BEGIN", 0, 0, 0); // BEGIN TRANSACTION
                bool abort = false;
                
                //First block to insert
                {
                    const char *sql = "UPDATE tb_exemplo SET nm_exemplo = ? WHERE id_exemplo = 1";
                    sqlite3_stmt *sqlStatement;
                    
                    if(sqlite3_prepare(sqliteM.database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
                    {
                        NSAssert1(0, @"Erro no SQL: '%s'.", sqlite3_errmsg(sqliteM.database));
                    }
                    
                    //Binds:
                    
                    //nm_exemplo
                    sqlite3_bind_text(sqlStatement, 1, [@"updated_text" UTF8String], -1, SQLITE_TRANSIENT);
                    
                    //blob
                    //NSData* imagem = UIImagePNGRepresentation(UIImage);
                    //sqlite3_bind_blob(sqlStatement, 4, [imagem bytes], (int)[imagem length], SQLITE_TRANSIENT);
                    
                    //Executando
                    if (sqlite3_step(sqlStatement) != SQLITE_DONE)
                    {
                        abort = true;
                        success = false;
                        NSLog(@"Update Fail: %s", sqlite3_errmsg(sqliteM.database));
                        //
                        //NSAssert1(0, @"Erro ao inserir dados: '%s'.", sqlite3_errmsg(sqliteM.database));
                    }
                    
                    sqlite3_finalize(sqlStatement);
                }
                
                //Second block to insert
                //{
                //Não esquecer do 'sqlite3_finalize'
                //}
                
                if(abort)
                {
                    sqlite3_exec(sqliteM.database, "ROLLBACK", 0, 0, 0); // ROLLBACK TRANSACTION
                }
                else
                {
                    sqlite3_exec(sqliteM.database, "COMMIT", 0, 0, 0); // COMMIT TRANSACTION
                }
            }
            @catch (NSException *exception)
            {
                success = false;
                NSLog(@"Exception: %@", [exception reason]);
            }
            @finally
            {
                NSLog(@"Insert Success: %i", success);
                [sqliteM closeDB_Connection]; //FECHA CONEXÃO
            }
        }else{
            success = false;
        }
    });
    
    return success;
}

- (NSDictionary*)loadData:(long)dataID
{
    NSMutableDictionary __block *result = [NSMutableDictionary new];
    
    dispatch_sync([SQLiteManager sqliteConectionQueue], ^{
        
        SQLiteManager *sqliteM = [SQLiteManager new];
        [sqliteM openDB_Connection]; //ABRE CONEXÃO
        
        @try
        {
            const char *sql = "SELECT TE.id_exemplo, TE.nm_exemplo, TE.value_exemplo FROM tb_exemplo TE WHERE TE.id_exemplo = ?";
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare_v2(sqliteM.database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
            {
                NSAssert1(0, @"Erro ao executar comando SQL: '%s'.", sqlite3_errmsg(sqliteM.database));
            }
            sqlite3_bind_int64(sqlStatement, 1, dataID);
            
            while(sqlite3_step(sqlStatement) == SQLITE_ROW)
            {
                //id
                long exemploID = sqlite3_column_int64(sqlStatement, 0);
                [result setValue:@(exemploID) forKey:@"id_exemplo"];

                //nome
                const char* nm = (const char*)sqlite3_column_text(sqlStatement, 1);
                NSString *n = nm ? [NSString stringWithCString:nm encoding:NSUTF8StringEncoding] : @"";
                [result setValue:n forKey:@"nm_exemplo"];
                
                //value
                float var = sqlite3_column_double(sqlStatement, 2);
                [result setValue:@(var) forKey:@"value_exemplo"];
                
                /*
                //exemplo imagem
                const char *raw = sqlite3_column_blob(sqlStatement, 3);
                int rawLen = sqlite3_column_bytes(sqlStatement, 3);
                
                if(rawLen == 0)
                {
                    //
                }
                else
                {
                    //NSData *data = [NSData dataWithBytes:raw length:rawLen];
                    //UIImage = [[UIImage alloc] initWithData:data];
                }
                 */
                
            }
            sqlite3_finalize(sqlStatement);
            
            //Para uma linha pode ser utilizado:
            //if(sqlite3_step(sqlStatement)== SQLITE_ROW) {}
        }
        @catch (NSException *exception) {
            NSString *description = [NSString stringWithFormat:@"\n\n********** Erro SQLite ***********\nClasse: %@\nMétodo: %@\nLinha: %d\nDescrição: Exceção - %@\n********** Erro SQLite ***********\n\n", [self class], NSStringFromSelector(_cmd), __LINE__, [exception reason]];
            NSLog(@"Exception: %@", description);
        }
        @finally
        {
            NSLog(@"Select Success: %i", result.count);
            [sqliteM closeDB_Connection]; //FECHA CONEXÃO
        }
        
    });
    
    return result;
}

- (bool)deleteData:(long)dataID
{
    __block bool ok = true;
    
    dispatch_sync([SQLiteManager sqliteConectionQueue], ^{
        
        SQLiteManager *sqliteM = [SQLiteManager new];
        [sqliteM openDB_Connection]; //ABRE CONEXÃO
        
        @try
        {
            const char *sql = "DELETE FROM tb_exemplo WHERE id_exemplo = ?";
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(sqliteM.database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
            {
                NSAssert1(0, @"Erro no SQL: '%s'.", sqlite3_errmsg(sqliteM.database));
            }
            sqlite3_bind_int64(sqlStatement, 1, dataID);
            
            if (sqlite3_step(sqlStatement) != SQLITE_DONE)
            {
                NSAssert1(0, @"Erro ao excluir registro: '%s'.", sqlite3_errmsg(sqliteM.database));
            }
            sqlite3_finalize(sqlStatement);
            
        }
        @catch (NSException *exception)
        {
            ok = false;
            NSString *description = [NSString stringWithFormat:@"\n\n********** Erro SQLite ***********\nClasse: %@\nMétodo: %@\nLinha: %d\nDescrição: Exceção - %@\n********** Erro SQLite ***********\n\n", [self class], NSStringFromSelector(_cmd), __LINE__, [exception reason]];
            NSLog(@"Exception: %@", description);
        }
        @finally
        {
            NSLog(@"Delete Success: %d",ok);
            [sqliteM closeDB_Connection]; //FECHA CONEXÃO
        }
    });
                  
    return ok;
}

@end
