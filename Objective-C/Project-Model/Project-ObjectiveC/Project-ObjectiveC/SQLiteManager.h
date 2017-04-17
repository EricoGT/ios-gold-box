//
//  SQLiteManager.h
//  Project-ObjectiveC
//
//  Created by Erico GT on 17/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ToolBox.h"
#import "ConstantsManager.h"

#define defaultSQLiteDataBaseName @"database.sqlite"

@interface SQLiteManager : NSObject

@property(nonatomic, assign) sqlite3 *database;;

//Métodos de preparação:
- (BOOL)databaseExists;
- (BOOL)copyDBToUserDocuments;
- (BOOL)openDB_Connection;
- (BOOL)closeDB_Connection;
- (BOOL)deleteDB;
//VACCUM (compactação):
- (BOOL)compactDB:(long)minimumBytesSize;
//Executar de arquivo:
- (BOOL)executeScriptFromFile:(NSString*)fileName;
- (BOOL)executeSQL:(NSString*)sql;
//
+ (dispatch_queue_t)sqliteConectionQueue;

//Especiais
//-(NSString*)executaSelectNaTabela:(NSString*)nomeTabela;
//-(int)buscaIndiceNaColuna1:(NSString*)coluna1 DaColuna2:(NSString*)coluna2 ParaID:(int)indice NaTabela:(NSString*)tabela;
//-(int)buscaIndiceNaColuna1:(NSString*)coluna1 DaColuna2:(NSString*)coluna2 ParaID:(int)indice NaTabela:(NSString*)tabela ComWhereDaColuna:(NSString*)colunaWhere EValor:(int)idWhere;
//-(int)buscaCOUNTdaColuna:(NSString*)nomeColuna NaTABLE:(NSString*)nomeTabela WHERE:(NSString*)condicao;
//-(NSString*)buscaTextoNaColuna1:(NSString*)coluna1 DaColuna2:(NSString*)coluna2 ParaID:(int)indice NaTabela:(NSString*)tabela;

@end
