//
//  DatabaseConnection.h
//  Project-ObjectiveC
//
//  Created by Erico GT on 17/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "SQLiteManager.h"

@interface DatabaseConnection : NSObject

- (bool)saveData:(NSDictionary*)data;
- (bool)updateData;
- (NSDictionary*)loadData:(long)dataID;
- (bool)deleteData:(long)dataID;

@end
