//
//  FileManager.m
//  AdAlive
//
//  Created by Monique Trevisan on 11/12/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+(id)sharedInstance
{
    static FileManager *sharedFileManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFileManager = [[self alloc] init];
    });
    return sharedFileManager;
}
#pragma mark - General Methods

-(BOOL)directoryExists:(NSString *)directoryPath
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager fileExistsAtPath:directoryPath];
}

-(BOOL)fileExists:(NSString *)filePath
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager fileExistsAtPath:filePath];
}

-(BOOL)createDirectoryAtPath:(NSString *)directoryPath
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:nil];
}

-(BOOL)createFileAtPath:(NSString *)filePath
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager createFileAtPath:filePath contents:nil attributes:nil];
}

#pragma mark - User Data

-(BOOL)saveProfileData:(NSDictionary *)dicUser
{
    dicUser = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicUser withString:@""];
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
	NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_DIRECTORY]];
	
	if (![self directoryExists:profileDataDir])
	{
		if (![self createDirectoryAtPath:profileDataDir]) {
			return NO;
		}
	}
	
	NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_FILE]];
	
	if (![self fileExists:profileDataFile])
	{
		if (![self createFileAtPath:profileDataFile])
		{
			return NO;
		}
	}
	
    BOOL veri = [dicUser writeToFile:profileDataFile atomically:YES];
    
    return veri;

}

-(BOOL)deleteProfileData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_DIRECTORY]];
    NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_FILE]];
    //
    if([[NSFileManager defaultManager]isDeletableFileAtPath:profileDataFile])
    {
        NSError * err = NULL;
        if([[NSFileManager defaultManager] removeItemAtPath:profileDataFile error:&err])
        {
            return YES;
        }else{
            NSLog(@"Error: %@", err.description);
            return NO;
        }
    }
    else{
        return NO;
    }
}

-(NSDictionary *)getProfileData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_DIRECTORY]];
    
    NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_FILE]];
    
    return [NSDictionary dictionaryWithContentsOfFile:profileDataFile];
}

-(BOOL)removeProfile
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
	NSString *profileDataFile = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", PROFILE_DIRECTORY, PROFILE_FILE]];
	
	if ([self fileExists:profileDataFile])
	{
		NSFileManager *fileManager = [NSFileManager defaultManager];
		return [fileManager removeItemAtPath:profileDataFile error:nil];
	}
	
	return YES;
}

#pragma mark - Download Data

-(BOOL)saveDownloadsData:(NSDictionary *)dicDownloads
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", DOWNLOAD_DIRECTORY]];
    
    if (![self directoryExists:profileDataDir])
    {
        if (![self createDirectoryAtPath:profileDataDir]) {
            return NO;
        }
    }
    
    NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", DOWNLOAD_FILE]];
    
    if (![self fileExists:profileDataFile])
    {
        if (![self createFileAtPath:profileDataFile])
        {
            return NO;
        }
    }
    
    return [dicDownloads writeToFile:profileDataFile atomically:YES];
}

-(BOOL)deleteDownloadsData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", DOWNLOAD_DIRECTORY]];
    NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", DOWNLOAD_FILE]];
    //
    if([[NSFileManager defaultManager]isDeletableFileAtPath:profileDataFile])
    {
        NSError * err = NULL;
        if([[NSFileManager defaultManager] removeItemAtPath:profileDataFile error:&err])
        {
            return YES;
        }else{
            NSLog(@"Error: %@", err.description);
            return NO;
        }
    }
    else{
        return NO;
    }
}

-(NSDictionary*)getDownloadsData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *downloadDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", DOWNLOAD_DIRECTORY]];
    
    if (![self directoryExists:downloadDataDir])
    {
        if (![self createDirectoryAtPath:downloadDataDir]) {
            NSLog(@"Não foi possível criar o diretório para armazenamento dos downloads.");
            return nil;
        }
    }
    
    NSString *downloadDataFile = [downloadDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", DOWNLOAD_FILE]];
    
    return [NSDictionary dictionaryWithContentsOfFile:downloadDataFile];
}

#pragma mark - Exemplos

- (bool)saveUserScans:(NSArray*)scanList withUserIdentifier:(NSString*)userIdentifier
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_DIRECTORY]];
    
    if (![self directoryExists:profileDataDir])
    {
        if (![self createDirectoryAtPath:profileDataDir]) {
            return NO;
        }
    }
    
    NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", userIdentifier]];
    
    if (![self fileExists:profileDataFile])
    {
        if (![self createFileAtPath:profileDataFile])
        {
            return NO;
        }
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:scanList,  userIdentifier,nil];
    return [dic writeToFile:profileDataFile atomically:YES];
}

- (NSArray*)loadUserScans:(NSString*)userIdentifier
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_DIRECTORY]];
    
    NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", userIdentifier]];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:profileDataFile];
    
    if(dic){
        return [NSArray arrayWithArray:[dic valueForKey:userIdentifier]];
    }else{
        return [NSArray new];
    }
}

@end
