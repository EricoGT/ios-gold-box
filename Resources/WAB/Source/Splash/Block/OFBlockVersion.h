//
//  OFBlockVersion.h
//  Walmart
//
//  Created by Marcelo Santos on 11/13/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol blockScreenDelegate <NSObject>
@required
- (void) showMessage:(NSDictionary *) buttonDict;
@optional
- (void) blockAlertAction;
//- (void) showBlockMessage:(UIView *) alertBlock;
//- (void) removeBlockMessage:(UIView *) alertBlock;
@end

@interface OFBlockVersion : NSObject {
    
    __weak id <blockScreenDelegate> delegate;
    BOOL isBlockVerify;
    NSString *URLToLoad;
}

@property (weak) id delegate;

- (void) blockScreenCheck:(NSDictionary *) content;

@end
