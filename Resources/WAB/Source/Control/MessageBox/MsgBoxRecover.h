//
//  MsgBoxRecover.h
//  Ofertas
//
//  Created by Marcelo Santos on 9/20/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMButton;

@protocol passRecoverDelegate <NSObject>
@required
@optional
- (void) showLoginBox;
@end


@interface MsgBoxRecover : WMBaseViewController {
    
    __weak id <passRecoverDelegate> delegate;
    
    //Status Box
    IBOutlet UIView *viewStatusAlert;
    IBOutlet UILabel *lblMessage;
    IBOutlet UIImageView *iconStatus;
    IBOutlet WMButton *btOk;
    NSDictionary *dictSkin;
    BOOL isError;
    BOOL isSkin;
    NSString *message;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andMsg:(NSString *) msg andIsError:(BOOL) isAnError;

@property (weak) id delegate;
@property (nonatomic, retain) NSDictionary *dictSkin;
@property (nonatomic, retain) NSString *message;

//Status Box
- (IBAction) ok;

@end
