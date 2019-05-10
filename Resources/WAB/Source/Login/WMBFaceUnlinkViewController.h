//
//  WMBFaceUnlinkViewController.h
//  Walmart
//
//  Created by Marcelo Santos on 12/13/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol faceUnlinkDelegate <NSObject>
@optional
- (void)closeWarning;
- (void) unlinkFace;
@end

@interface WMBFaceUnlinkViewController : UIViewController

@property (nonatomic, strong) NSString *strGuid;
@property (nonatomic, assign) id <faceUnlinkDelegate> delegate;

@end
