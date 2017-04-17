//
//  FileManager.h
//  AdAlive
//
//  Created by Monique Trevisan on 11/12/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

#import "ConstantsManager.h"
#import "ToolBox.h"

@interface FileManager : NSObject

+(id)sharedInstance;

//User Profile
-(BOOL)saveProfileData:(NSDictionary *)dicUser;
-(BOOL)deleteProfileData;
-(NSDictionary *)getProfileData;

//Downloads Data
-(BOOL)saveDownloadsData:(NSDictionary *)dicDownloads;
-(BOOL)deleteDownloadsData;
-(NSDictionary*)getDownloadsData;

@end
